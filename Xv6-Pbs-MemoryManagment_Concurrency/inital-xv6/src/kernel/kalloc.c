// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run
{
  struct run *next;
};

struct
{
  struct spinlock lock;
  struct run *freelist;
} kmem;

struct
{
  struct spinlock lock;
  int page_usage_count[PGROUNDUP(PHYSTOP) >> 12];
} page_tracker;

// void initialize_page()
void init_page_tracker()
{
  int i;
  initlock(&page_tracker.lock, "page_tracker");
  acquire(&page_tracker.lock);
  for (i = 0; i < PGROUNDUP(PHYSTOP) >> 12; i++)
  {
    page_tracker.page_usage_count[i] = 0;
  }
  release(&page_tracker.lock);
}

// int extract_page(void *pa)
int get_page_usage(void *pa)
{
  acquire(&page_tracker.lock);
  int res = page_tracker.page_usage_count[(uint64)pa >> 12];
  release(&page_tracker.lock);
  if (res >= 0)
  {
    return res;
  }
  panic("get_page_usage");
  return -1;
}

// void increment_page(void *pa)
void increment_page_usage(void *pa)
{
  acquire(&page_tracker.lock);
  if (page_tracker.page_usage_count[(uint64)pa >> 12] >= 0)
  {
    page_tracker.page_usage_count[(uint64)pa >> 12] += 1;
  }
  else
  {
    panic("increment_page_usage");
    return;
  }
  release(&page_tracker.lock);
  return;
}

void decrement_page_usage(void *pa)
{
  acquire(&page_tracker.lock);
  if (page_tracker.page_usage_count[(uint64)pa >> 12] > 0)
  {
    page_tracker.page_usage_count[(uint64)pa >> 12] -= 1;
  }
  else
  {
    panic("decrement_page_usage");
    return;
  }
  release(&page_tracker.lock);
  return;
}

void kinit()
{
  init_page_tracker();
  initlock(&kmem.lock, "kmem");
  freerange(end, (void *)PHYSTOP);
}

void freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char *)PGROUNDUP((uint64)pa_start);
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
  {
    increment_page_usage(p);
    kfree(p);
  }
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");
  acquire(&page_tracker.lock);
  if (page_tracker.page_usage_count[(uint64)pa >> 12] <= 0)
  {
    panic("decrement_page_usage");
  }
  page_tracker.page_usage_count[(uint64)pa >> 12] = page_tracker.page_usage_count[(uint64)pa >> 12] - 1;
  if (page_tracker.page_usage_count[(uint64)pa >> 12] > 0)
  {
    release(&page_tracker.lock);
    return;
  }
  else
  {
    release(&page_tracker.lock);

    // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);

    r = (struct run *)pa;

    acquire(&kmem.lock);
    r->next = kmem.freelist;
    kmem.freelist = r;
    release(&kmem.lock);
  }
  return;
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if (r)
    kmem.freelist = r->next;
  release(&kmem.lock);

  if (r)
  {
    memset((char *)r, 100, PGSIZE); // fill with junk
    increment_page_usage((void *)r);
  }
  return (void *)r;
}
