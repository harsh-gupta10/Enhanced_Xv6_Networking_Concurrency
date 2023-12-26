
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a8010113          	addi	sp,sp,-1408 # 80008a80 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	ra,8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	95b2                	add	a1,a1,a2
    80000046:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00269713          	slli	a4,a3,0x2
    8000004c:	9736                	add	a4,a4,a3
    8000004e:	00371693          	slli	a3,a4,0x3
    80000052:	00009717          	auipc	a4,0x9
    80000056:	8ee70713          	addi	a4,a4,-1810 # 80008940 <timer_scratch>
    8000005a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005e:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000060:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000064:	00006797          	auipc	a5,0x6
    80000068:	3dc78793          	addi	a5,a5,988 # 80006440 <timervec>
    8000006c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000070:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000074:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000078:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000080:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000084:	30479073          	csrw	mie,a5
}
    80000088:	6422                	ld	s0,8(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdbc037>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	fee78793          	addi	a5,a5,-18 # 8000109c <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d8:	57fd                	li	a5,-1
    800000da:	83a9                	srli	a5,a5,0xa
    800000dc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000e0:	47bd                	li	a5,15
    800000e2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e6:	00000097          	auipc	ra,0x0
    800000ea:	f36080e7          	jalr	-202(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ee:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f2:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f4:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f6:	30200073          	mret
}
    800000fa:	60a2                	ld	ra,8(sp)
    800000fc:	6402                	ld	s0,0(sp)
    800000fe:	0141                	addi	sp,sp,16
    80000100:	8082                	ret

0000000080000102 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000102:	715d                	addi	sp,sp,-80
    80000104:	e486                	sd	ra,72(sp)
    80000106:	e0a2                	sd	s0,64(sp)
    80000108:	fc26                	sd	s1,56(sp)
    8000010a:	f84a                	sd	s2,48(sp)
    8000010c:	f44e                	sd	s3,40(sp)
    8000010e:	f052                	sd	s4,32(sp)
    80000110:	ec56                	sd	s5,24(sp)
    80000112:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000114:	04c05663          	blez	a2,80000160 <consolewrite+0x5e>
    80000118:	8a2a                	mv	s4,a0
    8000011a:	84ae                	mv	s1,a1
    8000011c:	89b2                	mv	s3,a2
    8000011e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000120:	5afd                	li	s5,-1
    80000122:	4685                	li	a3,1
    80000124:	8626                	mv	a2,s1
    80000126:	85d2                	mv	a1,s4
    80000128:	fbf40513          	addi	a0,s0,-65
    8000012c:	00003097          	auipc	ra,0x3
    80000130:	820080e7          	jalr	-2016(ra) # 8000294c <either_copyin>
    80000134:	01550c63          	beq	a0,s5,8000014c <consolewrite+0x4a>
      break;
    uartputc(c);
    80000138:	fbf44503          	lbu	a0,-65(s0)
    8000013c:	00000097          	auipc	ra,0x0
    80000140:	780080e7          	jalr	1920(ra) # 800008bc <uartputc>
  for(i = 0; i < n; i++){
    80000144:	2905                	addiw	s2,s2,1
    80000146:	0485                	addi	s1,s1,1
    80000148:	fd299de3          	bne	s3,s2,80000122 <consolewrite+0x20>
  }

  return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	addi	sp,sp,80
    8000015e:	8082                	ret
  for(i = 0; i < n; i++){
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4a>

0000000080000164 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	7159                	addi	sp,sp,-112
    80000166:	f486                	sd	ra,104(sp)
    80000168:	f0a2                	sd	s0,96(sp)
    8000016a:	eca6                	sd	s1,88(sp)
    8000016c:	e8ca                	sd	s2,80(sp)
    8000016e:	e4ce                	sd	s3,72(sp)
    80000170:	e0d2                	sd	s4,64(sp)
    80000172:	fc56                	sd	s5,56(sp)
    80000174:	f85a                	sd	s6,48(sp)
    80000176:	f45e                	sd	s7,40(sp)
    80000178:	f062                	sd	s8,32(sp)
    8000017a:	ec66                	sd	s9,24(sp)
    8000017c:	e86a                	sd	s10,16(sp)
    8000017e:	1880                	addi	s0,sp,112
    80000180:	8aaa                	mv	s5,a0
    80000182:	8a2e                	mv	s4,a1
    80000184:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000186:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018a:	00011517          	auipc	a0,0x11
    8000018e:	8f650513          	addi	a0,a0,-1802 # 80010a80 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	c68080e7          	jalr	-920(ra) # 80000dfa <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019a:	00011497          	auipc	s1,0x11
    8000019e:	8e648493          	addi	s1,s1,-1818 # 80010a80 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a2:	00011917          	auipc	s2,0x11
    800001a6:	97690913          	addi	s2,s2,-1674 # 80010b18 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800001aa:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ac:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001ae:	4ca9                	li	s9,10
  while(n > 0){
    800001b0:	07305b63          	blez	s3,80000226 <consoleread+0xc2>
    while(cons.r == cons.w){
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	02f71763          	bne	a4,a5,800001ea <consoleread+0x86>
      if(killed(myproc())){
    800001c0:	00002097          	auipc	ra,0x2
    800001c4:	a4e080e7          	jalr	-1458(ra) # 80001c0e <myproc>
    800001c8:	00002097          	auipc	ra,0x2
    800001cc:	5ce080e7          	jalr	1486(ra) # 80002796 <killed>
    800001d0:	e535                	bnez	a0,8000023c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	30c080e7          	jalr	780(ra) # 800024e2 <sleep>
    while(cons.r == cons.w){
    800001de:	0984a783          	lw	a5,152(s1)
    800001e2:	09c4a703          	lw	a4,156(s1)
    800001e6:	fcf70de3          	beq	a4,a5,800001c0 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ea:	0017871b          	addiw	a4,a5,1
    800001ee:	08e4ac23          	sw	a4,152(s1)
    800001f2:	07f7f713          	andi	a4,a5,127
    800001f6:	9726                	add	a4,a4,s1
    800001f8:	01874703          	lbu	a4,24(a4)
    800001fc:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80000200:	077d0563          	beq	s10,s7,8000026a <consoleread+0x106>
    cbuf = c;
    80000204:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000208:	4685                	li	a3,1
    8000020a:	f9f40613          	addi	a2,s0,-97
    8000020e:	85d2                	mv	a1,s4
    80000210:	8556                	mv	a0,s5
    80000212:	00002097          	auipc	ra,0x2
    80000216:	6e4080e7          	jalr	1764(ra) # 800028f6 <either_copyout>
    8000021a:	01850663          	beq	a0,s8,80000226 <consoleread+0xc2>
    dst++;
    8000021e:	0a05                	addi	s4,s4,1
    --n;
    80000220:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80000222:	f99d17e3          	bne	s10,s9,800001b0 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000226:	00011517          	auipc	a0,0x11
    8000022a:	85a50513          	addi	a0,a0,-1958 # 80010a80 <cons>
    8000022e:	00001097          	auipc	ra,0x1
    80000232:	c80080e7          	jalr	-896(ra) # 80000eae <release>

  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	a811                	j	8000024e <consoleread+0xea>
        release(&cons.lock);
    8000023c:	00011517          	auipc	a0,0x11
    80000240:	84450513          	addi	a0,a0,-1980 # 80010a80 <cons>
    80000244:	00001097          	auipc	ra,0x1
    80000248:	c6a080e7          	jalr	-918(ra) # 80000eae <release>
        return -1;
    8000024c:	557d                	li	a0,-1
}
    8000024e:	70a6                	ld	ra,104(sp)
    80000250:	7406                	ld	s0,96(sp)
    80000252:	64e6                	ld	s1,88(sp)
    80000254:	6946                	ld	s2,80(sp)
    80000256:	69a6                	ld	s3,72(sp)
    80000258:	6a06                	ld	s4,64(sp)
    8000025a:	7ae2                	ld	s5,56(sp)
    8000025c:	7b42                	ld	s6,48(sp)
    8000025e:	7ba2                	ld	s7,40(sp)
    80000260:	7c02                	ld	s8,32(sp)
    80000262:	6ce2                	ld	s9,24(sp)
    80000264:	6d42                	ld	s10,16(sp)
    80000266:	6165                	addi	sp,sp,112
    80000268:	8082                	ret
      if(n < target){
    8000026a:	0009871b          	sext.w	a4,s3
    8000026e:	fb677ce3          	bgeu	a4,s6,80000226 <consoleread+0xc2>
        cons.r--;
    80000272:	00011717          	auipc	a4,0x11
    80000276:	8af72323          	sw	a5,-1882(a4) # 80010b18 <cons+0x98>
    8000027a:	b775                	j	80000226 <consoleread+0xc2>

000000008000027c <consputc>:
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000284:	10000793          	li	a5,256
    80000288:	00f50a63          	beq	a0,a5,8000029c <consputc+0x20>
    uartputc_sync(c);
    8000028c:	00000097          	auipc	ra,0x0
    80000290:	55e080e7          	jalr	1374(ra) # 800007ea <uartputc_sync>
}
    80000294:	60a2                	ld	ra,8(sp)
    80000296:	6402                	ld	s0,0(sp)
    80000298:	0141                	addi	sp,sp,16
    8000029a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000029c:	4521                	li	a0,8
    8000029e:	00000097          	auipc	ra,0x0
    800002a2:	54c080e7          	jalr	1356(ra) # 800007ea <uartputc_sync>
    800002a6:	02000513          	li	a0,32
    800002aa:	00000097          	auipc	ra,0x0
    800002ae:	540080e7          	jalr	1344(ra) # 800007ea <uartputc_sync>
    800002b2:	4521                	li	a0,8
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	536080e7          	jalr	1334(ra) # 800007ea <uartputc_sync>
    800002bc:	bfe1                	j	80000294 <consputc+0x18>

00000000800002be <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002be:	1101                	addi	sp,sp,-32
    800002c0:	ec06                	sd	ra,24(sp)
    800002c2:	e822                	sd	s0,16(sp)
    800002c4:	e426                	sd	s1,8(sp)
    800002c6:	e04a                	sd	s2,0(sp)
    800002c8:	1000                	addi	s0,sp,32
    800002ca:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002cc:	00010517          	auipc	a0,0x10
    800002d0:	7b450513          	addi	a0,a0,1972 # 80010a80 <cons>
    800002d4:	00001097          	auipc	ra,0x1
    800002d8:	b26080e7          	jalr	-1242(ra) # 80000dfa <acquire>

  switch(c){
    800002dc:	47d5                	li	a5,21
    800002de:	0af48663          	beq	s1,a5,8000038a <consoleintr+0xcc>
    800002e2:	0297ca63          	blt	a5,s1,80000316 <consoleintr+0x58>
    800002e6:	47a1                	li	a5,8
    800002e8:	0ef48763          	beq	s1,a5,800003d6 <consoleintr+0x118>
    800002ec:	47c1                	li	a5,16
    800002ee:	10f49a63          	bne	s1,a5,80000402 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f2:	00002097          	auipc	ra,0x2
    800002f6:	6b0080e7          	jalr	1712(ra) # 800029a2 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fa:	00010517          	auipc	a0,0x10
    800002fe:	78650513          	addi	a0,a0,1926 # 80010a80 <cons>
    80000302:	00001097          	auipc	ra,0x1
    80000306:	bac080e7          	jalr	-1108(ra) # 80000eae <release>
}
    8000030a:	60e2                	ld	ra,24(sp)
    8000030c:	6442                	ld	s0,16(sp)
    8000030e:	64a2                	ld	s1,8(sp)
    80000310:	6902                	ld	s2,0(sp)
    80000312:	6105                	addi	sp,sp,32
    80000314:	8082                	ret
  switch(c){
    80000316:	07f00793          	li	a5,127
    8000031a:	0af48e63          	beq	s1,a5,800003d6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000031e:	00010717          	auipc	a4,0x10
    80000322:	76270713          	addi	a4,a4,1890 # 80010a80 <cons>
    80000326:	0a072783          	lw	a5,160(a4)
    8000032a:	09872703          	lw	a4,152(a4)
    8000032e:	9f99                	subw	a5,a5,a4
    80000330:	07f00713          	li	a4,127
    80000334:	fcf763e3          	bltu	a4,a5,800002fa <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000338:	47b5                	li	a5,13
    8000033a:	0cf48763          	beq	s1,a5,80000408 <consoleintr+0x14a>
      consputc(c);
    8000033e:	8526                	mv	a0,s1
    80000340:	00000097          	auipc	ra,0x0
    80000344:	f3c080e7          	jalr	-196(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000348:	00010797          	auipc	a5,0x10
    8000034c:	73878793          	addi	a5,a5,1848 # 80010a80 <cons>
    80000350:	0a07a683          	lw	a3,160(a5)
    80000354:	0016871b          	addiw	a4,a3,1
    80000358:	0007061b          	sext.w	a2,a4
    8000035c:	0ae7a023          	sw	a4,160(a5)
    80000360:	07f6f693          	andi	a3,a3,127
    80000364:	97b6                	add	a5,a5,a3
    80000366:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000036a:	47a9                	li	a5,10
    8000036c:	0cf48563          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000370:	4791                	li	a5,4
    80000372:	0cf48263          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000376:	00010797          	auipc	a5,0x10
    8000037a:	7a27a783          	lw	a5,1954(a5) # 80010b18 <cons+0x98>
    8000037e:	9f1d                	subw	a4,a4,a5
    80000380:	08000793          	li	a5,128
    80000384:	f6f71be3          	bne	a4,a5,800002fa <consoleintr+0x3c>
    80000388:	a07d                	j	80000436 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000038a:	00010717          	auipc	a4,0x10
    8000038e:	6f670713          	addi	a4,a4,1782 # 80010a80 <cons>
    80000392:	0a072783          	lw	a5,160(a4)
    80000396:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000039a:	00010497          	auipc	s1,0x10
    8000039e:	6e648493          	addi	s1,s1,1766 # 80010a80 <cons>
    while(cons.e != cons.w &&
    800003a2:	4929                	li	s2,10
    800003a4:	f4f70be3          	beq	a4,a5,800002fa <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003a8:	37fd                	addiw	a5,a5,-1
    800003aa:	07f7f713          	andi	a4,a5,127
    800003ae:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003b0:	01874703          	lbu	a4,24(a4)
    800003b4:	f52703e3          	beq	a4,s2,800002fa <consoleintr+0x3c>
      cons.e--;
    800003b8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003bc:	10000513          	li	a0,256
    800003c0:	00000097          	auipc	ra,0x0
    800003c4:	ebc080e7          	jalr	-324(ra) # 8000027c <consputc>
    while(cons.e != cons.w &&
    800003c8:	0a04a783          	lw	a5,160(s1)
    800003cc:	09c4a703          	lw	a4,156(s1)
    800003d0:	fcf71ce3          	bne	a4,a5,800003a8 <consoleintr+0xea>
    800003d4:	b71d                	j	800002fa <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d6:	00010717          	auipc	a4,0x10
    800003da:	6aa70713          	addi	a4,a4,1706 # 80010a80 <cons>
    800003de:	0a072783          	lw	a5,160(a4)
    800003e2:	09c72703          	lw	a4,156(a4)
    800003e6:	f0f70ae3          	beq	a4,a5,800002fa <consoleintr+0x3c>
      cons.e--;
    800003ea:	37fd                	addiw	a5,a5,-1
    800003ec:	00010717          	auipc	a4,0x10
    800003f0:	72f72a23          	sw	a5,1844(a4) # 80010b20 <cons+0xa0>
      consputc(BACKSPACE);
    800003f4:	10000513          	li	a0,256
    800003f8:	00000097          	auipc	ra,0x0
    800003fc:	e84080e7          	jalr	-380(ra) # 8000027c <consputc>
    80000400:	bded                	j	800002fa <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000402:	ee048ce3          	beqz	s1,800002fa <consoleintr+0x3c>
    80000406:	bf21                	j	8000031e <consoleintr+0x60>
      consputc(c);
    80000408:	4529                	li	a0,10
    8000040a:	00000097          	auipc	ra,0x0
    8000040e:	e72080e7          	jalr	-398(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000412:	00010797          	auipc	a5,0x10
    80000416:	66e78793          	addi	a5,a5,1646 # 80010a80 <cons>
    8000041a:	0a07a703          	lw	a4,160(a5)
    8000041e:	0017069b          	addiw	a3,a4,1
    80000422:	0006861b          	sext.w	a2,a3
    80000426:	0ad7a023          	sw	a3,160(a5)
    8000042a:	07f77713          	andi	a4,a4,127
    8000042e:	97ba                	add	a5,a5,a4
    80000430:	4729                	li	a4,10
    80000432:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000436:	00010797          	auipc	a5,0x10
    8000043a:	6ec7a323          	sw	a2,1766(a5) # 80010b1c <cons+0x9c>
        wakeup(&cons.r);
    8000043e:	00010517          	auipc	a0,0x10
    80000442:	6da50513          	addi	a0,a0,1754 # 80010b18 <cons+0x98>
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	100080e7          	jalr	256(ra) # 80002546 <wakeup>
    8000044e:	b575                	j	800002fa <consoleintr+0x3c>

0000000080000450 <consoleinit>:

void
consoleinit(void)
{
    80000450:	1141                	addi	sp,sp,-16
    80000452:	e406                	sd	ra,8(sp)
    80000454:	e022                	sd	s0,0(sp)
    80000456:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000458:	00008597          	auipc	a1,0x8
    8000045c:	bb858593          	addi	a1,a1,-1096 # 80008010 <etext+0x10>
    80000460:	00010517          	auipc	a0,0x10
    80000464:	62050513          	addi	a0,a0,1568 # 80010a80 <cons>
    80000468:	00001097          	auipc	ra,0x1
    8000046c:	902080e7          	jalr	-1790(ra) # 80000d6a <initlock>

  uartinit();
    80000470:	00000097          	auipc	ra,0x0
    80000474:	32a080e7          	jalr	810(ra) # 8000079a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000478:	00241797          	auipc	a5,0x241
    8000047c:	1b878793          	addi	a5,a5,440 # 80241630 <devsw>
    80000480:	00000717          	auipc	a4,0x0
    80000484:	ce470713          	addi	a4,a4,-796 # 80000164 <consoleread>
    80000488:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000048a:	00000717          	auipc	a4,0x0
    8000048e:	c7870713          	addi	a4,a4,-904 # 80000102 <consolewrite>
    80000492:	ef98                	sd	a4,24(a5)
}
    80000494:	60a2                	ld	ra,8(sp)
    80000496:	6402                	ld	s0,0(sp)
    80000498:	0141                	addi	sp,sp,16
    8000049a:	8082                	ret

000000008000049c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000049c:	7179                	addi	sp,sp,-48
    8000049e:	f406                	sd	ra,40(sp)
    800004a0:	f022                	sd	s0,32(sp)
    800004a2:	ec26                	sd	s1,24(sp)
    800004a4:	e84a                	sd	s2,16(sp)
    800004a6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004a8:	c219                	beqz	a2,800004ae <printint+0x12>
    800004aa:	08054663          	bltz	a0,80000536 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004ae:	2501                	sext.w	a0,a0
    800004b0:	4881                	li	a7,0
    800004b2:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004b6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004b8:	2581                	sext.w	a1,a1
    800004ba:	00008617          	auipc	a2,0x8
    800004be:	b8660613          	addi	a2,a2,-1146 # 80008040 <digits>
    800004c2:	883a                	mv	a6,a4
    800004c4:	2705                	addiw	a4,a4,1
    800004c6:	02b577bb          	remuw	a5,a0,a1
    800004ca:	1782                	slli	a5,a5,0x20
    800004cc:	9381                	srli	a5,a5,0x20
    800004ce:	97b2                	add	a5,a5,a2
    800004d0:	0007c783          	lbu	a5,0(a5)
    800004d4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004d8:	0005079b          	sext.w	a5,a0
    800004dc:	02b5553b          	divuw	a0,a0,a1
    800004e0:	0685                	addi	a3,a3,1
    800004e2:	feb7f0e3          	bgeu	a5,a1,800004c2 <printint+0x26>

  if(sign)
    800004e6:	00088b63          	beqz	a7,800004fc <printint+0x60>
    buf[i++] = '-';
    800004ea:	fe040793          	addi	a5,s0,-32
    800004ee:	973e                	add	a4,a4,a5
    800004f0:	02d00793          	li	a5,45
    800004f4:	fef70823          	sb	a5,-16(a4)
    800004f8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004fc:	02e05763          	blez	a4,8000052a <printint+0x8e>
    80000500:	fd040793          	addi	a5,s0,-48
    80000504:	00e784b3          	add	s1,a5,a4
    80000508:	fff78913          	addi	s2,a5,-1
    8000050c:	993a                	add	s2,s2,a4
    8000050e:	377d                	addiw	a4,a4,-1
    80000510:	1702                	slli	a4,a4,0x20
    80000512:	9301                	srli	a4,a4,0x20
    80000514:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000518:	fff4c503          	lbu	a0,-1(s1)
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	d60080e7          	jalr	-672(ra) # 8000027c <consputc>
  while(--i >= 0)
    80000524:	14fd                	addi	s1,s1,-1
    80000526:	ff2499e3          	bne	s1,s2,80000518 <printint+0x7c>
}
    8000052a:	70a2                	ld	ra,40(sp)
    8000052c:	7402                	ld	s0,32(sp)
    8000052e:	64e2                	ld	s1,24(sp)
    80000530:	6942                	ld	s2,16(sp)
    80000532:	6145                	addi	sp,sp,48
    80000534:	8082                	ret
    x = -xx;
    80000536:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000053a:	4885                	li	a7,1
    x = -xx;
    8000053c:	bf9d                	j	800004b2 <printint+0x16>

000000008000053e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000053e:	1101                	addi	sp,sp,-32
    80000540:	ec06                	sd	ra,24(sp)
    80000542:	e822                	sd	s0,16(sp)
    80000544:	e426                	sd	s1,8(sp)
    80000546:	1000                	addi	s0,sp,32
    80000548:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000054a:	00010797          	auipc	a5,0x10
    8000054e:	5e07ab23          	sw	zero,1526(a5) # 80010b40 <pr+0x18>
  printf("panic: ");
    80000552:	00008517          	auipc	a0,0x8
    80000556:	ac650513          	addi	a0,a0,-1338 # 80008018 <etext+0x18>
    8000055a:	00000097          	auipc	ra,0x0
    8000055e:	02e080e7          	jalr	46(ra) # 80000588 <printf>
  printf(s);
    80000562:	8526                	mv	a0,s1
    80000564:	00000097          	auipc	ra,0x0
    80000568:	024080e7          	jalr	36(ra) # 80000588 <printf>
  printf("\n");
    8000056c:	00008517          	auipc	a0,0x8
    80000570:	bac50513          	addi	a0,a0,-1108 # 80008118 <digits+0xd8>
    80000574:	00000097          	auipc	ra,0x0
    80000578:	014080e7          	jalr	20(ra) # 80000588 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000057c:	4785                	li	a5,1
    8000057e:	00008717          	auipc	a4,0x8
    80000582:	38f72123          	sw	a5,898(a4) # 80008900 <panicked>
  for(;;)
    80000586:	a001                	j	80000586 <panic+0x48>

0000000080000588 <printf>:
{
    80000588:	7131                	addi	sp,sp,-192
    8000058a:	fc86                	sd	ra,120(sp)
    8000058c:	f8a2                	sd	s0,112(sp)
    8000058e:	f4a6                	sd	s1,104(sp)
    80000590:	f0ca                	sd	s2,96(sp)
    80000592:	ecce                	sd	s3,88(sp)
    80000594:	e8d2                	sd	s4,80(sp)
    80000596:	e4d6                	sd	s5,72(sp)
    80000598:	e0da                	sd	s6,64(sp)
    8000059a:	fc5e                	sd	s7,56(sp)
    8000059c:	f862                	sd	s8,48(sp)
    8000059e:	f466                	sd	s9,40(sp)
    800005a0:	f06a                	sd	s10,32(sp)
    800005a2:	ec6e                	sd	s11,24(sp)
    800005a4:	0100                	addi	s0,sp,128
    800005a6:	8a2a                	mv	s4,a0
    800005a8:	e40c                	sd	a1,8(s0)
    800005aa:	e810                	sd	a2,16(s0)
    800005ac:	ec14                	sd	a3,24(s0)
    800005ae:	f018                	sd	a4,32(s0)
    800005b0:	f41c                	sd	a5,40(s0)
    800005b2:	03043823          	sd	a6,48(s0)
    800005b6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ba:	00010d97          	auipc	s11,0x10
    800005be:	586dad83          	lw	s11,1414(s11) # 80010b40 <pr+0x18>
  if(locking)
    800005c2:	020d9b63          	bnez	s11,800005f8 <printf+0x70>
  if (fmt == 0)
    800005c6:	040a0263          	beqz	s4,8000060a <printf+0x82>
  va_start(ap, fmt);
    800005ca:	00840793          	addi	a5,s0,8
    800005ce:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d2:	000a4503          	lbu	a0,0(s4)
    800005d6:	14050f63          	beqz	a0,80000734 <printf+0x1ac>
    800005da:	4981                	li	s3,0
    if(c != '%'){
    800005dc:	02500a93          	li	s5,37
    switch(c){
    800005e0:	07000b93          	li	s7,112
  consputc('x');
    800005e4:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e6:	00008b17          	auipc	s6,0x8
    800005ea:	a5ab0b13          	addi	s6,s6,-1446 # 80008040 <digits>
    switch(c){
    800005ee:	07300c93          	li	s9,115
    800005f2:	06400c13          	li	s8,100
    800005f6:	a82d                	j	80000630 <printf+0xa8>
    acquire(&pr.lock);
    800005f8:	00010517          	auipc	a0,0x10
    800005fc:	53050513          	addi	a0,a0,1328 # 80010b28 <pr>
    80000600:	00000097          	auipc	ra,0x0
    80000604:	7fa080e7          	jalr	2042(ra) # 80000dfa <acquire>
    80000608:	bf7d                	j	800005c6 <printf+0x3e>
    panic("null fmt");
    8000060a:	00008517          	auipc	a0,0x8
    8000060e:	a1e50513          	addi	a0,a0,-1506 # 80008028 <etext+0x28>
    80000612:	00000097          	auipc	ra,0x0
    80000616:	f2c080e7          	jalr	-212(ra) # 8000053e <panic>
      consputc(c);
    8000061a:	00000097          	auipc	ra,0x0
    8000061e:	c62080e7          	jalr	-926(ra) # 8000027c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000622:	2985                	addiw	s3,s3,1
    80000624:	013a07b3          	add	a5,s4,s3
    80000628:	0007c503          	lbu	a0,0(a5)
    8000062c:	10050463          	beqz	a0,80000734 <printf+0x1ac>
    if(c != '%'){
    80000630:	ff5515e3          	bne	a0,s5,8000061a <printf+0x92>
    c = fmt[++i] & 0xff;
    80000634:	2985                	addiw	s3,s3,1
    80000636:	013a07b3          	add	a5,s4,s3
    8000063a:	0007c783          	lbu	a5,0(a5)
    8000063e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000642:	cbed                	beqz	a5,80000734 <printf+0x1ac>
    switch(c){
    80000644:	05778a63          	beq	a5,s7,80000698 <printf+0x110>
    80000648:	02fbf663          	bgeu	s7,a5,80000674 <printf+0xec>
    8000064c:	09978863          	beq	a5,s9,800006dc <printf+0x154>
    80000650:	07800713          	li	a4,120
    80000654:	0ce79563          	bne	a5,a4,8000071e <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000658:	f8843783          	ld	a5,-120(s0)
    8000065c:	00878713          	addi	a4,a5,8
    80000660:	f8e43423          	sd	a4,-120(s0)
    80000664:	4605                	li	a2,1
    80000666:	85ea                	mv	a1,s10
    80000668:	4388                	lw	a0,0(a5)
    8000066a:	00000097          	auipc	ra,0x0
    8000066e:	e32080e7          	jalr	-462(ra) # 8000049c <printint>
      break;
    80000672:	bf45                	j	80000622 <printf+0x9a>
    switch(c){
    80000674:	09578f63          	beq	a5,s5,80000712 <printf+0x18a>
    80000678:	0b879363          	bne	a5,s8,8000071e <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000067c:	f8843783          	ld	a5,-120(s0)
    80000680:	00878713          	addi	a4,a5,8
    80000684:	f8e43423          	sd	a4,-120(s0)
    80000688:	4605                	li	a2,1
    8000068a:	45a9                	li	a1,10
    8000068c:	4388                	lw	a0,0(a5)
    8000068e:	00000097          	auipc	ra,0x0
    80000692:	e0e080e7          	jalr	-498(ra) # 8000049c <printint>
      break;
    80000696:	b771                	j	80000622 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000698:	f8843783          	ld	a5,-120(s0)
    8000069c:	00878713          	addi	a4,a5,8
    800006a0:	f8e43423          	sd	a4,-120(s0)
    800006a4:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006a8:	03000513          	li	a0,48
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	bd0080e7          	jalr	-1072(ra) # 8000027c <consputc>
  consputc('x');
    800006b4:	07800513          	li	a0,120
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	bc4080e7          	jalr	-1084(ra) # 8000027c <consputc>
    800006c0:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c2:	03c95793          	srli	a5,s2,0x3c
    800006c6:	97da                	add	a5,a5,s6
    800006c8:	0007c503          	lbu	a0,0(a5)
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	bb0080e7          	jalr	-1104(ra) # 8000027c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d4:	0912                	slli	s2,s2,0x4
    800006d6:	34fd                	addiw	s1,s1,-1
    800006d8:	f4ed                	bnez	s1,800006c2 <printf+0x13a>
    800006da:	b7a1                	j	80000622 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006dc:	f8843783          	ld	a5,-120(s0)
    800006e0:	00878713          	addi	a4,a5,8
    800006e4:	f8e43423          	sd	a4,-120(s0)
    800006e8:	6384                	ld	s1,0(a5)
    800006ea:	cc89                	beqz	s1,80000704 <printf+0x17c>
      for(; *s; s++)
    800006ec:	0004c503          	lbu	a0,0(s1)
    800006f0:	d90d                	beqz	a0,80000622 <printf+0x9a>
        consputc(*s);
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	b8a080e7          	jalr	-1142(ra) # 8000027c <consputc>
      for(; *s; s++)
    800006fa:	0485                	addi	s1,s1,1
    800006fc:	0004c503          	lbu	a0,0(s1)
    80000700:	f96d                	bnez	a0,800006f2 <printf+0x16a>
    80000702:	b705                	j	80000622 <printf+0x9a>
        s = "(null)";
    80000704:	00008497          	auipc	s1,0x8
    80000708:	91c48493          	addi	s1,s1,-1764 # 80008020 <etext+0x20>
      for(; *s; s++)
    8000070c:	02800513          	li	a0,40
    80000710:	b7cd                	j	800006f2 <printf+0x16a>
      consputc('%');
    80000712:	8556                	mv	a0,s5
    80000714:	00000097          	auipc	ra,0x0
    80000718:	b68080e7          	jalr	-1176(ra) # 8000027c <consputc>
      break;
    8000071c:	b719                	j	80000622 <printf+0x9a>
      consputc('%');
    8000071e:	8556                	mv	a0,s5
    80000720:	00000097          	auipc	ra,0x0
    80000724:	b5c080e7          	jalr	-1188(ra) # 8000027c <consputc>
      consputc(c);
    80000728:	8526                	mv	a0,s1
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	b52080e7          	jalr	-1198(ra) # 8000027c <consputc>
      break;
    80000732:	bdc5                	j	80000622 <printf+0x9a>
  if(locking)
    80000734:	020d9163          	bnez	s11,80000756 <printf+0x1ce>
}
    80000738:	70e6                	ld	ra,120(sp)
    8000073a:	7446                	ld	s0,112(sp)
    8000073c:	74a6                	ld	s1,104(sp)
    8000073e:	7906                	ld	s2,96(sp)
    80000740:	69e6                	ld	s3,88(sp)
    80000742:	6a46                	ld	s4,80(sp)
    80000744:	6aa6                	ld	s5,72(sp)
    80000746:	6b06                	ld	s6,64(sp)
    80000748:	7be2                	ld	s7,56(sp)
    8000074a:	7c42                	ld	s8,48(sp)
    8000074c:	7ca2                	ld	s9,40(sp)
    8000074e:	7d02                	ld	s10,32(sp)
    80000750:	6de2                	ld	s11,24(sp)
    80000752:	6129                	addi	sp,sp,192
    80000754:	8082                	ret
    release(&pr.lock);
    80000756:	00010517          	auipc	a0,0x10
    8000075a:	3d250513          	addi	a0,a0,978 # 80010b28 <pr>
    8000075e:	00000097          	auipc	ra,0x0
    80000762:	750080e7          	jalr	1872(ra) # 80000eae <release>
}
    80000766:	bfc9                	j	80000738 <printf+0x1b0>

0000000080000768 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000768:	1101                	addi	sp,sp,-32
    8000076a:	ec06                	sd	ra,24(sp)
    8000076c:	e822                	sd	s0,16(sp)
    8000076e:	e426                	sd	s1,8(sp)
    80000770:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000772:	00010497          	auipc	s1,0x10
    80000776:	3b648493          	addi	s1,s1,950 # 80010b28 <pr>
    8000077a:	00008597          	auipc	a1,0x8
    8000077e:	8be58593          	addi	a1,a1,-1858 # 80008038 <etext+0x38>
    80000782:	8526                	mv	a0,s1
    80000784:	00000097          	auipc	ra,0x0
    80000788:	5e6080e7          	jalr	1510(ra) # 80000d6a <initlock>
  pr.locking = 1;
    8000078c:	4785                	li	a5,1
    8000078e:	cc9c                	sw	a5,24(s1)
}
    80000790:	60e2                	ld	ra,24(sp)
    80000792:	6442                	ld	s0,16(sp)
    80000794:	64a2                	ld	s1,8(sp)
    80000796:	6105                	addi	sp,sp,32
    80000798:	8082                	ret

000000008000079a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000079a:	1141                	addi	sp,sp,-16
    8000079c:	e406                	sd	ra,8(sp)
    8000079e:	e022                	sd	s0,0(sp)
    800007a0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a2:	100007b7          	lui	a5,0x10000
    800007a6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007aa:	f8000713          	li	a4,-128
    800007ae:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b2:	470d                	li	a4,3
    800007b4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007b8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007bc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007c0:	469d                	li	a3,7
    800007c2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007ca:	00008597          	auipc	a1,0x8
    800007ce:	88e58593          	addi	a1,a1,-1906 # 80008058 <digits+0x18>
    800007d2:	00010517          	auipc	a0,0x10
    800007d6:	37650513          	addi	a0,a0,886 # 80010b48 <uart_tx_lock>
    800007da:	00000097          	auipc	ra,0x0
    800007de:	590080e7          	jalr	1424(ra) # 80000d6a <initlock>
}
    800007e2:	60a2                	ld	ra,8(sp)
    800007e4:	6402                	ld	s0,0(sp)
    800007e6:	0141                	addi	sp,sp,16
    800007e8:	8082                	ret

00000000800007ea <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007ea:	1101                	addi	sp,sp,-32
    800007ec:	ec06                	sd	ra,24(sp)
    800007ee:	e822                	sd	s0,16(sp)
    800007f0:	e426                	sd	s1,8(sp)
    800007f2:	1000                	addi	s0,sp,32
    800007f4:	84aa                	mv	s1,a0
  push_off();
    800007f6:	00000097          	auipc	ra,0x0
    800007fa:	5b8080e7          	jalr	1464(ra) # 80000dae <push_off>

  if(panicked){
    800007fe:	00008797          	auipc	a5,0x8
    80000802:	1027a783          	lw	a5,258(a5) # 80008900 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000806:	10000737          	lui	a4,0x10000
  if(panicked){
    8000080a:	c391                	beqz	a5,8000080e <uartputc_sync+0x24>
    for(;;)
    8000080c:	a001                	j	8000080c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000080e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000812:	0207f793          	andi	a5,a5,32
    80000816:	dfe5                	beqz	a5,8000080e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000818:	0ff4f513          	andi	a0,s1,255
    8000081c:	100007b7          	lui	a5,0x10000
    80000820:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000824:	00000097          	auipc	ra,0x0
    80000828:	62a080e7          	jalr	1578(ra) # 80000e4e <pop_off>
}
    8000082c:	60e2                	ld	ra,24(sp)
    8000082e:	6442                	ld	s0,16(sp)
    80000830:	64a2                	ld	s1,8(sp)
    80000832:	6105                	addi	sp,sp,32
    80000834:	8082                	ret

0000000080000836 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000836:	00008797          	auipc	a5,0x8
    8000083a:	0d27b783          	ld	a5,210(a5) # 80008908 <uart_tx_r>
    8000083e:	00008717          	auipc	a4,0x8
    80000842:	0d273703          	ld	a4,210(a4) # 80008910 <uart_tx_w>
    80000846:	06f70a63          	beq	a4,a5,800008ba <uartstart+0x84>
{
    8000084a:	7139                	addi	sp,sp,-64
    8000084c:	fc06                	sd	ra,56(sp)
    8000084e:	f822                	sd	s0,48(sp)
    80000850:	f426                	sd	s1,40(sp)
    80000852:	f04a                	sd	s2,32(sp)
    80000854:	ec4e                	sd	s3,24(sp)
    80000856:	e852                	sd	s4,16(sp)
    80000858:	e456                	sd	s5,8(sp)
    8000085a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000085c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000860:	00010a17          	auipc	s4,0x10
    80000864:	2e8a0a13          	addi	s4,s4,744 # 80010b48 <uart_tx_lock>
    uart_tx_r += 1;
    80000868:	00008497          	auipc	s1,0x8
    8000086c:	0a048493          	addi	s1,s1,160 # 80008908 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000870:	00008997          	auipc	s3,0x8
    80000874:	0a098993          	addi	s3,s3,160 # 80008910 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000878:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000087c:	02077713          	andi	a4,a4,32
    80000880:	c705                	beqz	a4,800008a8 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000882:	01f7f713          	andi	a4,a5,31
    80000886:	9752                	add	a4,a4,s4
    80000888:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000088c:	0785                	addi	a5,a5,1
    8000088e:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000890:	8526                	mv	a0,s1
    80000892:	00002097          	auipc	ra,0x2
    80000896:	cb4080e7          	jalr	-844(ra) # 80002546 <wakeup>
    
    WriteReg(THR, c);
    8000089a:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000089e:	609c                	ld	a5,0(s1)
    800008a0:	0009b703          	ld	a4,0(s3)
    800008a4:	fcf71ae3          	bne	a4,a5,80000878 <uartstart+0x42>
  }
}
    800008a8:	70e2                	ld	ra,56(sp)
    800008aa:	7442                	ld	s0,48(sp)
    800008ac:	74a2                	ld	s1,40(sp)
    800008ae:	7902                	ld	s2,32(sp)
    800008b0:	69e2                	ld	s3,24(sp)
    800008b2:	6a42                	ld	s4,16(sp)
    800008b4:	6aa2                	ld	s5,8(sp)
    800008b6:	6121                	addi	sp,sp,64
    800008b8:	8082                	ret
    800008ba:	8082                	ret

00000000800008bc <uartputc>:
{
    800008bc:	7179                	addi	sp,sp,-48
    800008be:	f406                	sd	ra,40(sp)
    800008c0:	f022                	sd	s0,32(sp)
    800008c2:	ec26                	sd	s1,24(sp)
    800008c4:	e84a                	sd	s2,16(sp)
    800008c6:	e44e                	sd	s3,8(sp)
    800008c8:	e052                	sd	s4,0(sp)
    800008ca:	1800                	addi	s0,sp,48
    800008cc:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008ce:	00010517          	auipc	a0,0x10
    800008d2:	27a50513          	addi	a0,a0,634 # 80010b48 <uart_tx_lock>
    800008d6:	00000097          	auipc	ra,0x0
    800008da:	524080e7          	jalr	1316(ra) # 80000dfa <acquire>
  if(panicked){
    800008de:	00008797          	auipc	a5,0x8
    800008e2:	0227a783          	lw	a5,34(a5) # 80008900 <panicked>
    800008e6:	e7c9                	bnez	a5,80000970 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008e8:	00008717          	auipc	a4,0x8
    800008ec:	02873703          	ld	a4,40(a4) # 80008910 <uart_tx_w>
    800008f0:	00008797          	auipc	a5,0x8
    800008f4:	0187b783          	ld	a5,24(a5) # 80008908 <uart_tx_r>
    800008f8:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fc:	00010997          	auipc	s3,0x10
    80000900:	24c98993          	addi	s3,s3,588 # 80010b48 <uart_tx_lock>
    80000904:	00008497          	auipc	s1,0x8
    80000908:	00448493          	addi	s1,s1,4 # 80008908 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090c:	00008917          	auipc	s2,0x8
    80000910:	00490913          	addi	s2,s2,4 # 80008910 <uart_tx_w>
    80000914:	00e79f63          	bne	a5,a4,80000932 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000918:	85ce                	mv	a1,s3
    8000091a:	8526                	mv	a0,s1
    8000091c:	00002097          	auipc	ra,0x2
    80000920:	bc6080e7          	jalr	-1082(ra) # 800024e2 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000924:	00093703          	ld	a4,0(s2)
    80000928:	609c                	ld	a5,0(s1)
    8000092a:	02078793          	addi	a5,a5,32
    8000092e:	fee785e3          	beq	a5,a4,80000918 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000932:	00010497          	auipc	s1,0x10
    80000936:	21648493          	addi	s1,s1,534 # 80010b48 <uart_tx_lock>
    8000093a:	01f77793          	andi	a5,a4,31
    8000093e:	97a6                	add	a5,a5,s1
    80000940:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000944:	0705                	addi	a4,a4,1
    80000946:	00008797          	auipc	a5,0x8
    8000094a:	fce7b523          	sd	a4,-54(a5) # 80008910 <uart_tx_w>
  uartstart();
    8000094e:	00000097          	auipc	ra,0x0
    80000952:	ee8080e7          	jalr	-280(ra) # 80000836 <uartstart>
  release(&uart_tx_lock);
    80000956:	8526                	mv	a0,s1
    80000958:	00000097          	auipc	ra,0x0
    8000095c:	556080e7          	jalr	1366(ra) # 80000eae <release>
}
    80000960:	70a2                	ld	ra,40(sp)
    80000962:	7402                	ld	s0,32(sp)
    80000964:	64e2                	ld	s1,24(sp)
    80000966:	6942                	ld	s2,16(sp)
    80000968:	69a2                	ld	s3,8(sp)
    8000096a:	6a02                	ld	s4,0(sp)
    8000096c:	6145                	addi	sp,sp,48
    8000096e:	8082                	ret
    for(;;)
    80000970:	a001                	j	80000970 <uartputc+0xb4>

0000000080000972 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000972:	1141                	addi	sp,sp,-16
    80000974:	e422                	sd	s0,8(sp)
    80000976:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000978:	100007b7          	lui	a5,0x10000
    8000097c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000980:	8b85                	andi	a5,a5,1
    80000982:	cb91                	beqz	a5,80000996 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000984:	100007b7          	lui	a5,0x10000
    80000988:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000098c:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80000990:	6422                	ld	s0,8(sp)
    80000992:	0141                	addi	sp,sp,16
    80000994:	8082                	ret
    return -1;
    80000996:	557d                	li	a0,-1
    80000998:	bfe5                	j	80000990 <uartgetc+0x1e>

000000008000099a <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000099a:	1101                	addi	sp,sp,-32
    8000099c:	ec06                	sd	ra,24(sp)
    8000099e:	e822                	sd	s0,16(sp)
    800009a0:	e426                	sd	s1,8(sp)
    800009a2:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009a4:	54fd                	li	s1,-1
    800009a6:	a029                	j	800009b0 <uartintr+0x16>
      break;
    consoleintr(c);
    800009a8:	00000097          	auipc	ra,0x0
    800009ac:	916080e7          	jalr	-1770(ra) # 800002be <consoleintr>
    int c = uartgetc();
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	fc2080e7          	jalr	-62(ra) # 80000972 <uartgetc>
    if(c == -1)
    800009b8:	fe9518e3          	bne	a0,s1,800009a8 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009bc:	00010497          	auipc	s1,0x10
    800009c0:	18c48493          	addi	s1,s1,396 # 80010b48 <uart_tx_lock>
    800009c4:	8526                	mv	a0,s1
    800009c6:	00000097          	auipc	ra,0x0
    800009ca:	434080e7          	jalr	1076(ra) # 80000dfa <acquire>
  uartstart();
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	e68080e7          	jalr	-408(ra) # 80000836 <uartstart>
  release(&uart_tx_lock);
    800009d6:	8526                	mv	a0,s1
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	4d6080e7          	jalr	1238(ra) # 80000eae <release>
}
    800009e0:	60e2                	ld	ra,24(sp)
    800009e2:	6442                	ld	s0,16(sp)
    800009e4:	64a2                	ld	s1,8(sp)
    800009e6:	6105                	addi	sp,sp,32
    800009e8:	8082                	ret

00000000800009ea <init_page_tracker>:
  int page_usage_count[PGROUNDUP(PHYSTOP) >> 12];
} page_tracker;

// void initialize_page()
void init_page_tracker()
{
    800009ea:	1141                	addi	sp,sp,-16
    800009ec:	e406                	sd	ra,8(sp)
    800009ee:	e022                	sd	s0,0(sp)
    800009f0:	0800                	addi	s0,sp,16
  int i;
  initlock(&page_tracker.lock, "page_tracker");
    800009f2:	00007597          	auipc	a1,0x7
    800009f6:	66e58593          	addi	a1,a1,1646 # 80008060 <digits+0x20>
    800009fa:	00010517          	auipc	a0,0x10
    800009fe:	1a650513          	addi	a0,a0,422 # 80010ba0 <page_tracker>
    80000a02:	00000097          	auipc	ra,0x0
    80000a06:	368080e7          	jalr	872(ra) # 80000d6a <initlock>
  acquire(&page_tracker.lock);
    80000a0a:	00010517          	auipc	a0,0x10
    80000a0e:	19650513          	addi	a0,a0,406 # 80010ba0 <page_tracker>
    80000a12:	00000097          	auipc	ra,0x0
    80000a16:	3e8080e7          	jalr	1000(ra) # 80000dfa <acquire>
  for (i = 0; i < PGROUNDUP(PHYSTOP) >> 12; i++)
    80000a1a:	00010797          	auipc	a5,0x10
    80000a1e:	19e78793          	addi	a5,a5,414 # 80010bb8 <page_tracker+0x18>
    80000a22:	00230717          	auipc	a4,0x230
    80000a26:	19670713          	addi	a4,a4,406 # 80230bb8 <pid_lock>
  {
    page_tracker.page_usage_count[i] = 0;
    80000a2a:	0007a023          	sw	zero,0(a5)
  for (i = 0; i < PGROUNDUP(PHYSTOP) >> 12; i++)
    80000a2e:	0791                	addi	a5,a5,4
    80000a30:	fee79de3          	bne	a5,a4,80000a2a <init_page_tracker+0x40>
  }
  release(&page_tracker.lock);
    80000a34:	00010517          	auipc	a0,0x10
    80000a38:	16c50513          	addi	a0,a0,364 # 80010ba0 <page_tracker>
    80000a3c:	00000097          	auipc	ra,0x0
    80000a40:	472080e7          	jalr	1138(ra) # 80000eae <release>
}
    80000a44:	60a2                	ld	ra,8(sp)
    80000a46:	6402                	ld	s0,0(sp)
    80000a48:	0141                	addi	sp,sp,16
    80000a4a:	8082                	ret

0000000080000a4c <get_page_usage>:

// int extract_page(void *pa)
int get_page_usage(void *pa)
{
    80000a4c:	1101                	addi	sp,sp,-32
    80000a4e:	ec06                	sd	ra,24(sp)
    80000a50:	e822                	sd	s0,16(sp)
    80000a52:	e426                	sd	s1,8(sp)
    80000a54:	1000                	addi	s0,sp,32
    80000a56:	84aa                	mv	s1,a0
  acquire(&page_tracker.lock);
    80000a58:	00010517          	auipc	a0,0x10
    80000a5c:	14850513          	addi	a0,a0,328 # 80010ba0 <page_tracker>
    80000a60:	00000097          	auipc	ra,0x0
    80000a64:	39a080e7          	jalr	922(ra) # 80000dfa <acquire>
  int res = page_tracker.page_usage_count[(uint64)pa >> 12];
    80000a68:	00010517          	auipc	a0,0x10
    80000a6c:	13850513          	addi	a0,a0,312 # 80010ba0 <page_tracker>
    80000a70:	80b1                	srli	s1,s1,0xc
    80000a72:	0491                	addi	s1,s1,4
    80000a74:	048a                	slli	s1,s1,0x2
    80000a76:	94aa                	add	s1,s1,a0
    80000a78:	4484                	lw	s1,8(s1)
  release(&page_tracker.lock);
    80000a7a:	00000097          	auipc	ra,0x0
    80000a7e:	434080e7          	jalr	1076(ra) # 80000eae <release>
  if (res >= 0)
    80000a82:	0004c863          	bltz	s1,80000a92 <get_page_usage+0x46>
  {
    return res;
  }
  panic("get_page_usage");
  return -1;
}
    80000a86:	8526                	mv	a0,s1
    80000a88:	60e2                	ld	ra,24(sp)
    80000a8a:	6442                	ld	s0,16(sp)
    80000a8c:	64a2                	ld	s1,8(sp)
    80000a8e:	6105                	addi	sp,sp,32
    80000a90:	8082                	ret
  panic("get_page_usage");
    80000a92:	00007517          	auipc	a0,0x7
    80000a96:	5de50513          	addi	a0,a0,1502 # 80008070 <digits+0x30>
    80000a9a:	00000097          	auipc	ra,0x0
    80000a9e:	aa4080e7          	jalr	-1372(ra) # 8000053e <panic>

0000000080000aa2 <increment_page_usage>:

// void increment_page(void *pa)
void increment_page_usage(void *pa)
{
    80000aa2:	1101                	addi	sp,sp,-32
    80000aa4:	ec06                	sd	ra,24(sp)
    80000aa6:	e822                	sd	s0,16(sp)
    80000aa8:	e426                	sd	s1,8(sp)
    80000aaa:	1000                	addi	s0,sp,32
    80000aac:	84aa                	mv	s1,a0
  acquire(&page_tracker.lock);
    80000aae:	00010517          	auipc	a0,0x10
    80000ab2:	0f250513          	addi	a0,a0,242 # 80010ba0 <page_tracker>
    80000ab6:	00000097          	auipc	ra,0x0
    80000aba:	344080e7          	jalr	836(ra) # 80000dfa <acquire>
  if (page_tracker.page_usage_count[(uint64)pa >> 12] >= 0)
    80000abe:	00c4d793          	srli	a5,s1,0xc
    80000ac2:	00478713          	addi	a4,a5,4
    80000ac6:	00271693          	slli	a3,a4,0x2
    80000aca:	00010717          	auipc	a4,0x10
    80000ace:	0d670713          	addi	a4,a4,214 # 80010ba0 <page_tracker>
    80000ad2:	9736                	add	a4,a4,a3
    80000ad4:	4718                	lw	a4,8(a4)
    80000ad6:	02074363          	bltz	a4,80000afc <increment_page_usage+0x5a>
  {
    page_tracker.page_usage_count[(uint64)pa >> 12] += 1;
    80000ada:	00010517          	auipc	a0,0x10
    80000ade:	0c650513          	addi	a0,a0,198 # 80010ba0 <page_tracker>
    80000ae2:	00d507b3          	add	a5,a0,a3
    80000ae6:	2705                	addiw	a4,a4,1
    80000ae8:	c798                	sw	a4,8(a5)
  else
  {
    panic("increment_page_usage");
    return;
  }
  release(&page_tracker.lock);
    80000aea:	00000097          	auipc	ra,0x0
    80000aee:	3c4080e7          	jalr	964(ra) # 80000eae <release>
  return;
}
    80000af2:	60e2                	ld	ra,24(sp)
    80000af4:	6442                	ld	s0,16(sp)
    80000af6:	64a2                	ld	s1,8(sp)
    80000af8:	6105                	addi	sp,sp,32
    80000afa:	8082                	ret
    panic("increment_page_usage");
    80000afc:	00007517          	auipc	a0,0x7
    80000b00:	58450513          	addi	a0,a0,1412 # 80008080 <digits+0x40>
    80000b04:	00000097          	auipc	ra,0x0
    80000b08:	a3a080e7          	jalr	-1478(ra) # 8000053e <panic>

0000000080000b0c <decrement_page_usage>:

void decrement_page_usage(void *pa)
{
    80000b0c:	1101                	addi	sp,sp,-32
    80000b0e:	ec06                	sd	ra,24(sp)
    80000b10:	e822                	sd	s0,16(sp)
    80000b12:	e426                	sd	s1,8(sp)
    80000b14:	1000                	addi	s0,sp,32
    80000b16:	84aa                	mv	s1,a0
  acquire(&page_tracker.lock);
    80000b18:	00010517          	auipc	a0,0x10
    80000b1c:	08850513          	addi	a0,a0,136 # 80010ba0 <page_tracker>
    80000b20:	00000097          	auipc	ra,0x0
    80000b24:	2da080e7          	jalr	730(ra) # 80000dfa <acquire>
  if (page_tracker.page_usage_count[(uint64)pa >> 12] > 0)
    80000b28:	00c4d793          	srli	a5,s1,0xc
    80000b2c:	00478713          	addi	a4,a5,4
    80000b30:	00271693          	slli	a3,a4,0x2
    80000b34:	00010717          	auipc	a4,0x10
    80000b38:	06c70713          	addi	a4,a4,108 # 80010ba0 <page_tracker>
    80000b3c:	9736                	add	a4,a4,a3
    80000b3e:	4718                	lw	a4,8(a4)
    80000b40:	02e05363          	blez	a4,80000b66 <decrement_page_usage+0x5a>
  {
    page_tracker.page_usage_count[(uint64)pa >> 12] -= 1;
    80000b44:	00010517          	auipc	a0,0x10
    80000b48:	05c50513          	addi	a0,a0,92 # 80010ba0 <page_tracker>
    80000b4c:	00d507b3          	add	a5,a0,a3
    80000b50:	377d                	addiw	a4,a4,-1
    80000b52:	c798                	sw	a4,8(a5)
  else
  {
    panic("decrement_page_usage");
    return;
  }
  release(&page_tracker.lock);
    80000b54:	00000097          	auipc	ra,0x0
    80000b58:	35a080e7          	jalr	858(ra) # 80000eae <release>
  return;
}
    80000b5c:	60e2                	ld	ra,24(sp)
    80000b5e:	6442                	ld	s0,16(sp)
    80000b60:	64a2                	ld	s1,8(sp)
    80000b62:	6105                	addi	sp,sp,32
    80000b64:	8082                	ret
    panic("decrement_page_usage");
    80000b66:	00007517          	auipc	a0,0x7
    80000b6a:	53250513          	addi	a0,a0,1330 # 80008098 <digits+0x58>
    80000b6e:	00000097          	auipc	ra,0x0
    80000b72:	9d0080e7          	jalr	-1584(ra) # 8000053e <panic>

0000000080000b76 <kfree>:
// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    80000b76:	1101                	addi	sp,sp,-32
    80000b78:	ec06                	sd	ra,24(sp)
    80000b7a:	e822                	sd	s0,16(sp)
    80000b7c:	e426                	sd	s1,8(sp)
    80000b7e:	e04a                	sd	s2,0(sp)
    80000b80:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000b82:	03451793          	slli	a5,a0,0x34
    80000b86:	e7dd                	bnez	a5,80000c34 <kfree+0xbe>
    80000b88:	84aa                	mv	s1,a0
    80000b8a:	00242797          	auipc	a5,0x242
    80000b8e:	c3e78793          	addi	a5,a5,-962 # 802427c8 <end>
    80000b92:	0af56163          	bltu	a0,a5,80000c34 <kfree+0xbe>
    80000b96:	47c5                	li	a5,17
    80000b98:	07ee                	slli	a5,a5,0x1b
    80000b9a:	08f57d63          	bgeu	a0,a5,80000c34 <kfree+0xbe>
    panic("kfree");
  acquire(&page_tracker.lock);
    80000b9e:	00010517          	auipc	a0,0x10
    80000ba2:	00250513          	addi	a0,a0,2 # 80010ba0 <page_tracker>
    80000ba6:	00000097          	auipc	ra,0x0
    80000baa:	254080e7          	jalr	596(ra) # 80000dfa <acquire>
  if (page_tracker.page_usage_count[(uint64)pa >> 12] <= 0)
    80000bae:	00c4d793          	srli	a5,s1,0xc
    80000bb2:	00478713          	addi	a4,a5,4
    80000bb6:	00271693          	slli	a3,a4,0x2
    80000bba:	00010717          	auipc	a4,0x10
    80000bbe:	fe670713          	addi	a4,a4,-26 # 80010ba0 <page_tracker>
    80000bc2:	9736                	add	a4,a4,a3
    80000bc4:	4718                	lw	a4,8(a4)
    80000bc6:	06e05f63          	blez	a4,80000c44 <kfree+0xce>
  {
    panic("decrement_page_usage");
  }
  page_tracker.page_usage_count[(uint64)pa >> 12] = page_tracker.page_usage_count[(uint64)pa >> 12] - 1;
    80000bca:	377d                	addiw	a4,a4,-1
    80000bcc:	0007061b          	sext.w	a2,a4
    80000bd0:	0791                	addi	a5,a5,4
    80000bd2:	078a                	slli	a5,a5,0x2
    80000bd4:	00010697          	auipc	a3,0x10
    80000bd8:	fcc68693          	addi	a3,a3,-52 # 80010ba0 <page_tracker>
    80000bdc:	97b6                	add	a5,a5,a3
    80000bde:	c798                	sw	a4,8(a5)
  if (page_tracker.page_usage_count[(uint64)pa >> 12] > 0)
    80000be0:	06c04a63          	bgtz	a2,80000c54 <kfree+0xde>
    release(&page_tracker.lock);
    return;
  }
  else
  {
    release(&page_tracker.lock);
    80000be4:	00010517          	auipc	a0,0x10
    80000be8:	fbc50513          	addi	a0,a0,-68 # 80010ba0 <page_tracker>
    80000bec:	00000097          	auipc	ra,0x0
    80000bf0:	2c2080e7          	jalr	706(ra) # 80000eae <release>

    // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);
    80000bf4:	6605                	lui	a2,0x1
    80000bf6:	4585                	li	a1,1
    80000bf8:	8526                	mv	a0,s1
    80000bfa:	00000097          	auipc	ra,0x0
    80000bfe:	2fc080e7          	jalr	764(ra) # 80000ef6 <memset>

    r = (struct run *)pa;

    acquire(&kmem.lock);
    80000c02:	00010917          	auipc	s2,0x10
    80000c06:	f7e90913          	addi	s2,s2,-130 # 80010b80 <kmem>
    80000c0a:	854a                	mv	a0,s2
    80000c0c:	00000097          	auipc	ra,0x0
    80000c10:	1ee080e7          	jalr	494(ra) # 80000dfa <acquire>
    r->next = kmem.freelist;
    80000c14:	01893783          	ld	a5,24(s2)
    80000c18:	e09c                	sd	a5,0(s1)
    kmem.freelist = r;
    80000c1a:	00993c23          	sd	s1,24(s2)
    release(&kmem.lock);
    80000c1e:	854a                	mv	a0,s2
    80000c20:	00000097          	auipc	ra,0x0
    80000c24:	28e080e7          	jalr	654(ra) # 80000eae <release>
  }
  return;
}
    80000c28:	60e2                	ld	ra,24(sp)
    80000c2a:	6442                	ld	s0,16(sp)
    80000c2c:	64a2                	ld	s1,8(sp)
    80000c2e:	6902                	ld	s2,0(sp)
    80000c30:	6105                	addi	sp,sp,32
    80000c32:	8082                	ret
    panic("kfree");
    80000c34:	00007517          	auipc	a0,0x7
    80000c38:	47c50513          	addi	a0,a0,1148 # 800080b0 <digits+0x70>
    80000c3c:	00000097          	auipc	ra,0x0
    80000c40:	902080e7          	jalr	-1790(ra) # 8000053e <panic>
    panic("decrement_page_usage");
    80000c44:	00007517          	auipc	a0,0x7
    80000c48:	45450513          	addi	a0,a0,1108 # 80008098 <digits+0x58>
    80000c4c:	00000097          	auipc	ra,0x0
    80000c50:	8f2080e7          	jalr	-1806(ra) # 8000053e <panic>
    release(&page_tracker.lock);
    80000c54:	8536                	mv	a0,a3
    80000c56:	00000097          	auipc	ra,0x0
    80000c5a:	258080e7          	jalr	600(ra) # 80000eae <release>
    return;
    80000c5e:	b7e9                	j	80000c28 <kfree+0xb2>

0000000080000c60 <freerange>:
{
    80000c60:	7139                	addi	sp,sp,-64
    80000c62:	fc06                	sd	ra,56(sp)
    80000c64:	f822                	sd	s0,48(sp)
    80000c66:	f426                	sd	s1,40(sp)
    80000c68:	f04a                	sd	s2,32(sp)
    80000c6a:	ec4e                	sd	s3,24(sp)
    80000c6c:	e852                	sd	s4,16(sp)
    80000c6e:	e456                	sd	s5,8(sp)
    80000c70:	0080                	addi	s0,sp,64
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000c72:	6785                	lui	a5,0x1
    80000c74:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000c78:	94aa                	add	s1,s1,a0
    80000c7a:	757d                	lui	a0,0xfffff
    80000c7c:	8ce9                	and	s1,s1,a0
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000c7e:	94be                	add	s1,s1,a5
    80000c80:	0295e463          	bltu	a1,s1,80000ca8 <freerange+0x48>
    80000c84:	89ae                	mv	s3,a1
    80000c86:	7afd                	lui	s5,0xfffff
    80000c88:	6a05                	lui	s4,0x1
    80000c8a:	01548933          	add	s2,s1,s5
    increment_page_usage(p);
    80000c8e:	854a                	mv	a0,s2
    80000c90:	00000097          	auipc	ra,0x0
    80000c94:	e12080e7          	jalr	-494(ra) # 80000aa2 <increment_page_usage>
    kfree(p);
    80000c98:	854a                	mv	a0,s2
    80000c9a:	00000097          	auipc	ra,0x0
    80000c9e:	edc080e7          	jalr	-292(ra) # 80000b76 <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000ca2:	94d2                	add	s1,s1,s4
    80000ca4:	fe99f3e3          	bgeu	s3,s1,80000c8a <freerange+0x2a>
}
    80000ca8:	70e2                	ld	ra,56(sp)
    80000caa:	7442                	ld	s0,48(sp)
    80000cac:	74a2                	ld	s1,40(sp)
    80000cae:	7902                	ld	s2,32(sp)
    80000cb0:	69e2                	ld	s3,24(sp)
    80000cb2:	6a42                	ld	s4,16(sp)
    80000cb4:	6aa2                	ld	s5,8(sp)
    80000cb6:	6121                	addi	sp,sp,64
    80000cb8:	8082                	ret

0000000080000cba <kinit>:
{
    80000cba:	1141                	addi	sp,sp,-16
    80000cbc:	e406                	sd	ra,8(sp)
    80000cbe:	e022                	sd	s0,0(sp)
    80000cc0:	0800                	addi	s0,sp,16
  init_page_tracker();
    80000cc2:	00000097          	auipc	ra,0x0
    80000cc6:	d28080e7          	jalr	-728(ra) # 800009ea <init_page_tracker>
  initlock(&kmem.lock, "kmem");
    80000cca:	00007597          	auipc	a1,0x7
    80000cce:	3ee58593          	addi	a1,a1,1006 # 800080b8 <digits+0x78>
    80000cd2:	00010517          	auipc	a0,0x10
    80000cd6:	eae50513          	addi	a0,a0,-338 # 80010b80 <kmem>
    80000cda:	00000097          	auipc	ra,0x0
    80000cde:	090080e7          	jalr	144(ra) # 80000d6a <initlock>
  freerange(end, (void *)PHYSTOP);
    80000ce2:	45c5                	li	a1,17
    80000ce4:	05ee                	slli	a1,a1,0x1b
    80000ce6:	00242517          	auipc	a0,0x242
    80000cea:	ae250513          	addi	a0,a0,-1310 # 802427c8 <end>
    80000cee:	00000097          	auipc	ra,0x0
    80000cf2:	f72080e7          	jalr	-142(ra) # 80000c60 <freerange>
}
    80000cf6:	60a2                	ld	ra,8(sp)
    80000cf8:	6402                	ld	s0,0(sp)
    80000cfa:	0141                	addi	sp,sp,16
    80000cfc:	8082                	ret

0000000080000cfe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000cfe:	1101                	addi	sp,sp,-32
    80000d00:	ec06                	sd	ra,24(sp)
    80000d02:	e822                	sd	s0,16(sp)
    80000d04:	e426                	sd	s1,8(sp)
    80000d06:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000d08:	00010497          	auipc	s1,0x10
    80000d0c:	e7848493          	addi	s1,s1,-392 # 80010b80 <kmem>
    80000d10:	8526                	mv	a0,s1
    80000d12:	00000097          	auipc	ra,0x0
    80000d16:	0e8080e7          	jalr	232(ra) # 80000dfa <acquire>
  r = kmem.freelist;
    80000d1a:	6c84                	ld	s1,24(s1)
  if (r)
    80000d1c:	cc95                	beqz	s1,80000d58 <kalloc+0x5a>
    kmem.freelist = r->next;
    80000d1e:	609c                	ld	a5,0(s1)
    80000d20:	00010517          	auipc	a0,0x10
    80000d24:	e6050513          	addi	a0,a0,-416 # 80010b80 <kmem>
    80000d28:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000d2a:	00000097          	auipc	ra,0x0
    80000d2e:	184080e7          	jalr	388(ra) # 80000eae <release>

  if (r)
  {
    memset((char *)r, 100, PGSIZE); // fill with junk
    80000d32:	6605                	lui	a2,0x1
    80000d34:	06400593          	li	a1,100
    80000d38:	8526                	mv	a0,s1
    80000d3a:	00000097          	auipc	ra,0x0
    80000d3e:	1bc080e7          	jalr	444(ra) # 80000ef6 <memset>
    increment_page_usage((void *)r);
    80000d42:	8526                	mv	a0,s1
    80000d44:	00000097          	auipc	ra,0x0
    80000d48:	d5e080e7          	jalr	-674(ra) # 80000aa2 <increment_page_usage>
  }
  return (void *)r;
}
    80000d4c:	8526                	mv	a0,s1
    80000d4e:	60e2                	ld	ra,24(sp)
    80000d50:	6442                	ld	s0,16(sp)
    80000d52:	64a2                	ld	s1,8(sp)
    80000d54:	6105                	addi	sp,sp,32
    80000d56:	8082                	ret
  release(&kmem.lock);
    80000d58:	00010517          	auipc	a0,0x10
    80000d5c:	e2850513          	addi	a0,a0,-472 # 80010b80 <kmem>
    80000d60:	00000097          	auipc	ra,0x0
    80000d64:	14e080e7          	jalr	334(ra) # 80000eae <release>
  if (r)
    80000d68:	b7d5                	j	80000d4c <kalloc+0x4e>

0000000080000d6a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000d6a:	1141                	addi	sp,sp,-16
    80000d6c:	e422                	sd	s0,8(sp)
    80000d6e:	0800                	addi	s0,sp,16
  lk->name = name;
    80000d70:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000d72:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000d76:	00053823          	sd	zero,16(a0)
}
    80000d7a:	6422                	ld	s0,8(sp)
    80000d7c:	0141                	addi	sp,sp,16
    80000d7e:	8082                	ret

0000000080000d80 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000d80:	411c                	lw	a5,0(a0)
    80000d82:	e399                	bnez	a5,80000d88 <holding+0x8>
    80000d84:	4501                	li	a0,0
  return r;
}
    80000d86:	8082                	ret
{
    80000d88:	1101                	addi	sp,sp,-32
    80000d8a:	ec06                	sd	ra,24(sp)
    80000d8c:	e822                	sd	s0,16(sp)
    80000d8e:	e426                	sd	s1,8(sp)
    80000d90:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000d92:	6904                	ld	s1,16(a0)
    80000d94:	00001097          	auipc	ra,0x1
    80000d98:	e5e080e7          	jalr	-418(ra) # 80001bf2 <mycpu>
    80000d9c:	40a48533          	sub	a0,s1,a0
    80000da0:	00153513          	seqz	a0,a0
}
    80000da4:	60e2                	ld	ra,24(sp)
    80000da6:	6442                	ld	s0,16(sp)
    80000da8:	64a2                	ld	s1,8(sp)
    80000daa:	6105                	addi	sp,sp,32
    80000dac:	8082                	ret

0000000080000dae <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000dae:	1101                	addi	sp,sp,-32
    80000db0:	ec06                	sd	ra,24(sp)
    80000db2:	e822                	sd	s0,16(sp)
    80000db4:	e426                	sd	s1,8(sp)
    80000db6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000db8:	100024f3          	csrr	s1,sstatus
    80000dbc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000dc0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000dc2:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000dc6:	00001097          	auipc	ra,0x1
    80000dca:	e2c080e7          	jalr	-468(ra) # 80001bf2 <mycpu>
    80000dce:	5d3c                	lw	a5,120(a0)
    80000dd0:	cf89                	beqz	a5,80000dea <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000dd2:	00001097          	auipc	ra,0x1
    80000dd6:	e20080e7          	jalr	-480(ra) # 80001bf2 <mycpu>
    80000dda:	5d3c                	lw	a5,120(a0)
    80000ddc:	2785                	addiw	a5,a5,1
    80000dde:	dd3c                	sw	a5,120(a0)
}
    80000de0:	60e2                	ld	ra,24(sp)
    80000de2:	6442                	ld	s0,16(sp)
    80000de4:	64a2                	ld	s1,8(sp)
    80000de6:	6105                	addi	sp,sp,32
    80000de8:	8082                	ret
    mycpu()->intena = old;
    80000dea:	00001097          	auipc	ra,0x1
    80000dee:	e08080e7          	jalr	-504(ra) # 80001bf2 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000df2:	8085                	srli	s1,s1,0x1
    80000df4:	8885                	andi	s1,s1,1
    80000df6:	dd64                	sw	s1,124(a0)
    80000df8:	bfe9                	j	80000dd2 <push_off+0x24>

0000000080000dfa <acquire>:
{
    80000dfa:	1101                	addi	sp,sp,-32
    80000dfc:	ec06                	sd	ra,24(sp)
    80000dfe:	e822                	sd	s0,16(sp)
    80000e00:	e426                	sd	s1,8(sp)
    80000e02:	1000                	addi	s0,sp,32
    80000e04:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000e06:	00000097          	auipc	ra,0x0
    80000e0a:	fa8080e7          	jalr	-88(ra) # 80000dae <push_off>
  if(holding(lk))
    80000e0e:	8526                	mv	a0,s1
    80000e10:	00000097          	auipc	ra,0x0
    80000e14:	f70080e7          	jalr	-144(ra) # 80000d80 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000e18:	4705                	li	a4,1
  if(holding(lk))
    80000e1a:	e115                	bnez	a0,80000e3e <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000e1c:	87ba                	mv	a5,a4
    80000e1e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000e22:	2781                	sext.w	a5,a5
    80000e24:	ffe5                	bnez	a5,80000e1c <acquire+0x22>
  __sync_synchronize();
    80000e26:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000e2a:	00001097          	auipc	ra,0x1
    80000e2e:	dc8080e7          	jalr	-568(ra) # 80001bf2 <mycpu>
    80000e32:	e888                	sd	a0,16(s1)
}
    80000e34:	60e2                	ld	ra,24(sp)
    80000e36:	6442                	ld	s0,16(sp)
    80000e38:	64a2                	ld	s1,8(sp)
    80000e3a:	6105                	addi	sp,sp,32
    80000e3c:	8082                	ret
    panic("acquire");
    80000e3e:	00007517          	auipc	a0,0x7
    80000e42:	28250513          	addi	a0,a0,642 # 800080c0 <digits+0x80>
    80000e46:	fffff097          	auipc	ra,0xfffff
    80000e4a:	6f8080e7          	jalr	1784(ra) # 8000053e <panic>

0000000080000e4e <pop_off>:

void
pop_off(void)
{
    80000e4e:	1141                	addi	sp,sp,-16
    80000e50:	e406                	sd	ra,8(sp)
    80000e52:	e022                	sd	s0,0(sp)
    80000e54:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000e56:	00001097          	auipc	ra,0x1
    80000e5a:	d9c080e7          	jalr	-612(ra) # 80001bf2 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000e5e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000e62:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000e64:	e78d                	bnez	a5,80000e8e <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000e66:	5d3c                	lw	a5,120(a0)
    80000e68:	02f05b63          	blez	a5,80000e9e <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000e6c:	37fd                	addiw	a5,a5,-1
    80000e6e:	0007871b          	sext.w	a4,a5
    80000e72:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000e74:	eb09                	bnez	a4,80000e86 <pop_off+0x38>
    80000e76:	5d7c                	lw	a5,124(a0)
    80000e78:	c799                	beqz	a5,80000e86 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000e7a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000e7e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000e82:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000e86:	60a2                	ld	ra,8(sp)
    80000e88:	6402                	ld	s0,0(sp)
    80000e8a:	0141                	addi	sp,sp,16
    80000e8c:	8082                	ret
    panic("pop_off - interruptible");
    80000e8e:	00007517          	auipc	a0,0x7
    80000e92:	23a50513          	addi	a0,a0,570 # 800080c8 <digits+0x88>
    80000e96:	fffff097          	auipc	ra,0xfffff
    80000e9a:	6a8080e7          	jalr	1704(ra) # 8000053e <panic>
    panic("pop_off");
    80000e9e:	00007517          	auipc	a0,0x7
    80000ea2:	24250513          	addi	a0,a0,578 # 800080e0 <digits+0xa0>
    80000ea6:	fffff097          	auipc	ra,0xfffff
    80000eaa:	698080e7          	jalr	1688(ra) # 8000053e <panic>

0000000080000eae <release>:
{
    80000eae:	1101                	addi	sp,sp,-32
    80000eb0:	ec06                	sd	ra,24(sp)
    80000eb2:	e822                	sd	s0,16(sp)
    80000eb4:	e426                	sd	s1,8(sp)
    80000eb6:	1000                	addi	s0,sp,32
    80000eb8:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000eba:	00000097          	auipc	ra,0x0
    80000ebe:	ec6080e7          	jalr	-314(ra) # 80000d80 <holding>
    80000ec2:	c115                	beqz	a0,80000ee6 <release+0x38>
  lk->cpu = 0;
    80000ec4:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ec8:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ecc:	0f50000f          	fence	iorw,ow
    80000ed0:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000ed4:	00000097          	auipc	ra,0x0
    80000ed8:	f7a080e7          	jalr	-134(ra) # 80000e4e <pop_off>
}
    80000edc:	60e2                	ld	ra,24(sp)
    80000ede:	6442                	ld	s0,16(sp)
    80000ee0:	64a2                	ld	s1,8(sp)
    80000ee2:	6105                	addi	sp,sp,32
    80000ee4:	8082                	ret
    panic("release");
    80000ee6:	00007517          	auipc	a0,0x7
    80000eea:	20250513          	addi	a0,a0,514 # 800080e8 <digits+0xa8>
    80000eee:	fffff097          	auipc	ra,0xfffff
    80000ef2:	650080e7          	jalr	1616(ra) # 8000053e <panic>

0000000080000ef6 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000ef6:	1141                	addi	sp,sp,-16
    80000ef8:	e422                	sd	s0,8(sp)
    80000efa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000efc:	ca19                	beqz	a2,80000f12 <memset+0x1c>
    80000efe:	87aa                	mv	a5,a0
    80000f00:	1602                	slli	a2,a2,0x20
    80000f02:	9201                	srli	a2,a2,0x20
    80000f04:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000f08:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000f0c:	0785                	addi	a5,a5,1
    80000f0e:	fee79de3          	bne	a5,a4,80000f08 <memset+0x12>
  }
  return dst;
}
    80000f12:	6422                	ld	s0,8(sp)
    80000f14:	0141                	addi	sp,sp,16
    80000f16:	8082                	ret

0000000080000f18 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000f18:	1141                	addi	sp,sp,-16
    80000f1a:	e422                	sd	s0,8(sp)
    80000f1c:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000f1e:	ca05                	beqz	a2,80000f4e <memcmp+0x36>
    80000f20:	fff6069b          	addiw	a3,a2,-1
    80000f24:	1682                	slli	a3,a3,0x20
    80000f26:	9281                	srli	a3,a3,0x20
    80000f28:	0685                	addi	a3,a3,1
    80000f2a:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000f2c:	00054783          	lbu	a5,0(a0)
    80000f30:	0005c703          	lbu	a4,0(a1)
    80000f34:	00e79863          	bne	a5,a4,80000f44 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000f38:	0505                	addi	a0,a0,1
    80000f3a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000f3c:	fed518e3          	bne	a0,a3,80000f2c <memcmp+0x14>
  }

  return 0;
    80000f40:	4501                	li	a0,0
    80000f42:	a019                	j	80000f48 <memcmp+0x30>
      return *s1 - *s2;
    80000f44:	40e7853b          	subw	a0,a5,a4
}
    80000f48:	6422                	ld	s0,8(sp)
    80000f4a:	0141                	addi	sp,sp,16
    80000f4c:	8082                	ret
  return 0;
    80000f4e:	4501                	li	a0,0
    80000f50:	bfe5                	j	80000f48 <memcmp+0x30>

0000000080000f52 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000f52:	1141                	addi	sp,sp,-16
    80000f54:	e422                	sd	s0,8(sp)
    80000f56:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000f58:	c205                	beqz	a2,80000f78 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000f5a:	02a5e263          	bltu	a1,a0,80000f7e <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000f5e:	1602                	slli	a2,a2,0x20
    80000f60:	9201                	srli	a2,a2,0x20
    80000f62:	00c587b3          	add	a5,a1,a2
{
    80000f66:	872a                	mv	a4,a0
      *d++ = *s++;
    80000f68:	0585                	addi	a1,a1,1
    80000f6a:	0705                	addi	a4,a4,1
    80000f6c:	fff5c683          	lbu	a3,-1(a1)
    80000f70:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000f74:	fef59ae3          	bne	a1,a5,80000f68 <memmove+0x16>

  return dst;
}
    80000f78:	6422                	ld	s0,8(sp)
    80000f7a:	0141                	addi	sp,sp,16
    80000f7c:	8082                	ret
  if(s < d && s + n > d){
    80000f7e:	02061693          	slli	a3,a2,0x20
    80000f82:	9281                	srli	a3,a3,0x20
    80000f84:	00d58733          	add	a4,a1,a3
    80000f88:	fce57be3          	bgeu	a0,a4,80000f5e <memmove+0xc>
    d += n;
    80000f8c:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000f8e:	fff6079b          	addiw	a5,a2,-1
    80000f92:	1782                	slli	a5,a5,0x20
    80000f94:	9381                	srli	a5,a5,0x20
    80000f96:	fff7c793          	not	a5,a5
    80000f9a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000f9c:	177d                	addi	a4,a4,-1
    80000f9e:	16fd                	addi	a3,a3,-1
    80000fa0:	00074603          	lbu	a2,0(a4)
    80000fa4:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000fa8:	fee79ae3          	bne	a5,a4,80000f9c <memmove+0x4a>
    80000fac:	b7f1                	j	80000f78 <memmove+0x26>

0000000080000fae <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000fae:	1141                	addi	sp,sp,-16
    80000fb0:	e406                	sd	ra,8(sp)
    80000fb2:	e022                	sd	s0,0(sp)
    80000fb4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000fb6:	00000097          	auipc	ra,0x0
    80000fba:	f9c080e7          	jalr	-100(ra) # 80000f52 <memmove>
}
    80000fbe:	60a2                	ld	ra,8(sp)
    80000fc0:	6402                	ld	s0,0(sp)
    80000fc2:	0141                	addi	sp,sp,16
    80000fc4:	8082                	ret

0000000080000fc6 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000fc6:	1141                	addi	sp,sp,-16
    80000fc8:	e422                	sd	s0,8(sp)
    80000fca:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000fcc:	ce11                	beqz	a2,80000fe8 <strncmp+0x22>
    80000fce:	00054783          	lbu	a5,0(a0)
    80000fd2:	cf89                	beqz	a5,80000fec <strncmp+0x26>
    80000fd4:	0005c703          	lbu	a4,0(a1)
    80000fd8:	00f71a63          	bne	a4,a5,80000fec <strncmp+0x26>
    n--, p++, q++;
    80000fdc:	367d                	addiw	a2,a2,-1
    80000fde:	0505                	addi	a0,a0,1
    80000fe0:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000fe2:	f675                	bnez	a2,80000fce <strncmp+0x8>
  if(n == 0)
    return 0;
    80000fe4:	4501                	li	a0,0
    80000fe6:	a809                	j	80000ff8 <strncmp+0x32>
    80000fe8:	4501                	li	a0,0
    80000fea:	a039                	j	80000ff8 <strncmp+0x32>
  if(n == 0)
    80000fec:	ca09                	beqz	a2,80000ffe <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000fee:	00054503          	lbu	a0,0(a0)
    80000ff2:	0005c783          	lbu	a5,0(a1)
    80000ff6:	9d1d                	subw	a0,a0,a5
}
    80000ff8:	6422                	ld	s0,8(sp)
    80000ffa:	0141                	addi	sp,sp,16
    80000ffc:	8082                	ret
    return 0;
    80000ffe:	4501                	li	a0,0
    80001000:	bfe5                	j	80000ff8 <strncmp+0x32>

0000000080001002 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80001002:	1141                	addi	sp,sp,-16
    80001004:	e422                	sd	s0,8(sp)
    80001006:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80001008:	872a                	mv	a4,a0
    8000100a:	8832                	mv	a6,a2
    8000100c:	367d                	addiw	a2,a2,-1
    8000100e:	01005963          	blez	a6,80001020 <strncpy+0x1e>
    80001012:	0705                	addi	a4,a4,1
    80001014:	0005c783          	lbu	a5,0(a1)
    80001018:	fef70fa3          	sb	a5,-1(a4)
    8000101c:	0585                	addi	a1,a1,1
    8000101e:	f7f5                	bnez	a5,8000100a <strncpy+0x8>
    ;
  while(n-- > 0)
    80001020:	86ba                	mv	a3,a4
    80001022:	00c05c63          	blez	a2,8000103a <strncpy+0x38>
    *s++ = 0;
    80001026:	0685                	addi	a3,a3,1
    80001028:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    8000102c:	fff6c793          	not	a5,a3
    80001030:	9fb9                	addw	a5,a5,a4
    80001032:	010787bb          	addw	a5,a5,a6
    80001036:	fef048e3          	bgtz	a5,80001026 <strncpy+0x24>
  return os;
}
    8000103a:	6422                	ld	s0,8(sp)
    8000103c:	0141                	addi	sp,sp,16
    8000103e:	8082                	ret

0000000080001040 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80001040:	1141                	addi	sp,sp,-16
    80001042:	e422                	sd	s0,8(sp)
    80001044:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80001046:	02c05363          	blez	a2,8000106c <safestrcpy+0x2c>
    8000104a:	fff6069b          	addiw	a3,a2,-1
    8000104e:	1682                	slli	a3,a3,0x20
    80001050:	9281                	srli	a3,a3,0x20
    80001052:	96ae                	add	a3,a3,a1
    80001054:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80001056:	00d58963          	beq	a1,a3,80001068 <safestrcpy+0x28>
    8000105a:	0585                	addi	a1,a1,1
    8000105c:	0785                	addi	a5,a5,1
    8000105e:	fff5c703          	lbu	a4,-1(a1)
    80001062:	fee78fa3          	sb	a4,-1(a5)
    80001066:	fb65                	bnez	a4,80001056 <safestrcpy+0x16>
    ;
  *s = 0;
    80001068:	00078023          	sb	zero,0(a5)
  return os;
}
    8000106c:	6422                	ld	s0,8(sp)
    8000106e:	0141                	addi	sp,sp,16
    80001070:	8082                	ret

0000000080001072 <strlen>:

int
strlen(const char *s)
{
    80001072:	1141                	addi	sp,sp,-16
    80001074:	e422                	sd	s0,8(sp)
    80001076:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80001078:	00054783          	lbu	a5,0(a0)
    8000107c:	cf91                	beqz	a5,80001098 <strlen+0x26>
    8000107e:	0505                	addi	a0,a0,1
    80001080:	87aa                	mv	a5,a0
    80001082:	4685                	li	a3,1
    80001084:	9e89                	subw	a3,a3,a0
    80001086:	00f6853b          	addw	a0,a3,a5
    8000108a:	0785                	addi	a5,a5,1
    8000108c:	fff7c703          	lbu	a4,-1(a5)
    80001090:	fb7d                	bnez	a4,80001086 <strlen+0x14>
    ;
  return n;
}
    80001092:	6422                	ld	s0,8(sp)
    80001094:	0141                	addi	sp,sp,16
    80001096:	8082                	ret
  for(n = 0; s[n]; n++)
    80001098:	4501                	li	a0,0
    8000109a:	bfe5                	j	80001092 <strlen+0x20>

000000008000109c <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000109c:	1141                	addi	sp,sp,-16
    8000109e:	e406                	sd	ra,8(sp)
    800010a0:	e022                	sd	s0,0(sp)
    800010a2:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800010a4:	00001097          	auipc	ra,0x1
    800010a8:	b3e080e7          	jalr	-1218(ra) # 80001be2 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800010ac:	00008717          	auipc	a4,0x8
    800010b0:	86c70713          	addi	a4,a4,-1940 # 80008918 <started>
  if(cpuid() == 0){
    800010b4:	c139                	beqz	a0,800010fa <main+0x5e>
    while(started == 0)
    800010b6:	431c                	lw	a5,0(a4)
    800010b8:	2781                	sext.w	a5,a5
    800010ba:	dff5                	beqz	a5,800010b6 <main+0x1a>
      ;
    __sync_synchronize();
    800010bc:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    800010c0:	00001097          	auipc	ra,0x1
    800010c4:	b22080e7          	jalr	-1246(ra) # 80001be2 <cpuid>
    800010c8:	85aa                	mv	a1,a0
    800010ca:	00007517          	auipc	a0,0x7
    800010ce:	03e50513          	addi	a0,a0,62 # 80008108 <digits+0xc8>
    800010d2:	fffff097          	auipc	ra,0xfffff
    800010d6:	4b6080e7          	jalr	1206(ra) # 80000588 <printf>
    kvminithart();    // turn on paging
    800010da:	00000097          	auipc	ra,0x0
    800010de:	0d8080e7          	jalr	216(ra) # 800011b2 <kvminithart>
    trapinithart();   // install kernel trap vector
    800010e2:	00002097          	auipc	ra,0x2
    800010e6:	bfc080e7          	jalr	-1028(ra) # 80002cde <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800010ea:	00005097          	auipc	ra,0x5
    800010ee:	396080e7          	jalr	918(ra) # 80006480 <plicinithart>
  }

  scheduler();        
    800010f2:	00001097          	auipc	ra,0x1
    800010f6:	0a8080e7          	jalr	168(ra) # 8000219a <scheduler>
    consoleinit();
    800010fa:	fffff097          	auipc	ra,0xfffff
    800010fe:	356080e7          	jalr	854(ra) # 80000450 <consoleinit>
    printfinit();
    80001102:	fffff097          	auipc	ra,0xfffff
    80001106:	666080e7          	jalr	1638(ra) # 80000768 <printfinit>
    printf("\n");
    8000110a:	00007517          	auipc	a0,0x7
    8000110e:	00e50513          	addi	a0,a0,14 # 80008118 <digits+0xd8>
    80001112:	fffff097          	auipc	ra,0xfffff
    80001116:	476080e7          	jalr	1142(ra) # 80000588 <printf>
    printf("xv6 kernel is booting\n");
    8000111a:	00007517          	auipc	a0,0x7
    8000111e:	fd650513          	addi	a0,a0,-42 # 800080f0 <digits+0xb0>
    80001122:	fffff097          	auipc	ra,0xfffff
    80001126:	466080e7          	jalr	1126(ra) # 80000588 <printf>
    printf("\n");
    8000112a:	00007517          	auipc	a0,0x7
    8000112e:	fee50513          	addi	a0,a0,-18 # 80008118 <digits+0xd8>
    80001132:	fffff097          	auipc	ra,0xfffff
    80001136:	456080e7          	jalr	1110(ra) # 80000588 <printf>
    kinit();         // physical page allocator
    8000113a:	00000097          	auipc	ra,0x0
    8000113e:	b80080e7          	jalr	-1152(ra) # 80000cba <kinit>
    kvminit();       // create kernel page table
    80001142:	00000097          	auipc	ra,0x0
    80001146:	326080e7          	jalr	806(ra) # 80001468 <kvminit>
    kvminithart();   // turn on paging
    8000114a:	00000097          	auipc	ra,0x0
    8000114e:	068080e7          	jalr	104(ra) # 800011b2 <kvminithart>
    procinit();      // process table
    80001152:	00001097          	auipc	ra,0x1
    80001156:	9dc080e7          	jalr	-1572(ra) # 80001b2e <procinit>
    trapinit();      // trap vectors
    8000115a:	00002097          	auipc	ra,0x2
    8000115e:	b5c080e7          	jalr	-1188(ra) # 80002cb6 <trapinit>
    trapinithart();  // install kernel trap vector
    80001162:	00002097          	auipc	ra,0x2
    80001166:	b7c080e7          	jalr	-1156(ra) # 80002cde <trapinithart>
    plicinit();      // set up interrupt controller
    8000116a:	00005097          	auipc	ra,0x5
    8000116e:	300080e7          	jalr	768(ra) # 8000646a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80001172:	00005097          	auipc	ra,0x5
    80001176:	30e080e7          	jalr	782(ra) # 80006480 <plicinithart>
    binit();         // buffer cache
    8000117a:	00002097          	auipc	ra,0x2
    8000117e:	492080e7          	jalr	1170(ra) # 8000360c <binit>
    iinit();         // inode table
    80001182:	00003097          	auipc	ra,0x3
    80001186:	b36080e7          	jalr	-1226(ra) # 80003cb8 <iinit>
    fileinit();      // file table
    8000118a:	00004097          	auipc	ra,0x4
    8000118e:	ad4080e7          	jalr	-1324(ra) # 80004c5e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80001192:	00005097          	auipc	ra,0x5
    80001196:	3f6080e7          	jalr	1014(ra) # 80006588 <virtio_disk_init>
    userinit();      // first user process
    8000119a:	00001097          	auipc	ra,0x1
    8000119e:	d86080e7          	jalr	-634(ra) # 80001f20 <userinit>
    __sync_synchronize();
    800011a2:	0ff0000f          	fence
    started = 1;
    800011a6:	4785                	li	a5,1
    800011a8:	00007717          	auipc	a4,0x7
    800011ac:	76f72823          	sw	a5,1904(a4) # 80008918 <started>
    800011b0:	b789                	j	800010f2 <main+0x56>

00000000800011b2 <kvminithart>:
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart()
{
    800011b2:	1141                	addi	sp,sp,-16
    800011b4:	e422                	sd	s0,8(sp)
    800011b6:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800011b8:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800011bc:	00007797          	auipc	a5,0x7
    800011c0:	7647b783          	ld	a5,1892(a5) # 80008920 <kernel_pagetable>
    800011c4:	83b1                	srli	a5,a5,0xc
    800011c6:	577d                	li	a4,-1
    800011c8:	177e                	slli	a4,a4,0x3f
    800011ca:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800011cc:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800011d0:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800011d4:	6422                	ld	s0,8(sp)
    800011d6:	0141                	addi	sp,sp,16
    800011d8:	8082                	ret

00000000800011da <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800011da:	7139                	addi	sp,sp,-64
    800011dc:	fc06                	sd	ra,56(sp)
    800011de:	f822                	sd	s0,48(sp)
    800011e0:	f426                	sd	s1,40(sp)
    800011e2:	f04a                	sd	s2,32(sp)
    800011e4:	ec4e                	sd	s3,24(sp)
    800011e6:	e852                	sd	s4,16(sp)
    800011e8:	e456                	sd	s5,8(sp)
    800011ea:	e05a                	sd	s6,0(sp)
    800011ec:	0080                	addi	s0,sp,64
    800011ee:	84aa                	mv	s1,a0
    800011f0:	89ae                	mv	s3,a1
    800011f2:	8ab2                	mv	s5,a2
  if (va >= MAXVA)
    800011f4:	57fd                	li	a5,-1
    800011f6:	83e9                	srli	a5,a5,0x1a
    800011f8:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--)
    800011fa:	4b31                	li	s6,12
  if (va >= MAXVA)
    800011fc:	04b7f263          	bgeu	a5,a1,80001240 <walk+0x66>
    panic("walk");
    80001200:	00007517          	auipc	a0,0x7
    80001204:	f2050513          	addi	a0,a0,-224 # 80008120 <digits+0xe0>
    80001208:	fffff097          	auipc	ra,0xfffff
    8000120c:	336080e7          	jalr	822(ra) # 8000053e <panic>
    {
      pagetable = (pagetable_t)PTE2PA(*pte);
    }
    else
    {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80001210:	060a8663          	beqz	s5,8000127c <walk+0xa2>
    80001214:	00000097          	auipc	ra,0x0
    80001218:	aea080e7          	jalr	-1302(ra) # 80000cfe <kalloc>
    8000121c:	84aa                	mv	s1,a0
    8000121e:	c529                	beqz	a0,80001268 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001220:	6605                	lui	a2,0x1
    80001222:	4581                	li	a1,0
    80001224:	00000097          	auipc	ra,0x0
    80001228:	cd2080e7          	jalr	-814(ra) # 80000ef6 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000122c:	00c4d793          	srli	a5,s1,0xc
    80001230:	07aa                	slli	a5,a5,0xa
    80001232:	0017e793          	ori	a5,a5,1
    80001236:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--)
    8000123a:	3a5d                	addiw	s4,s4,-9
    8000123c:	036a0063          	beq	s4,s6,8000125c <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001240:	0149d933          	srl	s2,s3,s4
    80001244:	1ff97913          	andi	s2,s2,511
    80001248:	090e                	slli	s2,s2,0x3
    8000124a:	9926                	add	s2,s2,s1
    if (*pte & PTE_V)
    8000124c:	00093483          	ld	s1,0(s2)
    80001250:	0014f793          	andi	a5,s1,1
    80001254:	dfd5                	beqz	a5,80001210 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001256:	80a9                	srli	s1,s1,0xa
    80001258:	04b2                	slli	s1,s1,0xc
    8000125a:	b7c5                	j	8000123a <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000125c:	00c9d513          	srli	a0,s3,0xc
    80001260:	1ff57513          	andi	a0,a0,511
    80001264:	050e                	slli	a0,a0,0x3
    80001266:	9526                	add	a0,a0,s1
}
    80001268:	70e2                	ld	ra,56(sp)
    8000126a:	7442                	ld	s0,48(sp)
    8000126c:	74a2                	ld	s1,40(sp)
    8000126e:	7902                	ld	s2,32(sp)
    80001270:	69e2                	ld	s3,24(sp)
    80001272:	6a42                	ld	s4,16(sp)
    80001274:	6aa2                	ld	s5,8(sp)
    80001276:	6b02                	ld	s6,0(sp)
    80001278:	6121                	addi	sp,sp,64
    8000127a:	8082                	ret
        return 0;
    8000127c:	4501                	li	a0,0
    8000127e:	b7ed                	j	80001268 <walk+0x8e>

0000000080001280 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    80001280:	57fd                	li	a5,-1
    80001282:	83e9                	srli	a5,a5,0x1a
    80001284:	00b7f463          	bgeu	a5,a1,8000128c <walkaddr+0xc>
    return 0;
    80001288:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000128a:	8082                	ret
{
    8000128c:	1141                	addi	sp,sp,-16
    8000128e:	e406                	sd	ra,8(sp)
    80001290:	e022                	sd	s0,0(sp)
    80001292:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001294:	4601                	li	a2,0
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	f44080e7          	jalr	-188(ra) # 800011da <walk>
  if (pte == 0)
    8000129e:	c105                	beqz	a0,800012be <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0)
    800012a0:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    800012a2:	0117f693          	andi	a3,a5,17
    800012a6:	4745                	li	a4,17
    return 0;
    800012a8:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    800012aa:	00e68663          	beq	a3,a4,800012b6 <walkaddr+0x36>
}
    800012ae:	60a2                	ld	ra,8(sp)
    800012b0:	6402                	ld	s0,0(sp)
    800012b2:	0141                	addi	sp,sp,16
    800012b4:	8082                	ret
  pa = PTE2PA(*pte);
    800012b6:	00a7d513          	srli	a0,a5,0xa
    800012ba:	0532                	slli	a0,a0,0xc
  return pa;
    800012bc:	bfcd                	j	800012ae <walkaddr+0x2e>
    return 0;
    800012be:	4501                	li	a0,0
    800012c0:	b7fd                	j	800012ae <walkaddr+0x2e>

00000000800012c2 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800012c2:	715d                	addi	sp,sp,-80
    800012c4:	e486                	sd	ra,72(sp)
    800012c6:	e0a2                	sd	s0,64(sp)
    800012c8:	fc26                	sd	s1,56(sp)
    800012ca:	f84a                	sd	s2,48(sp)
    800012cc:	f44e                	sd	s3,40(sp)
    800012ce:	f052                	sd	s4,32(sp)
    800012d0:	ec56                	sd	s5,24(sp)
    800012d2:	e85a                	sd	s6,16(sp)
    800012d4:	e45e                	sd	s7,8(sp)
    800012d6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if (size == 0)
    800012d8:	c639                	beqz	a2,80001326 <mappages+0x64>
    800012da:	8aaa                	mv	s5,a0
    800012dc:	8b3a                	mv	s6,a4
    panic("mappages: size");

  a = PGROUNDDOWN(va);
    800012de:	77fd                	lui	a5,0xfffff
    800012e0:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800012e4:	15fd                	addi	a1,a1,-1
    800012e6:	00c589b3          	add	s3,a1,a2
    800012ea:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800012ee:	8952                	mv	s2,s4
    800012f0:	41468a33          	sub	s4,a3,s4
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    800012f4:	6b85                	lui	s7,0x1
    800012f6:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0)
    800012fa:	4605                	li	a2,1
    800012fc:	85ca                	mv	a1,s2
    800012fe:	8556                	mv	a0,s5
    80001300:	00000097          	auipc	ra,0x0
    80001304:	eda080e7          	jalr	-294(ra) # 800011da <walk>
    80001308:	cd1d                	beqz	a0,80001346 <mappages+0x84>
    if (*pte & PTE_V)
    8000130a:	611c                	ld	a5,0(a0)
    8000130c:	8b85                	andi	a5,a5,1
    8000130e:	e785                	bnez	a5,80001336 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001310:	80b1                	srli	s1,s1,0xc
    80001312:	04aa                	slli	s1,s1,0xa
    80001314:	0164e4b3          	or	s1,s1,s6
    80001318:	0014e493          	ori	s1,s1,1
    8000131c:	e104                	sd	s1,0(a0)
    if (a == last)
    8000131e:	05390063          	beq	s2,s3,8000135e <mappages+0x9c>
    a += PGSIZE;
    80001322:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001324:	bfc9                	j	800012f6 <mappages+0x34>
    panic("mappages: size");
    80001326:	00007517          	auipc	a0,0x7
    8000132a:	e0250513          	addi	a0,a0,-510 # 80008128 <digits+0xe8>
    8000132e:	fffff097          	auipc	ra,0xfffff
    80001332:	210080e7          	jalr	528(ra) # 8000053e <panic>
      panic("mappages: remap");
    80001336:	00007517          	auipc	a0,0x7
    8000133a:	e0250513          	addi	a0,a0,-510 # 80008138 <digits+0xf8>
    8000133e:	fffff097          	auipc	ra,0xfffff
    80001342:	200080e7          	jalr	512(ra) # 8000053e <panic>
      return -1;
    80001346:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001348:	60a6                	ld	ra,72(sp)
    8000134a:	6406                	ld	s0,64(sp)
    8000134c:	74e2                	ld	s1,56(sp)
    8000134e:	7942                	ld	s2,48(sp)
    80001350:	79a2                	ld	s3,40(sp)
    80001352:	7a02                	ld	s4,32(sp)
    80001354:	6ae2                	ld	s5,24(sp)
    80001356:	6b42                	ld	s6,16(sp)
    80001358:	6ba2                	ld	s7,8(sp)
    8000135a:	6161                	addi	sp,sp,80
    8000135c:	8082                	ret
  return 0;
    8000135e:	4501                	li	a0,0
    80001360:	b7e5                	j	80001348 <mappages+0x86>

0000000080001362 <kvmmap>:
{
    80001362:	1141                	addi	sp,sp,-16
    80001364:	e406                	sd	ra,8(sp)
    80001366:	e022                	sd	s0,0(sp)
    80001368:	0800                	addi	s0,sp,16
    8000136a:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000136c:	86b2                	mv	a3,a2
    8000136e:	863e                	mv	a2,a5
    80001370:	00000097          	auipc	ra,0x0
    80001374:	f52080e7          	jalr	-174(ra) # 800012c2 <mappages>
    80001378:	e509                	bnez	a0,80001382 <kvmmap+0x20>
}
    8000137a:	60a2                	ld	ra,8(sp)
    8000137c:	6402                	ld	s0,0(sp)
    8000137e:	0141                	addi	sp,sp,16
    80001380:	8082                	ret
    panic("kvmmap");
    80001382:	00007517          	auipc	a0,0x7
    80001386:	dc650513          	addi	a0,a0,-570 # 80008148 <digits+0x108>
    8000138a:	fffff097          	auipc	ra,0xfffff
    8000138e:	1b4080e7          	jalr	436(ra) # 8000053e <panic>

0000000080001392 <kvmmake>:
{
    80001392:	1101                	addi	sp,sp,-32
    80001394:	ec06                	sd	ra,24(sp)
    80001396:	e822                	sd	s0,16(sp)
    80001398:	e426                	sd	s1,8(sp)
    8000139a:	e04a                	sd	s2,0(sp)
    8000139c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    8000139e:	00000097          	auipc	ra,0x0
    800013a2:	960080e7          	jalr	-1696(ra) # 80000cfe <kalloc>
    800013a6:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800013a8:	6605                	lui	a2,0x1
    800013aa:	4581                	li	a1,0
    800013ac:	00000097          	auipc	ra,0x0
    800013b0:	b4a080e7          	jalr	-1206(ra) # 80000ef6 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800013b4:	4719                	li	a4,6
    800013b6:	6685                	lui	a3,0x1
    800013b8:	10000637          	lui	a2,0x10000
    800013bc:	100005b7          	lui	a1,0x10000
    800013c0:	8526                	mv	a0,s1
    800013c2:	00000097          	auipc	ra,0x0
    800013c6:	fa0080e7          	jalr	-96(ra) # 80001362 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800013ca:	4719                	li	a4,6
    800013cc:	6685                	lui	a3,0x1
    800013ce:	10001637          	lui	a2,0x10001
    800013d2:	100015b7          	lui	a1,0x10001
    800013d6:	8526                	mv	a0,s1
    800013d8:	00000097          	auipc	ra,0x0
    800013dc:	f8a080e7          	jalr	-118(ra) # 80001362 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800013e0:	4719                	li	a4,6
    800013e2:	004006b7          	lui	a3,0x400
    800013e6:	0c000637          	lui	a2,0xc000
    800013ea:	0c0005b7          	lui	a1,0xc000
    800013ee:	8526                	mv	a0,s1
    800013f0:	00000097          	auipc	ra,0x0
    800013f4:	f72080e7          	jalr	-142(ra) # 80001362 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    800013f8:	00007917          	auipc	s2,0x7
    800013fc:	c0890913          	addi	s2,s2,-1016 # 80008000 <etext>
    80001400:	4729                	li	a4,10
    80001402:	80007697          	auipc	a3,0x80007
    80001406:	bfe68693          	addi	a3,a3,-1026 # 8000 <_entry-0x7fff8000>
    8000140a:	4605                	li	a2,1
    8000140c:	067e                	slli	a2,a2,0x1f
    8000140e:	85b2                	mv	a1,a2
    80001410:	8526                	mv	a0,s1
    80001412:	00000097          	auipc	ra,0x0
    80001416:	f50080e7          	jalr	-176(ra) # 80001362 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    8000141a:	4719                	li	a4,6
    8000141c:	46c5                	li	a3,17
    8000141e:	06ee                	slli	a3,a3,0x1b
    80001420:	412686b3          	sub	a3,a3,s2
    80001424:	864a                	mv	a2,s2
    80001426:	85ca                	mv	a1,s2
    80001428:	8526                	mv	a0,s1
    8000142a:	00000097          	auipc	ra,0x0
    8000142e:	f38080e7          	jalr	-200(ra) # 80001362 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001432:	4729                	li	a4,10
    80001434:	6685                	lui	a3,0x1
    80001436:	00006617          	auipc	a2,0x6
    8000143a:	bca60613          	addi	a2,a2,-1078 # 80007000 <_trampoline>
    8000143e:	040005b7          	lui	a1,0x4000
    80001442:	15fd                	addi	a1,a1,-1
    80001444:	05b2                	slli	a1,a1,0xc
    80001446:	8526                	mv	a0,s1
    80001448:	00000097          	auipc	ra,0x0
    8000144c:	f1a080e7          	jalr	-230(ra) # 80001362 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001450:	8526                	mv	a0,s1
    80001452:	00000097          	auipc	ra,0x0
    80001456:	646080e7          	jalr	1606(ra) # 80001a98 <proc_mapstacks>
}
    8000145a:	8526                	mv	a0,s1
    8000145c:	60e2                	ld	ra,24(sp)
    8000145e:	6442                	ld	s0,16(sp)
    80001460:	64a2                	ld	s1,8(sp)
    80001462:	6902                	ld	s2,0(sp)
    80001464:	6105                	addi	sp,sp,32
    80001466:	8082                	ret

0000000080001468 <kvminit>:
{
    80001468:	1141                	addi	sp,sp,-16
    8000146a:	e406                	sd	ra,8(sp)
    8000146c:	e022                	sd	s0,0(sp)
    8000146e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001470:	00000097          	auipc	ra,0x0
    80001474:	f22080e7          	jalr	-222(ra) # 80001392 <kvmmake>
    80001478:	00007797          	auipc	a5,0x7
    8000147c:	4aa7b423          	sd	a0,1192(a5) # 80008920 <kernel_pagetable>
}
    80001480:	60a2                	ld	ra,8(sp)
    80001482:	6402                	ld	s0,0(sp)
    80001484:	0141                	addi	sp,sp,16
    80001486:	8082                	ret

0000000080001488 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001488:	715d                	addi	sp,sp,-80
    8000148a:	e486                	sd	ra,72(sp)
    8000148c:	e0a2                	sd	s0,64(sp)
    8000148e:	fc26                	sd	s1,56(sp)
    80001490:	f84a                	sd	s2,48(sp)
    80001492:	f44e                	sd	s3,40(sp)
    80001494:	f052                	sd	s4,32(sp)
    80001496:	ec56                	sd	s5,24(sp)
    80001498:	e85a                	sd	s6,16(sp)
    8000149a:	e45e                	sd	s7,8(sp)
    8000149c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    8000149e:	03459793          	slli	a5,a1,0x34
    800014a2:	e795                	bnez	a5,800014ce <uvmunmap+0x46>
    800014a4:	8a2a                	mv	s4,a0
    800014a6:	892e                	mv	s2,a1
    800014a8:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    800014aa:	0632                	slli	a2,a2,0xc
    800014ac:	00b609b3          	add	s3,a2,a1
  {
    if ((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V)
    800014b0:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    800014b2:	6b05                	lui	s6,0x1
    800014b4:	0735e263          	bltu	a1,s3,80001518 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
  }
}
    800014b8:	60a6                	ld	ra,72(sp)
    800014ba:	6406                	ld	s0,64(sp)
    800014bc:	74e2                	ld	s1,56(sp)
    800014be:	7942                	ld	s2,48(sp)
    800014c0:	79a2                	ld	s3,40(sp)
    800014c2:	7a02                	ld	s4,32(sp)
    800014c4:	6ae2                	ld	s5,24(sp)
    800014c6:	6b42                	ld	s6,16(sp)
    800014c8:	6ba2                	ld	s7,8(sp)
    800014ca:	6161                	addi	sp,sp,80
    800014cc:	8082                	ret
    panic("uvmunmap: not aligned");
    800014ce:	00007517          	auipc	a0,0x7
    800014d2:	c8250513          	addi	a0,a0,-894 # 80008150 <digits+0x110>
    800014d6:	fffff097          	auipc	ra,0xfffff
    800014da:	068080e7          	jalr	104(ra) # 8000053e <panic>
      panic("uvmunmap: walk");
    800014de:	00007517          	auipc	a0,0x7
    800014e2:	c8a50513          	addi	a0,a0,-886 # 80008168 <digits+0x128>
    800014e6:	fffff097          	auipc	ra,0xfffff
    800014ea:	058080e7          	jalr	88(ra) # 8000053e <panic>
      panic("uvmunmap: not mapped");
    800014ee:	00007517          	auipc	a0,0x7
    800014f2:	c8a50513          	addi	a0,a0,-886 # 80008178 <digits+0x138>
    800014f6:	fffff097          	auipc	ra,0xfffff
    800014fa:	048080e7          	jalr	72(ra) # 8000053e <panic>
      panic("uvmunmap: not a leaf");
    800014fe:	00007517          	auipc	a0,0x7
    80001502:	c9250513          	addi	a0,a0,-878 # 80008190 <digits+0x150>
    80001506:	fffff097          	auipc	ra,0xfffff
    8000150a:	038080e7          	jalr	56(ra) # 8000053e <panic>
    *pte = 0;
    8000150e:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80001512:	995a                	add	s2,s2,s6
    80001514:	fb3972e3          	bgeu	s2,s3,800014b8 <uvmunmap+0x30>
    if ((pte = walk(pagetable, a, 0)) == 0)
    80001518:	4601                	li	a2,0
    8000151a:	85ca                	mv	a1,s2
    8000151c:	8552                	mv	a0,s4
    8000151e:	00000097          	auipc	ra,0x0
    80001522:	cbc080e7          	jalr	-836(ra) # 800011da <walk>
    80001526:	84aa                	mv	s1,a0
    80001528:	d95d                	beqz	a0,800014de <uvmunmap+0x56>
    if ((*pte & PTE_V) == 0)
    8000152a:	6108                	ld	a0,0(a0)
    8000152c:	00157793          	andi	a5,a0,1
    80001530:	dfdd                	beqz	a5,800014ee <uvmunmap+0x66>
    if (PTE_FLAGS(*pte) == PTE_V)
    80001532:	3ff57793          	andi	a5,a0,1023
    80001536:	fd7784e3          	beq	a5,s7,800014fe <uvmunmap+0x76>
    if (do_free)
    8000153a:	fc0a8ae3          	beqz	s5,8000150e <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    8000153e:	8129                	srli	a0,a0,0xa
      kfree((void *)pa);
    80001540:	0532                	slli	a0,a0,0xc
    80001542:	fffff097          	auipc	ra,0xfffff
    80001546:	634080e7          	jalr	1588(ra) # 80000b76 <kfree>
    8000154a:	b7d1                	j	8000150e <uvmunmap+0x86>

000000008000154c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000154c:	1101                	addi	sp,sp,-32
    8000154e:	ec06                	sd	ra,24(sp)
    80001550:	e822                	sd	s0,16(sp)
    80001552:	e426                	sd	s1,8(sp)
    80001554:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    80001556:	fffff097          	auipc	ra,0xfffff
    8000155a:	7a8080e7          	jalr	1960(ra) # 80000cfe <kalloc>
    8000155e:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001560:	c519                	beqz	a0,8000156e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001562:	6605                	lui	a2,0x1
    80001564:	4581                	li	a1,0
    80001566:	00000097          	auipc	ra,0x0
    8000156a:	990080e7          	jalr	-1648(ra) # 80000ef6 <memset>
  return pagetable;
}
    8000156e:	8526                	mv	a0,s1
    80001570:	60e2                	ld	ra,24(sp)
    80001572:	6442                	ld	s0,16(sp)
    80001574:	64a2                	ld	s1,8(sp)
    80001576:	6105                	addi	sp,sp,32
    80001578:	8082                	ret

000000008000157a <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000157a:	7179                	addi	sp,sp,-48
    8000157c:	f406                	sd	ra,40(sp)
    8000157e:	f022                	sd	s0,32(sp)
    80001580:	ec26                	sd	s1,24(sp)
    80001582:	e84a                	sd	s2,16(sp)
    80001584:	e44e                	sd	s3,8(sp)
    80001586:	e052                	sd	s4,0(sp)
    80001588:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE)
    8000158a:	6785                	lui	a5,0x1
    8000158c:	04f67863          	bgeu	a2,a5,800015dc <uvmfirst+0x62>
    80001590:	8a2a                	mv	s4,a0
    80001592:	89ae                	mv	s3,a1
    80001594:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001596:	fffff097          	auipc	ra,0xfffff
    8000159a:	768080e7          	jalr	1896(ra) # 80000cfe <kalloc>
    8000159e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800015a0:	6605                	lui	a2,0x1
    800015a2:	4581                	li	a1,0
    800015a4:	00000097          	auipc	ra,0x0
    800015a8:	952080e7          	jalr	-1710(ra) # 80000ef6 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    800015ac:	4779                	li	a4,30
    800015ae:	86ca                	mv	a3,s2
    800015b0:	6605                	lui	a2,0x1
    800015b2:	4581                	li	a1,0
    800015b4:	8552                	mv	a0,s4
    800015b6:	00000097          	auipc	ra,0x0
    800015ba:	d0c080e7          	jalr	-756(ra) # 800012c2 <mappages>
  memmove(mem, src, sz);
    800015be:	8626                	mv	a2,s1
    800015c0:	85ce                	mv	a1,s3
    800015c2:	854a                	mv	a0,s2
    800015c4:	00000097          	auipc	ra,0x0
    800015c8:	98e080e7          	jalr	-1650(ra) # 80000f52 <memmove>
}
    800015cc:	70a2                	ld	ra,40(sp)
    800015ce:	7402                	ld	s0,32(sp)
    800015d0:	64e2                	ld	s1,24(sp)
    800015d2:	6942                	ld	s2,16(sp)
    800015d4:	69a2                	ld	s3,8(sp)
    800015d6:	6a02                	ld	s4,0(sp)
    800015d8:	6145                	addi	sp,sp,48
    800015da:	8082                	ret
    panic("uvmfirst: more than a page");
    800015dc:	00007517          	auipc	a0,0x7
    800015e0:	bcc50513          	addi	a0,a0,-1076 # 800081a8 <digits+0x168>
    800015e4:	fffff097          	auipc	ra,0xfffff
    800015e8:	f5a080e7          	jalr	-166(ra) # 8000053e <panic>

00000000800015ec <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800015ec:	1101                	addi	sp,sp,-32
    800015ee:	ec06                	sd	ra,24(sp)
    800015f0:	e822                	sd	s0,16(sp)
    800015f2:	e426                	sd	s1,8(sp)
    800015f4:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    800015f6:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    800015f8:	00b67d63          	bgeu	a2,a1,80001612 <uvmdealloc+0x26>
    800015fc:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    800015fe:	6785                	lui	a5,0x1
    80001600:	17fd                	addi	a5,a5,-1
    80001602:	00f60733          	add	a4,a2,a5
    80001606:	767d                	lui	a2,0xfffff
    80001608:	8f71                	and	a4,a4,a2
    8000160a:	97ae                	add	a5,a5,a1
    8000160c:	8ff1                	and	a5,a5,a2
    8000160e:	00f76863          	bltu	a4,a5,8000161e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001612:	8526                	mv	a0,s1
    80001614:	60e2                	ld	ra,24(sp)
    80001616:	6442                	ld	s0,16(sp)
    80001618:	64a2                	ld	s1,8(sp)
    8000161a:	6105                	addi	sp,sp,32
    8000161c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000161e:	8f99                	sub	a5,a5,a4
    80001620:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001622:	4685                	li	a3,1
    80001624:	0007861b          	sext.w	a2,a5
    80001628:	85ba                	mv	a1,a4
    8000162a:	00000097          	auipc	ra,0x0
    8000162e:	e5e080e7          	jalr	-418(ra) # 80001488 <uvmunmap>
    80001632:	b7c5                	j	80001612 <uvmdealloc+0x26>

0000000080001634 <uvmalloc>:
  if (newsz < oldsz)
    80001634:	0ab66563          	bltu	a2,a1,800016de <uvmalloc+0xaa>
{
    80001638:	7139                	addi	sp,sp,-64
    8000163a:	fc06                	sd	ra,56(sp)
    8000163c:	f822                	sd	s0,48(sp)
    8000163e:	f426                	sd	s1,40(sp)
    80001640:	f04a                	sd	s2,32(sp)
    80001642:	ec4e                	sd	s3,24(sp)
    80001644:	e852                	sd	s4,16(sp)
    80001646:	e456                	sd	s5,8(sp)
    80001648:	e05a                	sd	s6,0(sp)
    8000164a:	0080                	addi	s0,sp,64
    8000164c:	8aaa                	mv	s5,a0
    8000164e:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001650:	6985                	lui	s3,0x1
    80001652:	19fd                	addi	s3,s3,-1
    80001654:	95ce                	add	a1,a1,s3
    80001656:	79fd                	lui	s3,0xfffff
    80001658:	0135f9b3          	and	s3,a1,s3
  for (a = oldsz; a < newsz; a += PGSIZE)
    8000165c:	08c9f363          	bgeu	s3,a2,800016e2 <uvmalloc+0xae>
    80001660:	894e                	mv	s2,s3
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0)
    80001662:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001666:	fffff097          	auipc	ra,0xfffff
    8000166a:	698080e7          	jalr	1688(ra) # 80000cfe <kalloc>
    8000166e:	84aa                	mv	s1,a0
    if (mem == 0)
    80001670:	c51d                	beqz	a0,8000169e <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80001672:	6605                	lui	a2,0x1
    80001674:	4581                	li	a1,0
    80001676:	00000097          	auipc	ra,0x0
    8000167a:	880080e7          	jalr	-1920(ra) # 80000ef6 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0)
    8000167e:	875a                	mv	a4,s6
    80001680:	86a6                	mv	a3,s1
    80001682:	6605                	lui	a2,0x1
    80001684:	85ca                	mv	a1,s2
    80001686:	8556                	mv	a0,s5
    80001688:	00000097          	auipc	ra,0x0
    8000168c:	c3a080e7          	jalr	-966(ra) # 800012c2 <mappages>
    80001690:	e90d                	bnez	a0,800016c2 <uvmalloc+0x8e>
  for (a = oldsz; a < newsz; a += PGSIZE)
    80001692:	6785                	lui	a5,0x1
    80001694:	993e                	add	s2,s2,a5
    80001696:	fd4968e3          	bltu	s2,s4,80001666 <uvmalloc+0x32>
  return newsz;
    8000169a:	8552                	mv	a0,s4
    8000169c:	a809                	j	800016ae <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000169e:	864e                	mv	a2,s3
    800016a0:	85ca                	mv	a1,s2
    800016a2:	8556                	mv	a0,s5
    800016a4:	00000097          	auipc	ra,0x0
    800016a8:	f48080e7          	jalr	-184(ra) # 800015ec <uvmdealloc>
      return 0;
    800016ac:	4501                	li	a0,0
}
    800016ae:	70e2                	ld	ra,56(sp)
    800016b0:	7442                	ld	s0,48(sp)
    800016b2:	74a2                	ld	s1,40(sp)
    800016b4:	7902                	ld	s2,32(sp)
    800016b6:	69e2                	ld	s3,24(sp)
    800016b8:	6a42                	ld	s4,16(sp)
    800016ba:	6aa2                	ld	s5,8(sp)
    800016bc:	6b02                	ld	s6,0(sp)
    800016be:	6121                	addi	sp,sp,64
    800016c0:	8082                	ret
      kfree(mem);
    800016c2:	8526                	mv	a0,s1
    800016c4:	fffff097          	auipc	ra,0xfffff
    800016c8:	4b2080e7          	jalr	1202(ra) # 80000b76 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800016cc:	864e                	mv	a2,s3
    800016ce:	85ca                	mv	a1,s2
    800016d0:	8556                	mv	a0,s5
    800016d2:	00000097          	auipc	ra,0x0
    800016d6:	f1a080e7          	jalr	-230(ra) # 800015ec <uvmdealloc>
      return 0;
    800016da:	4501                	li	a0,0
    800016dc:	bfc9                	j	800016ae <uvmalloc+0x7a>
    return oldsz;
    800016de:	852e                	mv	a0,a1
}
    800016e0:	8082                	ret
  return newsz;
    800016e2:	8532                	mv	a0,a2
    800016e4:	b7e9                	j	800016ae <uvmalloc+0x7a>

00000000800016e6 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    800016e6:	7179                	addi	sp,sp,-48
    800016e8:	f406                	sd	ra,40(sp)
    800016ea:	f022                	sd	s0,32(sp)
    800016ec:	ec26                	sd	s1,24(sp)
    800016ee:	e84a                	sd	s2,16(sp)
    800016f0:	e44e                	sd	s3,8(sp)
    800016f2:	e052                	sd	s4,0(sp)
    800016f4:	1800                	addi	s0,sp,48
    800016f6:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++)
    800016f8:	84aa                	mv	s1,a0
    800016fa:	6905                	lui	s2,0x1
    800016fc:	992a                	add	s2,s2,a0
  {
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    800016fe:	4985                	li	s3,1
    80001700:	a821                	j	80001718 <freewalk+0x32>
    {
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001702:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80001704:	0532                	slli	a0,a0,0xc
    80001706:	00000097          	auipc	ra,0x0
    8000170a:	fe0080e7          	jalr	-32(ra) # 800016e6 <freewalk>
      pagetable[i] = 0;
    8000170e:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++)
    80001712:	04a1                	addi	s1,s1,8
    80001714:	03248163          	beq	s1,s2,80001736 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80001718:	6088                	ld	a0,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    8000171a:	00f57793          	andi	a5,a0,15
    8000171e:	ff3782e3          	beq	a5,s3,80001702 <freewalk+0x1c>
    }
    else if (pte & PTE_V)
    80001722:	8905                	andi	a0,a0,1
    80001724:	d57d                	beqz	a0,80001712 <freewalk+0x2c>
    {
      panic("freewalk: leaf");
    80001726:	00007517          	auipc	a0,0x7
    8000172a:	aa250513          	addi	a0,a0,-1374 # 800081c8 <digits+0x188>
    8000172e:	fffff097          	auipc	ra,0xfffff
    80001732:	e10080e7          	jalr	-496(ra) # 8000053e <panic>
    }
  }
  kfree((void *)pagetable);
    80001736:	8552                	mv	a0,s4
    80001738:	fffff097          	auipc	ra,0xfffff
    8000173c:	43e080e7          	jalr	1086(ra) # 80000b76 <kfree>
}
    80001740:	70a2                	ld	ra,40(sp)
    80001742:	7402                	ld	s0,32(sp)
    80001744:	64e2                	ld	s1,24(sp)
    80001746:	6942                	ld	s2,16(sp)
    80001748:	69a2                	ld	s3,8(sp)
    8000174a:	6a02                	ld	s4,0(sp)
    8000174c:	6145                	addi	sp,sp,48
    8000174e:	8082                	ret

0000000080001750 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001750:	1101                	addi	sp,sp,-32
    80001752:	ec06                	sd	ra,24(sp)
    80001754:	e822                	sd	s0,16(sp)
    80001756:	e426                	sd	s1,8(sp)
    80001758:	1000                	addi	s0,sp,32
    8000175a:	84aa                	mv	s1,a0
  if (sz > 0)
    8000175c:	e999                	bnez	a1,80001772 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    8000175e:	8526                	mv	a0,s1
    80001760:	00000097          	auipc	ra,0x0
    80001764:	f86080e7          	jalr	-122(ra) # 800016e6 <freewalk>
}
    80001768:	60e2                	ld	ra,24(sp)
    8000176a:	6442                	ld	s0,16(sp)
    8000176c:	64a2                	ld	s1,8(sp)
    8000176e:	6105                	addi	sp,sp,32
    80001770:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80001772:	6605                	lui	a2,0x1
    80001774:	167d                	addi	a2,a2,-1
    80001776:	962e                	add	a2,a2,a1
    80001778:	4685                	li	a3,1
    8000177a:	8231                	srli	a2,a2,0xc
    8000177c:	4581                	li	a1,0
    8000177e:	00000097          	auipc	ra,0x0
    80001782:	d0a080e7          	jalr	-758(ra) # 80001488 <uvmunmap>
    80001786:	bfe1                	j	8000175e <uvmfree+0xe>

0000000080001788 <uvmcopy>:
// Copies both the page table and the
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80001788:	715d                	addi	sp,sp,-80
    8000178a:	e486                	sd	ra,72(sp)
    8000178c:	e0a2                	sd	s0,64(sp)
    8000178e:	fc26                	sd	s1,56(sp)
    80001790:	f84a                	sd	s2,48(sp)
    80001792:	f44e                	sd	s3,40(sp)
    80001794:	f052                	sd	s4,32(sp)
    80001796:	ec56                	sd	s5,24(sp)
    80001798:	e85a                	sd	s6,16(sp)
    8000179a:	e45e                	sd	s7,8(sp)
    8000179c:	0880                	addi	s0,sp,80
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  // char *mem;
  for (i = 0; i < sz; i += PGSIZE)
    8000179e:	ce5d                	beqz	a2,8000185c <uvmcopy+0xd4>
    800017a0:	8aaa                	mv	s5,a0
    800017a2:	8a2e                	mv	s4,a1
    800017a4:	89b2                	mv	s3,a2
    800017a6:	4481                	li	s1,0
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if (flags & PTE_W)
    {
      flags = PTE_C | (flags & (~PTE_W));
      *pte = PA2PTE(pa) | flags;
    800017a8:	7b7d                	lui	s6,0xfffff
    800017aa:	002b5b13          	srli	s6,s6,0x2
    800017ae:	a0a1                	j	800017f6 <uvmcopy+0x6e>
      panic("uvmcopy: pte should exist");
    800017b0:	00007517          	auipc	a0,0x7
    800017b4:	a2850513          	addi	a0,a0,-1496 # 800081d8 <digits+0x198>
    800017b8:	fffff097          	auipc	ra,0xfffff
    800017bc:	d86080e7          	jalr	-634(ra) # 8000053e <panic>
      panic("uvmcopy: page not present");
    800017c0:	00007517          	auipc	a0,0x7
    800017c4:	a3850513          	addi	a0,a0,-1480 # 800081f8 <digits+0x1b8>
    800017c8:	fffff097          	auipc	ra,0xfffff
    800017cc:	d76080e7          	jalr	-650(ra) # 8000053e <panic>
    // if((mem = kalloc()) == 0)
    // goto err;
    // so also dont copy these pages
    // memmove(mem, (char*)pa, PGSIZE);
    // map new PTE to old pages only
    if (mappages(new, i, PGSIZE, pa, flags) != 0)
    800017d0:	86ca                	mv	a3,s2
    800017d2:	6605                	lui	a2,0x1
    800017d4:	85a6                	mv	a1,s1
    800017d6:	8552                	mv	a0,s4
    800017d8:	00000097          	auipc	ra,0x0
    800017dc:	aea080e7          	jalr	-1302(ra) # 800012c2 <mappages>
    800017e0:	8baa                	mv	s7,a0
    800017e2:	e539                	bnez	a0,80001830 <uvmcopy+0xa8>
    {
      // kfree(mem);
      goto err;
    }
    // increase conut of no of people acessing this page
    increment_page_usage((void *)pa);
    800017e4:	854a                	mv	a0,s2
    800017e6:	fffff097          	auipc	ra,0xfffff
    800017ea:	2bc080e7          	jalr	700(ra) # 80000aa2 <increment_page_usage>
  for (i = 0; i < sz; i += PGSIZE)
    800017ee:	6785                	lui	a5,0x1
    800017f0:	94be                	add	s1,s1,a5
    800017f2:	0534f963          	bgeu	s1,s3,80001844 <uvmcopy+0xbc>
    if ((pte = walk(old, i, 0)) == 0)
    800017f6:	4601                	li	a2,0
    800017f8:	85a6                	mv	a1,s1
    800017fa:	8556                	mv	a0,s5
    800017fc:	00000097          	auipc	ra,0x0
    80001800:	9de080e7          	jalr	-1570(ra) # 800011da <walk>
    80001804:	d555                	beqz	a0,800017b0 <uvmcopy+0x28>
    if ((*pte & PTE_V) == 0)
    80001806:	611c                	ld	a5,0(a0)
    80001808:	0017f713          	andi	a4,a5,1
    8000180c:	db55                	beqz	a4,800017c0 <uvmcopy+0x38>
    pa = PTE2PA(*pte);
    8000180e:	00a7d913          	srli	s2,a5,0xa
    80001812:	0932                	slli	s2,s2,0xc
    flags = PTE_FLAGS(*pte);
    80001814:	3ff7f713          	andi	a4,a5,1023
    if (flags & PTE_W)
    80001818:	0047f693          	andi	a3,a5,4
    8000181c:	dad5                	beqz	a3,800017d0 <uvmcopy+0x48>
      flags = PTE_C | (flags & (~PTE_W));
    8000181e:	efb77693          	andi	a3,a4,-261
    80001822:	1006e713          	ori	a4,a3,256
      *pte = PA2PTE(pa) | flags;
    80001826:	0167f7b3          	and	a5,a5,s6
    8000182a:	8fd9                	or	a5,a5,a4
    8000182c:	e11c                	sd	a5,0(a0)
    8000182e:	b74d                	j	800017d0 <uvmcopy+0x48>
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001830:	4685                	li	a3,1
    80001832:	00c4d613          	srli	a2,s1,0xc
    80001836:	4581                	li	a1,0
    80001838:	8552                	mv	a0,s4
    8000183a:	00000097          	auipc	ra,0x0
    8000183e:	c4e080e7          	jalr	-946(ra) # 80001488 <uvmunmap>
  return -1;
    80001842:	5bfd                	li	s7,-1
}
    80001844:	855e                	mv	a0,s7
    80001846:	60a6                	ld	ra,72(sp)
    80001848:	6406                	ld	s0,64(sp)
    8000184a:	74e2                	ld	s1,56(sp)
    8000184c:	7942                	ld	s2,48(sp)
    8000184e:	79a2                	ld	s3,40(sp)
    80001850:	7a02                	ld	s4,32(sp)
    80001852:	6ae2                	ld	s5,24(sp)
    80001854:	6b42                	ld	s6,16(sp)
    80001856:	6ba2                	ld	s7,8(sp)
    80001858:	6161                	addi	sp,sp,80
    8000185a:	8082                	ret
  return 0;
    8000185c:	4b81                	li	s7,0
    8000185e:	b7dd                	j	80001844 <uvmcopy+0xbc>

0000000080001860 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
    80001860:	1141                	addi	sp,sp,-16
    80001862:	e406                	sd	ra,8(sp)
    80001864:	e022                	sd	s0,0(sp)
    80001866:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80001868:	4601                	li	a2,0
    8000186a:	00000097          	auipc	ra,0x0
    8000186e:	970080e7          	jalr	-1680(ra) # 800011da <walk>
  if (pte == 0)
    80001872:	c901                	beqz	a0,80001882 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001874:	611c                	ld	a5,0(a0)
    80001876:	9bbd                	andi	a5,a5,-17
    80001878:	e11c                	sd	a5,0(a0)
}
    8000187a:	60a2                	ld	ra,8(sp)
    8000187c:	6402                	ld	s0,0(sp)
    8000187e:	0141                	addi	sp,sp,16
    80001880:	8082                	ret
    panic("uvmclear");
    80001882:	00007517          	auipc	a0,0x7
    80001886:	99650513          	addi	a0,a0,-1642 # 80008218 <digits+0x1d8>
    8000188a:	fffff097          	auipc	ra,0xfffff
    8000188e:	cb4080e7          	jalr	-844(ra) # 8000053e <panic>

0000000080001892 <copyout>:

int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while (len > 0)
    80001892:	c2d5                	beqz	a3,80001936 <copyout+0xa4>
{
    80001894:	711d                	addi	sp,sp,-96
    80001896:	ec86                	sd	ra,88(sp)
    80001898:	e8a2                	sd	s0,80(sp)
    8000189a:	e4a6                	sd	s1,72(sp)
    8000189c:	e0ca                	sd	s2,64(sp)
    8000189e:	fc4e                	sd	s3,56(sp)
    800018a0:	f852                	sd	s4,48(sp)
    800018a2:	f456                	sd	s5,40(sp)
    800018a4:	f05a                	sd	s6,32(sp)
    800018a6:	ec5e                	sd	s7,24(sp)
    800018a8:	e862                	sd	s8,16(sp)
    800018aa:	e466                	sd	s9,8(sp)
    800018ac:	1080                	addi	s0,sp,96
    800018ae:	8baa                	mv	s7,a0
    800018b0:	89ae                	mv	s3,a1
    800018b2:	8b32                	mv	s6,a2
    800018b4:	8ab6                	mv	s5,a3
  {
    va0 = PGROUNDDOWN(dstva);
    800018b6:	7cfd                	lui	s9,0xfffff
    {
      handle_page(va0, pagetable);
      pa0 = walkaddr(pagetable, va0);
    }
    //*cow
    n = PGSIZE + va0 - dstva;
    800018b8:	6c05                	lui	s8,0x1
    800018ba:	a081                	j	800018fa <copyout+0x68>
      handle_page(va0, pagetable);
    800018bc:	85de                	mv	a1,s7
    800018be:	854a                	mv	a0,s2
    800018c0:	00001097          	auipc	ra,0x1
    800018c4:	436080e7          	jalr	1078(ra) # 80002cf6 <handle_page>
      pa0 = walkaddr(pagetable, va0);
    800018c8:	85ca                	mv	a1,s2
    800018ca:	855e                	mv	a0,s7
    800018cc:	00000097          	auipc	ra,0x0
    800018d0:	9b4080e7          	jalr	-1612(ra) # 80001280 <walkaddr>
    800018d4:	8a2a                	mv	s4,a0
    800018d6:	a0b9                	j	80001924 <copyout+0x92>
    if (n >= len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800018d8:	41298533          	sub	a0,s3,s2
    800018dc:	0004861b          	sext.w	a2,s1
    800018e0:	85da                	mv	a1,s6
    800018e2:	9552                	add	a0,a0,s4
    800018e4:	fffff097          	auipc	ra,0xfffff
    800018e8:	66e080e7          	jalr	1646(ra) # 80000f52 <memmove>

    src += n;
    800018ec:	9b26                	add	s6,s6,s1
    len -= n;
    800018ee:	409a8ab3          	sub	s5,s5,s1
    dstva = va0 + PGSIZE;
    800018f2:	018909b3          	add	s3,s2,s8
  while (len > 0)
    800018f6:	020a8e63          	beqz	s5,80001932 <copyout+0xa0>
    va0 = PGROUNDDOWN(dstva);
    800018fa:	0199f933          	and	s2,s3,s9
    pa0 = walkaddr(pagetable, va0);
    800018fe:	85ca                	mv	a1,s2
    80001900:	855e                	mv	a0,s7
    80001902:	00000097          	auipc	ra,0x0
    80001906:	97e080e7          	jalr	-1666(ra) # 80001280 <walkaddr>
    8000190a:	8a2a                	mv	s4,a0
    if (pa0 == 0)
    8000190c:	c51d                	beqz	a0,8000193a <copyout+0xa8>
    pte = walk(pagetable, va0, 0);
    8000190e:	4601                	li	a2,0
    80001910:	85ca                	mv	a1,s2
    80001912:	855e                	mv	a0,s7
    80001914:	00000097          	auipc	ra,0x0
    80001918:	8c6080e7          	jalr	-1850(ra) # 800011da <walk>
    if (flg & PTE_C)
    8000191c:	611c                	ld	a5,0(a0)
    8000191e:	1007f793          	andi	a5,a5,256
    80001922:	ffc9                	bnez	a5,800018bc <copyout+0x2a>
    n = PGSIZE + va0 - dstva;
    80001924:	413904b3          	sub	s1,s2,s3
    80001928:	94e2                	add	s1,s1,s8
    if (n >= len)
    8000192a:	fa9af7e3          	bgeu	s5,s1,800018d8 <copyout+0x46>
    8000192e:	84d6                	mv	s1,s5
    80001930:	b765                	j	800018d8 <copyout+0x46>
  }
  return 0;
    80001932:	4501                	li	a0,0
    80001934:	a021                	j	8000193c <copyout+0xaa>
    80001936:	4501                	li	a0,0
}
    80001938:	8082                	ret
      return -1;
    8000193a:	557d                	li	a0,-1
}
    8000193c:	60e6                	ld	ra,88(sp)
    8000193e:	6446                	ld	s0,80(sp)
    80001940:	64a6                	ld	s1,72(sp)
    80001942:	6906                	ld	s2,64(sp)
    80001944:	79e2                	ld	s3,56(sp)
    80001946:	7a42                	ld	s4,48(sp)
    80001948:	7aa2                	ld	s5,40(sp)
    8000194a:	7b02                	ld	s6,32(sp)
    8000194c:	6be2                	ld	s7,24(sp)
    8000194e:	6c42                	ld	s8,16(sp)
    80001950:	6ca2                	ld	s9,8(sp)
    80001952:	6125                	addi	sp,sp,96
    80001954:	8082                	ret

0000000080001956 <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while (len > 0)
    80001956:	caa5                	beqz	a3,800019c6 <copyin+0x70>
{
    80001958:	715d                	addi	sp,sp,-80
    8000195a:	e486                	sd	ra,72(sp)
    8000195c:	e0a2                	sd	s0,64(sp)
    8000195e:	fc26                	sd	s1,56(sp)
    80001960:	f84a                	sd	s2,48(sp)
    80001962:	f44e                	sd	s3,40(sp)
    80001964:	f052                	sd	s4,32(sp)
    80001966:	ec56                	sd	s5,24(sp)
    80001968:	e85a                	sd	s6,16(sp)
    8000196a:	e45e                	sd	s7,8(sp)
    8000196c:	e062                	sd	s8,0(sp)
    8000196e:	0880                	addi	s0,sp,80
    80001970:	8b2a                	mv	s6,a0
    80001972:	8a2e                	mv	s4,a1
    80001974:	8c32                	mv	s8,a2
    80001976:	89b6                	mv	s3,a3
  {
    va0 = PGROUNDDOWN(srcva);
    80001978:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000197a:	6a85                	lui	s5,0x1
    8000197c:	a01d                	j	800019a2 <copyin+0x4c>
    if (n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000197e:	018505b3          	add	a1,a0,s8
    80001982:	0004861b          	sext.w	a2,s1
    80001986:	412585b3          	sub	a1,a1,s2
    8000198a:	8552                	mv	a0,s4
    8000198c:	fffff097          	auipc	ra,0xfffff
    80001990:	5c6080e7          	jalr	1478(ra) # 80000f52 <memmove>

    len -= n;
    80001994:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001998:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000199a:	01590c33          	add	s8,s2,s5
  while (len > 0)
    8000199e:	02098263          	beqz	s3,800019c2 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800019a2:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800019a6:	85ca                	mv	a1,s2
    800019a8:	855a                	mv	a0,s6
    800019aa:	00000097          	auipc	ra,0x0
    800019ae:	8d6080e7          	jalr	-1834(ra) # 80001280 <walkaddr>
    if (pa0 == 0)
    800019b2:	cd01                	beqz	a0,800019ca <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800019b4:	418904b3          	sub	s1,s2,s8
    800019b8:	94d6                	add	s1,s1,s5
    if (n > len)
    800019ba:	fc99f2e3          	bgeu	s3,s1,8000197e <copyin+0x28>
    800019be:	84ce                	mv	s1,s3
    800019c0:	bf7d                	j	8000197e <copyin+0x28>
  }
  return 0;
    800019c2:	4501                	li	a0,0
    800019c4:	a021                	j	800019cc <copyin+0x76>
    800019c6:	4501                	li	a0,0
}
    800019c8:	8082                	ret
      return -1;
    800019ca:	557d                	li	a0,-1
}
    800019cc:	60a6                	ld	ra,72(sp)
    800019ce:	6406                	ld	s0,64(sp)
    800019d0:	74e2                	ld	s1,56(sp)
    800019d2:	7942                	ld	s2,48(sp)
    800019d4:	79a2                	ld	s3,40(sp)
    800019d6:	7a02                	ld	s4,32(sp)
    800019d8:	6ae2                	ld	s5,24(sp)
    800019da:	6b42                	ld	s6,16(sp)
    800019dc:	6ba2                	ld	s7,8(sp)
    800019de:	6c02                	ld	s8,0(sp)
    800019e0:	6161                	addi	sp,sp,80
    800019e2:	8082                	ret

00000000800019e4 <copyinstr>:
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0)
    800019e4:	c6c5                	beqz	a3,80001a8c <copyinstr+0xa8>
{
    800019e6:	715d                	addi	sp,sp,-80
    800019e8:	e486                	sd	ra,72(sp)
    800019ea:	e0a2                	sd	s0,64(sp)
    800019ec:	fc26                	sd	s1,56(sp)
    800019ee:	f84a                	sd	s2,48(sp)
    800019f0:	f44e                	sd	s3,40(sp)
    800019f2:	f052                	sd	s4,32(sp)
    800019f4:	ec56                	sd	s5,24(sp)
    800019f6:	e85a                	sd	s6,16(sp)
    800019f8:	e45e                	sd	s7,8(sp)
    800019fa:	0880                	addi	s0,sp,80
    800019fc:	8a2a                	mv	s4,a0
    800019fe:	8b2e                	mv	s6,a1
    80001a00:	8bb2                	mv	s7,a2
    80001a02:	84b6                	mv	s1,a3
  {
    va0 = PGROUNDDOWN(srcva);
    80001a04:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001a06:	6985                	lui	s3,0x1
    80001a08:	a035                	j	80001a34 <copyinstr+0x50>
    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0)
    {
      if (*p == '\0')
      {
        *dst = '\0';
    80001a0a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001a0e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null)
    80001a10:	0017b793          	seqz	a5,a5
    80001a14:	40f00533          	neg	a0,a5
  }
  else
  {
    return -1;
  }
}
    80001a18:	60a6                	ld	ra,72(sp)
    80001a1a:	6406                	ld	s0,64(sp)
    80001a1c:	74e2                	ld	s1,56(sp)
    80001a1e:	7942                	ld	s2,48(sp)
    80001a20:	79a2                	ld	s3,40(sp)
    80001a22:	7a02                	ld	s4,32(sp)
    80001a24:	6ae2                	ld	s5,24(sp)
    80001a26:	6b42                	ld	s6,16(sp)
    80001a28:	6ba2                	ld	s7,8(sp)
    80001a2a:	6161                	addi	sp,sp,80
    80001a2c:	8082                	ret
    srcva = va0 + PGSIZE;
    80001a2e:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0)
    80001a32:	c8a9                	beqz	s1,80001a84 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80001a34:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001a38:	85ca                	mv	a1,s2
    80001a3a:	8552                	mv	a0,s4
    80001a3c:	00000097          	auipc	ra,0x0
    80001a40:	844080e7          	jalr	-1980(ra) # 80001280 <walkaddr>
    if (pa0 == 0)
    80001a44:	c131                	beqz	a0,80001a88 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80001a46:	41790833          	sub	a6,s2,s7
    80001a4a:	984e                	add	a6,a6,s3
    if (n > max)
    80001a4c:	0104f363          	bgeu	s1,a6,80001a52 <copyinstr+0x6e>
    80001a50:	8826                	mv	a6,s1
    char *p = (char *)(pa0 + (srcva - va0));
    80001a52:	955e                	add	a0,a0,s7
    80001a54:	41250533          	sub	a0,a0,s2
    while (n > 0)
    80001a58:	fc080be3          	beqz	a6,80001a2e <copyinstr+0x4a>
    80001a5c:	985a                	add	a6,a6,s6
    80001a5e:	87da                	mv	a5,s6
      if (*p == '\0')
    80001a60:	41650633          	sub	a2,a0,s6
    80001a64:	14fd                	addi	s1,s1,-1
    80001a66:	9b26                	add	s6,s6,s1
    80001a68:	00f60733          	add	a4,a2,a5
    80001a6c:	00074703          	lbu	a4,0(a4)
    80001a70:	df49                	beqz	a4,80001a0a <copyinstr+0x26>
        *dst = *p;
    80001a72:	00e78023          	sb	a4,0(a5)
      --max;
    80001a76:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80001a7a:	0785                	addi	a5,a5,1
    while (n > 0)
    80001a7c:	ff0796e3          	bne	a5,a6,80001a68 <copyinstr+0x84>
      dst++;
    80001a80:	8b42                	mv	s6,a6
    80001a82:	b775                	j	80001a2e <copyinstr+0x4a>
    80001a84:	4781                	li	a5,0
    80001a86:	b769                	j	80001a10 <copyinstr+0x2c>
      return -1;
    80001a88:	557d                	li	a0,-1
    80001a8a:	b779                	j	80001a18 <copyinstr+0x34>
  int got_null = 0;
    80001a8c:	4781                	li	a5,0
  if (got_null)
    80001a8e:	0017b793          	seqz	a5,a5
    80001a92:	40f00533          	neg	a0,a5
}
    80001a96:	8082                	ret

0000000080001a98 <proc_mapstacks>:
  }
  return oldPriorty;
}

void proc_mapstacks(pagetable_t kpgtbl)
{
    80001a98:	7139                	addi	sp,sp,-64
    80001a9a:	fc06                	sd	ra,56(sp)
    80001a9c:	f822                	sd	s0,48(sp)
    80001a9e:	f426                	sd	s1,40(sp)
    80001aa0:	f04a                	sd	s2,32(sp)
    80001aa2:	ec4e                	sd	s3,24(sp)
    80001aa4:	e852                	sd	s4,16(sp)
    80001aa6:	e456                	sd	s5,8(sp)
    80001aa8:	e05a                	sd	s6,0(sp)
    80001aaa:	0080                	addi	s0,sp,64
    80001aac:	89aa                	mv	s3,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80001aae:	0022f497          	auipc	s1,0x22f
    80001ab2:	53a48493          	addi	s1,s1,1338 # 80230fe8 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80001ab6:	8b26                	mv	s6,s1
    80001ab8:	00006a97          	auipc	s5,0x6
    80001abc:	548a8a93          	addi	s5,s5,1352 # 80008000 <etext>
    80001ac0:	04000937          	lui	s2,0x4000
    80001ac4:	197d                	addi	s2,s2,-1
    80001ac6:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001ac8:	00236a17          	auipc	s4,0x236
    80001acc:	920a0a13          	addi	s4,s4,-1760 # 802373e8 <tickslock>
    char *pa = kalloc();
    80001ad0:	fffff097          	auipc	ra,0xfffff
    80001ad4:	22e080e7          	jalr	558(ra) # 80000cfe <kalloc>
    80001ad8:	862a                	mv	a2,a0
    if (pa == 0)
    80001ada:	c131                	beqz	a0,80001b1e <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    80001adc:	416485b3          	sub	a1,s1,s6
    80001ae0:	8591                	srai	a1,a1,0x4
    80001ae2:	000ab783          	ld	a5,0(s5)
    80001ae6:	02f585b3          	mul	a1,a1,a5
    80001aea:	2585                	addiw	a1,a1,1
    80001aec:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001af0:	4719                	li	a4,6
    80001af2:	6685                	lui	a3,0x1
    80001af4:	40b905b3          	sub	a1,s2,a1
    80001af8:	854e                	mv	a0,s3
    80001afa:	00000097          	auipc	ra,0x0
    80001afe:	868080e7          	jalr	-1944(ra) # 80001362 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    80001b02:	19048493          	addi	s1,s1,400
    80001b06:	fd4495e3          	bne	s1,s4,80001ad0 <proc_mapstacks+0x38>
  }
}
    80001b0a:	70e2                	ld	ra,56(sp)
    80001b0c:	7442                	ld	s0,48(sp)
    80001b0e:	74a2                	ld	s1,40(sp)
    80001b10:	7902                	ld	s2,32(sp)
    80001b12:	69e2                	ld	s3,24(sp)
    80001b14:	6a42                	ld	s4,16(sp)
    80001b16:	6aa2                	ld	s5,8(sp)
    80001b18:	6b02                	ld	s6,0(sp)
    80001b1a:	6121                	addi	sp,sp,64
    80001b1c:	8082                	ret
      panic("kalloc");
    80001b1e:	00006517          	auipc	a0,0x6
    80001b22:	70a50513          	addi	a0,a0,1802 # 80008228 <digits+0x1e8>
    80001b26:	fffff097          	auipc	ra,0xfffff
    80001b2a:	a18080e7          	jalr	-1512(ra) # 8000053e <panic>

0000000080001b2e <procinit>:

// initialize the proc table.
void procinit(void)
{
    80001b2e:	7139                	addi	sp,sp,-64
    80001b30:	fc06                	sd	ra,56(sp)
    80001b32:	f822                	sd	s0,48(sp)
    80001b34:	f426                	sd	s1,40(sp)
    80001b36:	f04a                	sd	s2,32(sp)
    80001b38:	ec4e                	sd	s3,24(sp)
    80001b3a:	e852                	sd	s4,16(sp)
    80001b3c:	e456                	sd	s5,8(sp)
    80001b3e:	e05a                	sd	s6,0(sp)
    80001b40:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001b42:	00006597          	auipc	a1,0x6
    80001b46:	6ee58593          	addi	a1,a1,1774 # 80008230 <digits+0x1f0>
    80001b4a:	0022f517          	auipc	a0,0x22f
    80001b4e:	06e50513          	addi	a0,a0,110 # 80230bb8 <pid_lock>
    80001b52:	fffff097          	auipc	ra,0xfffff
    80001b56:	218080e7          	jalr	536(ra) # 80000d6a <initlock>
  initlock(&wait_lock, "wait_lock");
    80001b5a:	00006597          	auipc	a1,0x6
    80001b5e:	6de58593          	addi	a1,a1,1758 # 80008238 <digits+0x1f8>
    80001b62:	0022f517          	auipc	a0,0x22f
    80001b66:	06e50513          	addi	a0,a0,110 # 80230bd0 <wait_lock>
    80001b6a:	fffff097          	auipc	ra,0xfffff
    80001b6e:	200080e7          	jalr	512(ra) # 80000d6a <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80001b72:	0022f497          	auipc	s1,0x22f
    80001b76:	47648493          	addi	s1,s1,1142 # 80230fe8 <proc>
  {
    initlock(&p->lock, "proc");
    80001b7a:	00006b17          	auipc	s6,0x6
    80001b7e:	6ceb0b13          	addi	s6,s6,1742 # 80008248 <digits+0x208>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001b82:	8aa6                	mv	s5,s1
    80001b84:	00006a17          	auipc	s4,0x6
    80001b88:	47ca0a13          	addi	s4,s4,1148 # 80008000 <etext>
    80001b8c:	04000937          	lui	s2,0x4000
    80001b90:	197d                	addi	s2,s2,-1
    80001b92:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001b94:	00236997          	auipc	s3,0x236
    80001b98:	85498993          	addi	s3,s3,-1964 # 802373e8 <tickslock>
    initlock(&p->lock, "proc");
    80001b9c:	85da                	mv	a1,s6
    80001b9e:	8526                	mv	a0,s1
    80001ba0:	fffff097          	auipc	ra,0xfffff
    80001ba4:	1ca080e7          	jalr	458(ra) # 80000d6a <initlock>
    p->state = UNUSED;
    80001ba8:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001bac:	415487b3          	sub	a5,s1,s5
    80001bb0:	8791                	srai	a5,a5,0x4
    80001bb2:	000a3703          	ld	a4,0(s4)
    80001bb6:	02e787b3          	mul	a5,a5,a4
    80001bba:	2785                	addiw	a5,a5,1
    80001bbc:	00d7979b          	slliw	a5,a5,0xd
    80001bc0:	40f907b3          	sub	a5,s2,a5
    80001bc4:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80001bc6:	19048493          	addi	s1,s1,400
    80001bca:	fd3499e3          	bne	s1,s3,80001b9c <procinit+0x6e>
  }
}
    80001bce:	70e2                	ld	ra,56(sp)
    80001bd0:	7442                	ld	s0,48(sp)
    80001bd2:	74a2                	ld	s1,40(sp)
    80001bd4:	7902                	ld	s2,32(sp)
    80001bd6:	69e2                	ld	s3,24(sp)
    80001bd8:	6a42                	ld	s4,16(sp)
    80001bda:	6aa2                	ld	s5,8(sp)
    80001bdc:	6b02                	ld	s6,0(sp)
    80001bde:	6121                	addi	sp,sp,64
    80001be0:	8082                	ret

0000000080001be2 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80001be2:	1141                	addi	sp,sp,-16
    80001be4:	e422                	sd	s0,8(sp)
    80001be6:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001be8:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001bea:	2501                	sext.w	a0,a0
    80001bec:	6422                	ld	s0,8(sp)
    80001bee:	0141                	addi	sp,sp,16
    80001bf0:	8082                	ret

0000000080001bf2 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80001bf2:	1141                	addi	sp,sp,-16
    80001bf4:	e422                	sd	s0,8(sp)
    80001bf6:	0800                	addi	s0,sp,16
    80001bf8:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001bfa:	2781                	sext.w	a5,a5
    80001bfc:	079e                	slli	a5,a5,0x7
  return c;
}
    80001bfe:	0022f517          	auipc	a0,0x22f
    80001c02:	fea50513          	addi	a0,a0,-22 # 80230be8 <cpus>
    80001c06:	953e                	add	a0,a0,a5
    80001c08:	6422                	ld	s0,8(sp)
    80001c0a:	0141                	addi	sp,sp,16
    80001c0c:	8082                	ret

0000000080001c0e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80001c0e:	1101                	addi	sp,sp,-32
    80001c10:	ec06                	sd	ra,24(sp)
    80001c12:	e822                	sd	s0,16(sp)
    80001c14:	e426                	sd	s1,8(sp)
    80001c16:	1000                	addi	s0,sp,32
  push_off();
    80001c18:	fffff097          	auipc	ra,0xfffff
    80001c1c:	196080e7          	jalr	406(ra) # 80000dae <push_off>
    80001c20:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001c22:	2781                	sext.w	a5,a5
    80001c24:	079e                	slli	a5,a5,0x7
    80001c26:	0022f717          	auipc	a4,0x22f
    80001c2a:	f9270713          	addi	a4,a4,-110 # 80230bb8 <pid_lock>
    80001c2e:	97ba                	add	a5,a5,a4
    80001c30:	7b84                	ld	s1,48(a5)
  pop_off();
    80001c32:	fffff097          	auipc	ra,0xfffff
    80001c36:	21c080e7          	jalr	540(ra) # 80000e4e <pop_off>
  return p;
}
    80001c3a:	8526                	mv	a0,s1
    80001c3c:	60e2                	ld	ra,24(sp)
    80001c3e:	6442                	ld	s0,16(sp)
    80001c40:	64a2                	ld	s1,8(sp)
    80001c42:	6105                	addi	sp,sp,32
    80001c44:	8082                	ret

0000000080001c46 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001c46:	1141                	addi	sp,sp,-16
    80001c48:	e406                	sd	ra,8(sp)
    80001c4a:	e022                	sd	s0,0(sp)
    80001c4c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001c4e:	00000097          	auipc	ra,0x0
    80001c52:	fc0080e7          	jalr	-64(ra) # 80001c0e <myproc>
    80001c56:	fffff097          	auipc	ra,0xfffff
    80001c5a:	258080e7          	jalr	600(ra) # 80000eae <release>

  if (first)
    80001c5e:	00007797          	auipc	a5,0x7
    80001c62:	c527a783          	lw	a5,-942(a5) # 800088b0 <first.1>
    80001c66:	eb89                	bnez	a5,80001c78 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001c68:	00001097          	auipc	ra,0x1
    80001c6c:	174080e7          	jalr	372(ra) # 80002ddc <usertrapret>
}
    80001c70:	60a2                	ld	ra,8(sp)
    80001c72:	6402                	ld	s0,0(sp)
    80001c74:	0141                	addi	sp,sp,16
    80001c76:	8082                	ret
    first = 0;
    80001c78:	00007797          	auipc	a5,0x7
    80001c7c:	c207ac23          	sw	zero,-968(a5) # 800088b0 <first.1>
    fsinit(ROOTDEV);
    80001c80:	4505                	li	a0,1
    80001c82:	00002097          	auipc	ra,0x2
    80001c86:	fb6080e7          	jalr	-74(ra) # 80003c38 <fsinit>
    80001c8a:	bff9                	j	80001c68 <forkret+0x22>

0000000080001c8c <allocpid>:
{
    80001c8c:	1101                	addi	sp,sp,-32
    80001c8e:	ec06                	sd	ra,24(sp)
    80001c90:	e822                	sd	s0,16(sp)
    80001c92:	e426                	sd	s1,8(sp)
    80001c94:	e04a                	sd	s2,0(sp)
    80001c96:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001c98:	0022f917          	auipc	s2,0x22f
    80001c9c:	f2090913          	addi	s2,s2,-224 # 80230bb8 <pid_lock>
    80001ca0:	854a                	mv	a0,s2
    80001ca2:	fffff097          	auipc	ra,0xfffff
    80001ca6:	158080e7          	jalr	344(ra) # 80000dfa <acquire>
  pid = nextpid;
    80001caa:	00007797          	auipc	a5,0x7
    80001cae:	c0a78793          	addi	a5,a5,-1014 # 800088b4 <nextpid>
    80001cb2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001cb4:	0014871b          	addiw	a4,s1,1
    80001cb8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001cba:	854a                	mv	a0,s2
    80001cbc:	fffff097          	auipc	ra,0xfffff
    80001cc0:	1f2080e7          	jalr	498(ra) # 80000eae <release>
}
    80001cc4:	8526                	mv	a0,s1
    80001cc6:	60e2                	ld	ra,24(sp)
    80001cc8:	6442                	ld	s0,16(sp)
    80001cca:	64a2                	ld	s1,8(sp)
    80001ccc:	6902                	ld	s2,0(sp)
    80001cce:	6105                	addi	sp,sp,32
    80001cd0:	8082                	ret

0000000080001cd2 <proc_pagetable>:
{
    80001cd2:	1101                	addi	sp,sp,-32
    80001cd4:	ec06                	sd	ra,24(sp)
    80001cd6:	e822                	sd	s0,16(sp)
    80001cd8:	e426                	sd	s1,8(sp)
    80001cda:	e04a                	sd	s2,0(sp)
    80001cdc:	1000                	addi	s0,sp,32
    80001cde:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001ce0:	00000097          	auipc	ra,0x0
    80001ce4:	86c080e7          	jalr	-1940(ra) # 8000154c <uvmcreate>
    80001ce8:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001cea:	c121                	beqz	a0,80001d2a <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001cec:	4729                	li	a4,10
    80001cee:	00005697          	auipc	a3,0x5
    80001cf2:	31268693          	addi	a3,a3,786 # 80007000 <_trampoline>
    80001cf6:	6605                	lui	a2,0x1
    80001cf8:	040005b7          	lui	a1,0x4000
    80001cfc:	15fd                	addi	a1,a1,-1
    80001cfe:	05b2                	slli	a1,a1,0xc
    80001d00:	fffff097          	auipc	ra,0xfffff
    80001d04:	5c2080e7          	jalr	1474(ra) # 800012c2 <mappages>
    80001d08:	02054863          	bltz	a0,80001d38 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001d0c:	4719                	li	a4,6
    80001d0e:	05893683          	ld	a3,88(s2)
    80001d12:	6605                	lui	a2,0x1
    80001d14:	020005b7          	lui	a1,0x2000
    80001d18:	15fd                	addi	a1,a1,-1
    80001d1a:	05b6                	slli	a1,a1,0xd
    80001d1c:	8526                	mv	a0,s1
    80001d1e:	fffff097          	auipc	ra,0xfffff
    80001d22:	5a4080e7          	jalr	1444(ra) # 800012c2 <mappages>
    80001d26:	02054163          	bltz	a0,80001d48 <proc_pagetable+0x76>
}
    80001d2a:	8526                	mv	a0,s1
    80001d2c:	60e2                	ld	ra,24(sp)
    80001d2e:	6442                	ld	s0,16(sp)
    80001d30:	64a2                	ld	s1,8(sp)
    80001d32:	6902                	ld	s2,0(sp)
    80001d34:	6105                	addi	sp,sp,32
    80001d36:	8082                	ret
    uvmfree(pagetable, 0);
    80001d38:	4581                	li	a1,0
    80001d3a:	8526                	mv	a0,s1
    80001d3c:	00000097          	auipc	ra,0x0
    80001d40:	a14080e7          	jalr	-1516(ra) # 80001750 <uvmfree>
    return 0;
    80001d44:	4481                	li	s1,0
    80001d46:	b7d5                	j	80001d2a <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d48:	4681                	li	a3,0
    80001d4a:	4605                	li	a2,1
    80001d4c:	040005b7          	lui	a1,0x4000
    80001d50:	15fd                	addi	a1,a1,-1
    80001d52:	05b2                	slli	a1,a1,0xc
    80001d54:	8526                	mv	a0,s1
    80001d56:	fffff097          	auipc	ra,0xfffff
    80001d5a:	732080e7          	jalr	1842(ra) # 80001488 <uvmunmap>
    uvmfree(pagetable, 0);
    80001d5e:	4581                	li	a1,0
    80001d60:	8526                	mv	a0,s1
    80001d62:	00000097          	auipc	ra,0x0
    80001d66:	9ee080e7          	jalr	-1554(ra) # 80001750 <uvmfree>
    return 0;
    80001d6a:	4481                	li	s1,0
    80001d6c:	bf7d                	j	80001d2a <proc_pagetable+0x58>

0000000080001d6e <proc_freepagetable>:
{
    80001d6e:	1101                	addi	sp,sp,-32
    80001d70:	ec06                	sd	ra,24(sp)
    80001d72:	e822                	sd	s0,16(sp)
    80001d74:	e426                	sd	s1,8(sp)
    80001d76:	e04a                	sd	s2,0(sp)
    80001d78:	1000                	addi	s0,sp,32
    80001d7a:	84aa                	mv	s1,a0
    80001d7c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d7e:	4681                	li	a3,0
    80001d80:	4605                	li	a2,1
    80001d82:	040005b7          	lui	a1,0x4000
    80001d86:	15fd                	addi	a1,a1,-1
    80001d88:	05b2                	slli	a1,a1,0xc
    80001d8a:	fffff097          	auipc	ra,0xfffff
    80001d8e:	6fe080e7          	jalr	1790(ra) # 80001488 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001d92:	4681                	li	a3,0
    80001d94:	4605                	li	a2,1
    80001d96:	020005b7          	lui	a1,0x2000
    80001d9a:	15fd                	addi	a1,a1,-1
    80001d9c:	05b6                	slli	a1,a1,0xd
    80001d9e:	8526                	mv	a0,s1
    80001da0:	fffff097          	auipc	ra,0xfffff
    80001da4:	6e8080e7          	jalr	1768(ra) # 80001488 <uvmunmap>
  uvmfree(pagetable, sz);
    80001da8:	85ca                	mv	a1,s2
    80001daa:	8526                	mv	a0,s1
    80001dac:	00000097          	auipc	ra,0x0
    80001db0:	9a4080e7          	jalr	-1628(ra) # 80001750 <uvmfree>
}
    80001db4:	60e2                	ld	ra,24(sp)
    80001db6:	6442                	ld	s0,16(sp)
    80001db8:	64a2                	ld	s1,8(sp)
    80001dba:	6902                	ld	s2,0(sp)
    80001dbc:	6105                	addi	sp,sp,32
    80001dbe:	8082                	ret

0000000080001dc0 <freeproc>:
{
    80001dc0:	1101                	addi	sp,sp,-32
    80001dc2:	ec06                	sd	ra,24(sp)
    80001dc4:	e822                	sd	s0,16(sp)
    80001dc6:	e426                	sd	s1,8(sp)
    80001dc8:	1000                	addi	s0,sp,32
    80001dca:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001dcc:	6d28                	ld	a0,88(a0)
    80001dce:	c509                	beqz	a0,80001dd8 <freeproc+0x18>
    kfree((void *)p->trapframe);
    80001dd0:	fffff097          	auipc	ra,0xfffff
    80001dd4:	da6080e7          	jalr	-602(ra) # 80000b76 <kfree>
  p->trapframe = 0;
    80001dd8:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001ddc:	68a8                	ld	a0,80(s1)
    80001dde:	c511                	beqz	a0,80001dea <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001de0:	64ac                	ld	a1,72(s1)
    80001de2:	00000097          	auipc	ra,0x0
    80001de6:	f8c080e7          	jalr	-116(ra) # 80001d6e <proc_freepagetable>
  p->pagetable = 0;
    80001dea:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001dee:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001df2:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001df6:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001dfa:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001dfe:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001e02:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001e06:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001e0a:	0004ac23          	sw	zero,24(s1)
}
    80001e0e:	60e2                	ld	ra,24(sp)
    80001e10:	6442                	ld	s0,16(sp)
    80001e12:	64a2                	ld	s1,8(sp)
    80001e14:	6105                	addi	sp,sp,32
    80001e16:	8082                	ret

0000000080001e18 <allocproc>:
{
    80001e18:	1101                	addi	sp,sp,-32
    80001e1a:	ec06                	sd	ra,24(sp)
    80001e1c:	e822                	sd	s0,16(sp)
    80001e1e:	e426                	sd	s1,8(sp)
    80001e20:	e04a                	sd	s2,0(sp)
    80001e22:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    80001e24:	0022f497          	auipc	s1,0x22f
    80001e28:	1c448493          	addi	s1,s1,452 # 80230fe8 <proc>
    80001e2c:	00235917          	auipc	s2,0x235
    80001e30:	5bc90913          	addi	s2,s2,1468 # 802373e8 <tickslock>
    acquire(&p->lock);
    80001e34:	8526                	mv	a0,s1
    80001e36:	fffff097          	auipc	ra,0xfffff
    80001e3a:	fc4080e7          	jalr	-60(ra) # 80000dfa <acquire>
    if (p->state == UNUSED)
    80001e3e:	4c9c                	lw	a5,24(s1)
    80001e40:	cf81                	beqz	a5,80001e58 <allocproc+0x40>
      release(&p->lock);
    80001e42:	8526                	mv	a0,s1
    80001e44:	fffff097          	auipc	ra,0xfffff
    80001e48:	06a080e7          	jalr	106(ra) # 80000eae <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001e4c:	19048493          	addi	s1,s1,400
    80001e50:	ff2492e3          	bne	s1,s2,80001e34 <allocproc+0x1c>
  return 0;
    80001e54:	4481                	li	s1,0
    80001e56:	a071                	j	80001ee2 <allocproc+0xca>
  p->pid = allocpid();
    80001e58:	00000097          	auipc	ra,0x0
    80001e5c:	e34080e7          	jalr	-460(ra) # 80001c8c <allocpid>
    80001e60:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001e62:	4785                	li	a5,1
    80001e64:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001e66:	fffff097          	auipc	ra,0xfffff
    80001e6a:	e98080e7          	jalr	-360(ra) # 80000cfe <kalloc>
    80001e6e:	892a                	mv	s2,a0
    80001e70:	eca8                	sd	a0,88(s1)
    80001e72:	cd3d                	beqz	a0,80001ef0 <allocproc+0xd8>
  p->pagetable = proc_pagetable(p);
    80001e74:	8526                	mv	a0,s1
    80001e76:	00000097          	auipc	ra,0x0
    80001e7a:	e5c080e7          	jalr	-420(ra) # 80001cd2 <proc_pagetable>
    80001e7e:	892a                	mv	s2,a0
    80001e80:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0)
    80001e82:	c159                	beqz	a0,80001f08 <allocproc+0xf0>
  memset(&p->context, 0, sizeof(p->context));
    80001e84:	07000613          	li	a2,112
    80001e88:	4581                	li	a1,0
    80001e8a:	06048513          	addi	a0,s1,96
    80001e8e:	fffff097          	auipc	ra,0xfffff
    80001e92:	068080e7          	jalr	104(ra) # 80000ef6 <memset>
  p->context.ra = (uint64)forkret;
    80001e96:	00000797          	auipc	a5,0x0
    80001e9a:	db078793          	addi	a5,a5,-592 # 80001c46 <forkret>
    80001e9e:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001ea0:	60bc                	ld	a5,64(s1)
    80001ea2:	6705                	lui	a4,0x1
    80001ea4:	97ba                	add	a5,a5,a4
    80001ea6:	f4bc                	sd	a5,104(s1)
  p->rtime = 0;
    80001ea8:	1604a423          	sw	zero,360(s1)
  p->etime = 0;
    80001eac:	1604a823          	sw	zero,368(s1)
  p->ctime = ticks;
    80001eb0:	00007797          	auipc	a5,0x7
    80001eb4:	a807a783          	lw	a5,-1408(a5) # 80008930 <ticks>
    80001eb8:	16f4a623          	sw	a5,364(s1)
  p->SPriority = 50;
    80001ebc:	03200793          	li	a5,50
    80001ec0:	16f4aa23          	sw	a5,372(s1)
  p->RBI = 25;
    80001ec4:	47e5                	li	a5,25
    80001ec6:	18f4a023          	sw	a5,384(s1)
  p->WTime = 0;
    80001eca:	1804a423          	sw	zero,392(s1)
  p->STime = 0;
    80001ece:	1804a223          	sw	zero,388(s1)
  p->RTime = 0;
    80001ed2:	1604ae23          	sw	zero,380(s1)
  p->no_of_times_scheduled = 0;
    80001ed6:	1804a623          	sw	zero,396(s1)
  p->DPriority = 75;
    80001eda:	04b00793          	li	a5,75
    80001ede:	16f4ac23          	sw	a5,376(s1)
}
    80001ee2:	8526                	mv	a0,s1
    80001ee4:	60e2                	ld	ra,24(sp)
    80001ee6:	6442                	ld	s0,16(sp)
    80001ee8:	64a2                	ld	s1,8(sp)
    80001eea:	6902                	ld	s2,0(sp)
    80001eec:	6105                	addi	sp,sp,32
    80001eee:	8082                	ret
    freeproc(p);
    80001ef0:	8526                	mv	a0,s1
    80001ef2:	00000097          	auipc	ra,0x0
    80001ef6:	ece080e7          	jalr	-306(ra) # 80001dc0 <freeproc>
    release(&p->lock);
    80001efa:	8526                	mv	a0,s1
    80001efc:	fffff097          	auipc	ra,0xfffff
    80001f00:	fb2080e7          	jalr	-78(ra) # 80000eae <release>
    return 0;
    80001f04:	84ca                	mv	s1,s2
    80001f06:	bff1                	j	80001ee2 <allocproc+0xca>
    freeproc(p);
    80001f08:	8526                	mv	a0,s1
    80001f0a:	00000097          	auipc	ra,0x0
    80001f0e:	eb6080e7          	jalr	-330(ra) # 80001dc0 <freeproc>
    release(&p->lock);
    80001f12:	8526                	mv	a0,s1
    80001f14:	fffff097          	auipc	ra,0xfffff
    80001f18:	f9a080e7          	jalr	-102(ra) # 80000eae <release>
    return 0;
    80001f1c:	84ca                	mv	s1,s2
    80001f1e:	b7d1                	j	80001ee2 <allocproc+0xca>

0000000080001f20 <userinit>:
{
    80001f20:	1101                	addi	sp,sp,-32
    80001f22:	ec06                	sd	ra,24(sp)
    80001f24:	e822                	sd	s0,16(sp)
    80001f26:	e426                	sd	s1,8(sp)
    80001f28:	1000                	addi	s0,sp,32
  p = allocproc();
    80001f2a:	00000097          	auipc	ra,0x0
    80001f2e:	eee080e7          	jalr	-274(ra) # 80001e18 <allocproc>
    80001f32:	84aa                	mv	s1,a0
  initproc = p;
    80001f34:	00007797          	auipc	a5,0x7
    80001f38:	9ea7ba23          	sd	a0,-1548(a5) # 80008928 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001f3c:	03400613          	li	a2,52
    80001f40:	00007597          	auipc	a1,0x7
    80001f44:	98058593          	addi	a1,a1,-1664 # 800088c0 <initcode>
    80001f48:	6928                	ld	a0,80(a0)
    80001f4a:	fffff097          	auipc	ra,0xfffff
    80001f4e:	630080e7          	jalr	1584(ra) # 8000157a <uvmfirst>
  p->sz = PGSIZE;
    80001f52:	6785                	lui	a5,0x1
    80001f54:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    80001f56:	6cb8                	ld	a4,88(s1)
    80001f58:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    80001f5c:	6cb8                	ld	a4,88(s1)
    80001f5e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001f60:	4641                	li	a2,16
    80001f62:	00006597          	auipc	a1,0x6
    80001f66:	2ee58593          	addi	a1,a1,750 # 80008250 <digits+0x210>
    80001f6a:	15848513          	addi	a0,s1,344
    80001f6e:	fffff097          	auipc	ra,0xfffff
    80001f72:	0d2080e7          	jalr	210(ra) # 80001040 <safestrcpy>
  p->cwd = namei("/");
    80001f76:	00006517          	auipc	a0,0x6
    80001f7a:	2ea50513          	addi	a0,a0,746 # 80008260 <digits+0x220>
    80001f7e:	00002097          	auipc	ra,0x2
    80001f82:	6dc080e7          	jalr	1756(ra) # 8000465a <namei>
    80001f86:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001f8a:	478d                	li	a5,3
    80001f8c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001f8e:	8526                	mv	a0,s1
    80001f90:	fffff097          	auipc	ra,0xfffff
    80001f94:	f1e080e7          	jalr	-226(ra) # 80000eae <release>
}
    80001f98:	60e2                	ld	ra,24(sp)
    80001f9a:	6442                	ld	s0,16(sp)
    80001f9c:	64a2                	ld	s1,8(sp)
    80001f9e:	6105                	addi	sp,sp,32
    80001fa0:	8082                	ret

0000000080001fa2 <growproc>:
{
    80001fa2:	1101                	addi	sp,sp,-32
    80001fa4:	ec06                	sd	ra,24(sp)
    80001fa6:	e822                	sd	s0,16(sp)
    80001fa8:	e426                	sd	s1,8(sp)
    80001faa:	e04a                	sd	s2,0(sp)
    80001fac:	1000                	addi	s0,sp,32
    80001fae:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001fb0:	00000097          	auipc	ra,0x0
    80001fb4:	c5e080e7          	jalr	-930(ra) # 80001c0e <myproc>
    80001fb8:	84aa                	mv	s1,a0
  sz = p->sz;
    80001fba:	652c                	ld	a1,72(a0)
  if (n > 0)
    80001fbc:	01204c63          	bgtz	s2,80001fd4 <growproc+0x32>
  else if (n < 0)
    80001fc0:	02094663          	bltz	s2,80001fec <growproc+0x4a>
  p->sz = sz;
    80001fc4:	e4ac                	sd	a1,72(s1)
  return 0;
    80001fc6:	4501                	li	a0,0
}
    80001fc8:	60e2                	ld	ra,24(sp)
    80001fca:	6442                	ld	s0,16(sp)
    80001fcc:	64a2                	ld	s1,8(sp)
    80001fce:	6902                	ld	s2,0(sp)
    80001fd0:	6105                	addi	sp,sp,32
    80001fd2:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80001fd4:	4691                	li	a3,4
    80001fd6:	00b90633          	add	a2,s2,a1
    80001fda:	6928                	ld	a0,80(a0)
    80001fdc:	fffff097          	auipc	ra,0xfffff
    80001fe0:	658080e7          	jalr	1624(ra) # 80001634 <uvmalloc>
    80001fe4:	85aa                	mv	a1,a0
    80001fe6:	fd79                	bnez	a0,80001fc4 <growproc+0x22>
      return -1;
    80001fe8:	557d                	li	a0,-1
    80001fea:	bff9                	j	80001fc8 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001fec:	00b90633          	add	a2,s2,a1
    80001ff0:	6928                	ld	a0,80(a0)
    80001ff2:	fffff097          	auipc	ra,0xfffff
    80001ff6:	5fa080e7          	jalr	1530(ra) # 800015ec <uvmdealloc>
    80001ffa:	85aa                	mv	a1,a0
    80001ffc:	b7e1                	j	80001fc4 <growproc+0x22>

0000000080001ffe <fork>:
{
    80001ffe:	7139                	addi	sp,sp,-64
    80002000:	fc06                	sd	ra,56(sp)
    80002002:	f822                	sd	s0,48(sp)
    80002004:	f426                	sd	s1,40(sp)
    80002006:	f04a                	sd	s2,32(sp)
    80002008:	ec4e                	sd	s3,24(sp)
    8000200a:	e852                	sd	s4,16(sp)
    8000200c:	e456                	sd	s5,8(sp)
    8000200e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002010:	00000097          	auipc	ra,0x0
    80002014:	bfe080e7          	jalr	-1026(ra) # 80001c0e <myproc>
    80002018:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0)
    8000201a:	00000097          	auipc	ra,0x0
    8000201e:	dfe080e7          	jalr	-514(ra) # 80001e18 <allocproc>
    80002022:	10050c63          	beqz	a0,8000213a <fork+0x13c>
    80002026:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80002028:	048ab603          	ld	a2,72(s5)
    8000202c:	692c                	ld	a1,80(a0)
    8000202e:	050ab503          	ld	a0,80(s5)
    80002032:	fffff097          	auipc	ra,0xfffff
    80002036:	756080e7          	jalr	1878(ra) # 80001788 <uvmcopy>
    8000203a:	04054863          	bltz	a0,8000208a <fork+0x8c>
  np->sz = p->sz;
    8000203e:	048ab783          	ld	a5,72(s5)
    80002042:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80002046:	058ab683          	ld	a3,88(s5)
    8000204a:	87b6                	mv	a5,a3
    8000204c:	058a3703          	ld	a4,88(s4)
    80002050:	12068693          	addi	a3,a3,288
    80002054:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80002058:	6788                	ld	a0,8(a5)
    8000205a:	6b8c                	ld	a1,16(a5)
    8000205c:	6f90                	ld	a2,24(a5)
    8000205e:	01073023          	sd	a6,0(a4)
    80002062:	e708                	sd	a0,8(a4)
    80002064:	eb0c                	sd	a1,16(a4)
    80002066:	ef10                	sd	a2,24(a4)
    80002068:	02078793          	addi	a5,a5,32
    8000206c:	02070713          	addi	a4,a4,32
    80002070:	fed792e3          	bne	a5,a3,80002054 <fork+0x56>
  np->trapframe->a0 = 0;
    80002074:	058a3783          	ld	a5,88(s4)
    80002078:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    8000207c:	0d0a8493          	addi	s1,s5,208
    80002080:	0d0a0913          	addi	s2,s4,208
    80002084:	150a8993          	addi	s3,s5,336
    80002088:	a00d                	j	800020aa <fork+0xac>
    freeproc(np);
    8000208a:	8552                	mv	a0,s4
    8000208c:	00000097          	auipc	ra,0x0
    80002090:	d34080e7          	jalr	-716(ra) # 80001dc0 <freeproc>
    release(&np->lock);
    80002094:	8552                	mv	a0,s4
    80002096:	fffff097          	auipc	ra,0xfffff
    8000209a:	e18080e7          	jalr	-488(ra) # 80000eae <release>
    return -1;
    8000209e:	597d                	li	s2,-1
    800020a0:	a059                	j	80002126 <fork+0x128>
  for (i = 0; i < NOFILE; i++)
    800020a2:	04a1                	addi	s1,s1,8
    800020a4:	0921                	addi	s2,s2,8
    800020a6:	01348b63          	beq	s1,s3,800020bc <fork+0xbe>
    if (p->ofile[i])
    800020aa:	6088                	ld	a0,0(s1)
    800020ac:	d97d                	beqz	a0,800020a2 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800020ae:	00003097          	auipc	ra,0x3
    800020b2:	c42080e7          	jalr	-958(ra) # 80004cf0 <filedup>
    800020b6:	00a93023          	sd	a0,0(s2)
    800020ba:	b7e5                	j	800020a2 <fork+0xa4>
  np->cwd = idup(p->cwd);
    800020bc:	150ab503          	ld	a0,336(s5)
    800020c0:	00002097          	auipc	ra,0x2
    800020c4:	db6080e7          	jalr	-586(ra) # 80003e76 <idup>
    800020c8:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800020cc:	4641                	li	a2,16
    800020ce:	158a8593          	addi	a1,s5,344
    800020d2:	158a0513          	addi	a0,s4,344
    800020d6:	fffff097          	auipc	ra,0xfffff
    800020da:	f6a080e7          	jalr	-150(ra) # 80001040 <safestrcpy>
  pid = np->pid;
    800020de:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800020e2:	8552                	mv	a0,s4
    800020e4:	fffff097          	auipc	ra,0xfffff
    800020e8:	dca080e7          	jalr	-566(ra) # 80000eae <release>
  acquire(&wait_lock);
    800020ec:	0022f497          	auipc	s1,0x22f
    800020f0:	ae448493          	addi	s1,s1,-1308 # 80230bd0 <wait_lock>
    800020f4:	8526                	mv	a0,s1
    800020f6:	fffff097          	auipc	ra,0xfffff
    800020fa:	d04080e7          	jalr	-764(ra) # 80000dfa <acquire>
  np->parent = p;
    800020fe:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80002102:	8526                	mv	a0,s1
    80002104:	fffff097          	auipc	ra,0xfffff
    80002108:	daa080e7          	jalr	-598(ra) # 80000eae <release>
  acquire(&np->lock);
    8000210c:	8552                	mv	a0,s4
    8000210e:	fffff097          	auipc	ra,0xfffff
    80002112:	cec080e7          	jalr	-788(ra) # 80000dfa <acquire>
  np->state = RUNNABLE;
    80002116:	478d                	li	a5,3
    80002118:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000211c:	8552                	mv	a0,s4
    8000211e:	fffff097          	auipc	ra,0xfffff
    80002122:	d90080e7          	jalr	-624(ra) # 80000eae <release>
}
    80002126:	854a                	mv	a0,s2
    80002128:	70e2                	ld	ra,56(sp)
    8000212a:	7442                	ld	s0,48(sp)
    8000212c:	74a2                	ld	s1,40(sp)
    8000212e:	7902                	ld	s2,32(sp)
    80002130:	69e2                	ld	s3,24(sp)
    80002132:	6a42                	ld	s4,16(sp)
    80002134:	6aa2                	ld	s5,8(sp)
    80002136:	6121                	addi	sp,sp,64
    80002138:	8082                	ret
    return -1;
    8000213a:	597d                	li	s2,-1
    8000213c:	b7ed                	j	80002126 <fork+0x128>

000000008000213e <dp_calculator>:
{
    8000213e:	1141                	addi	sp,sp,-16
    80002140:	e422                	sd	s0,8(sp)
    80002142:	0800                	addi	s0,sp,16
  int nr = 3 * p->rtime - p->STime - p->WTime;
    80002144:	16852703          	lw	a4,360(a0)
    80002148:	18452603          	lw	a2,388(a0)
    8000214c:	18852683          	lw	a3,392(a0)
    80002150:	0017179b          	slliw	a5,a4,0x1
    80002154:	9fb9                	addw	a5,a5,a4
    80002156:	00d605bb          	addw	a1,a2,a3
    8000215a:	9f8d                	subw	a5,a5,a1
  int no = (nr * 50) / dr;
    8000215c:	03200593          	li	a1,50
    80002160:	02b787bb          	mulw	a5,a5,a1
  int dr = p->rtime + p->STime + p->WTime + 1;
    80002164:	2705                	addiw	a4,a4,1
    80002166:	9f31                	addw	a4,a4,a2
    80002168:	9f35                	addw	a4,a4,a3
  int no = (nr * 50) / dr;
    8000216a:	02e7c7bb          	divw	a5,a5,a4
    8000216e:	0007871b          	sext.w	a4,a5
    80002172:	fff74713          	not	a4,a4
    80002176:	977d                	srai	a4,a4,0x3f
    80002178:	8ff9                	and	a5,a5,a4
  p->RBI = rbi;
    8000217a:	18f52023          	sw	a5,384(a0)
  if (p->SPriority + rbi < 100)
    8000217e:	17452703          	lw	a4,372(a0)
    80002182:	9fb9                	addw	a5,a5,a4
    80002184:	06300713          	li	a4,99
    80002188:	00f75463          	bge	a4,a5,80002190 <dp_calculator+0x52>
    p->DPriority = 100;
    8000218c:	06400793          	li	a5,100
    80002190:	16f52c23          	sw	a5,376(a0)
}
    80002194:	6422                	ld	s0,8(sp)
    80002196:	0141                	addi	sp,sp,16
    80002198:	8082                	ret

000000008000219a <scheduler>:
{
    8000219a:	7119                	addi	sp,sp,-128
    8000219c:	fc86                	sd	ra,120(sp)
    8000219e:	f8a2                	sd	s0,112(sp)
    800021a0:	f4a6                	sd	s1,104(sp)
    800021a2:	f0ca                	sd	s2,96(sp)
    800021a4:	ecce                	sd	s3,88(sp)
    800021a6:	e8d2                	sd	s4,80(sp)
    800021a8:	e4d6                	sd	s5,72(sp)
    800021aa:	e0da                	sd	s6,64(sp)
    800021ac:	fc5e                	sd	s7,56(sp)
    800021ae:	f862                	sd	s8,48(sp)
    800021b0:	f466                	sd	s9,40(sp)
    800021b2:	f06a                	sd	s10,32(sp)
    800021b4:	ec6e                	sd	s11,24(sp)
    800021b6:	0100                	addi	s0,sp,128
    800021b8:	8792                	mv	a5,tp
  int id = r_tp();
    800021ba:	2781                	sext.w	a5,a5
  c->proc = 0;
    800021bc:	00779693          	slli	a3,a5,0x7
    800021c0:	0022f717          	auipc	a4,0x22f
    800021c4:	9f870713          	addi	a4,a4,-1544 # 80230bb8 <pid_lock>
    800021c8:	9736                	add	a4,a4,a3
    800021ca:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &MinProcess->context);
    800021ce:	0022f717          	auipc	a4,0x22f
    800021d2:	a2270713          	addi	a4,a4,-1502 # 80230bf0 <cpus+0x8>
    800021d6:	9736                	add	a4,a4,a3
    800021d8:	f8e43423          	sd	a4,-120(s0)
    for (p = proc; p < &proc[NPROC]; p++)
    800021dc:	00235b17          	auipc	s6,0x235
    800021e0:	20cb0b13          	addi	s6,s6,524 # 802373e8 <tickslock>
        int no = (nr * 50) / dr;
    800021e4:	03200c93          	li	s9,50
        c->proc = MinProcess;
    800021e8:	0022f717          	auipc	a4,0x22f
    800021ec:	9d070713          	addi	a4,a4,-1584 # 80230bb8 <pid_lock>
    800021f0:	00d707b3          	add	a5,a4,a3
    800021f4:	f8f43023          	sd	a5,-128(s0)
    800021f8:	aa31                	j	80002314 <scheduler+0x17a>
        int nr = 3 * p->RTime - p->STime - p->WTime;
    800021fa:	fec4a703          	lw	a4,-20(s1)
    800021fe:	ff44a603          	lw	a2,-12(s1)
    80002202:	ff84a683          	lw	a3,-8(s1)
    80002206:	0017179b          	slliw	a5,a4,0x1
    8000220a:	9fb9                	addw	a5,a5,a4
    8000220c:	9f91                	subw	a5,a5,a2
    8000220e:	9f95                	subw	a5,a5,a3
        int no = (nr * 50) / dr;
    80002210:	039787bb          	mulw	a5,a5,s9
        int dr = p->RTime + p->STime + p->WTime + 1;
    80002214:	9f31                	addw	a4,a4,a2
    80002216:	9f35                	addw	a4,a4,a3
    80002218:	2705                	addiw	a4,a4,1
        int no = (nr * 50) / dr;
    8000221a:	02e7c7bb          	divw	a5,a5,a4
    8000221e:	0007871b          	sext.w	a4,a5
    80002222:	fff74713          	not	a4,a4
    80002226:	977d                	srai	a4,a4,0x3f
    80002228:	8ff9                	and	a5,a5,a4
        p->RBI = rbi;
    8000222a:	fef4a823          	sw	a5,-16(s1)
        if (p->SPriority + rbi < 100)
    8000222e:	fe44a703          	lw	a4,-28(s1)
    80002232:	9fb9                	addw	a5,a5,a4
    80002234:	00fd5363          	bge	s10,a5,8000223a <scheduler+0xa0>
          p->DPriority = 100;
    80002238:	87ee                	mv	a5,s11
    8000223a:	fef9a423          	sw	a5,-24(s3)
        if (MinProcess == 0)
    8000223e:	0e0b8263          	beqz	s7,80002322 <scheduler+0x188>
        if (p->DPriority < MinPrior)
    80002242:	0787d663          	bge	a5,s8,800022ae <scheduler+0x114>
          MinPrior = p->DPriority;
    80002246:	8c3e                	mv	s8,a5
    80002248:	8bd2                	mv	s7,s4
      release(&p->lock);
    8000224a:	8552                	mv	a0,s4
    8000224c:	fffff097          	auipc	ra,0xfffff
    80002250:	c62080e7          	jalr	-926(ra) # 80000eae <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80002254:	0769f663          	bgeu	s3,s6,800022c0 <scheduler+0x126>
    80002258:	19090913          	addi	s2,s2,400
    8000225c:	19048493          	addi	s1,s1,400
    80002260:	8a4a                	mv	s4,s2
      acquire(&p->lock);
    80002262:	854a                	mv	a0,s2
    80002264:	fffff097          	auipc	ra,0xfffff
    80002268:	b96080e7          	jalr	-1130(ra) # 80000dfa <acquire>
      if (p->state == RUNNABLE)
    8000226c:	89a6                	mv	s3,s1
    8000226e:	e884a783          	lw	a5,-376(s1)
    80002272:	f95784e3          	beq	a5,s5,800021fa <scheduler+0x60>
      release(&p->lock);
    80002276:	854a                	mv	a0,s2
    80002278:	fffff097          	auipc	ra,0xfffff
    8000227c:	c36080e7          	jalr	-970(ra) # 80000eae <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80002280:	fd64ece3          	bltu	s1,s6,80002258 <scheduler+0xbe>
    if (MinProcess != 0)
    80002284:	020b9e63          	bnez	s7,800022c0 <scheduler+0x126>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002288:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000228c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002290:	10079073          	csrw	sstatus,a5
    for (p = proc; p < &proc[NPROC]; p++)
    80002294:	0022f917          	auipc	s2,0x22f
    80002298:	d5490913          	addi	s2,s2,-684 # 80230fe8 <proc>
    8000229c:	0022f497          	auipc	s1,0x22f
    800022a0:	edc48493          	addi	s1,s1,-292 # 80231178 <proc+0x190>
    int MinPrior = 101;
    800022a4:	06500c13          	li	s8,101
    struct proc *MinProcess = 0;
    800022a8:	4b81                	li	s7,0
      if (p->state == RUNNABLE)
    800022aa:	4a8d                	li	s5,3
    800022ac:	bf55                	j	80002260 <scheduler+0xc6>
        else if (p->DPriority == MinPrior)
    800022ae:	07878863          	beq	a5,s8,8000231e <scheduler+0x184>
      release(&p->lock);
    800022b2:	8552                	mv	a0,s4
    800022b4:	fffff097          	auipc	ra,0xfffff
    800022b8:	bfa080e7          	jalr	-1030(ra) # 80000eae <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800022bc:	f969eee3          	bltu	s3,s6,80002258 <scheduler+0xbe>
      acquire(&MinProcess->lock);
    800022c0:	84de                	mv	s1,s7
    800022c2:	855e                	mv	a0,s7
    800022c4:	fffff097          	auipc	ra,0xfffff
    800022c8:	b36080e7          	jalr	-1226(ra) # 80000dfa <acquire>
      if (MinProcess->state == RUNNABLE)
    800022cc:	018ba703          	lw	a4,24(s7) # fffffffffffff018 <end+0xffffffff7fdbc850>
    800022d0:	478d                	li	a5,3
    800022d2:	02f71c63          	bne	a4,a5,8000230a <scheduler+0x170>
        MinProcess->no_of_times_scheduled++;
    800022d6:	18cba783          	lw	a5,396(s7)
    800022da:	2785                	addiw	a5,a5,1
    800022dc:	18fba623          	sw	a5,396(s7)
        MinProcess->state = RUNNING;
    800022e0:	4791                	li	a5,4
    800022e2:	00fbac23          	sw	a5,24(s7)
        MinProcess->RTime = 0;
    800022e6:	160bae23          	sw	zero,380(s7)
        MinProcess->STime = 0;
    800022ea:	180ba223          	sw	zero,388(s7)
        c->proc = MinProcess;
    800022ee:	f8043903          	ld	s2,-128(s0)
    800022f2:	03793823          	sd	s7,48(s2)
        swtch(&c->context, &MinProcess->context);
    800022f6:	060b8593          	addi	a1,s7,96
    800022fa:	f8843503          	ld	a0,-120(s0)
    800022fe:	00001097          	auipc	ra,0x1
    80002302:	94e080e7          	jalr	-1714(ra) # 80002c4c <swtch>
        c->proc = 0;
    80002306:	02093823          	sd	zero,48(s2)
      release(&MinProcess->lock);
    8000230a:	8526                	mv	a0,s1
    8000230c:	fffff097          	auipc	ra,0xfffff
    80002310:	ba2080e7          	jalr	-1118(ra) # 80000eae <release>
        if (p->SPriority + rbi < 100)
    80002314:	06300d13          	li	s10,99
          p->DPriority = 100;
    80002318:	06400d93          	li	s11,100
    8000231c:	b7b5                	j	80002288 <scheduler+0xee>
    8000231e:	87e2                	mv	a5,s8
    80002320:	a011                	j	80002324 <scheduler+0x18a>
    80002322:	8bd2                	mv	s7,s4
          if (p->no_of_times_scheduled < MinProcess->no_of_times_scheduled)
    80002324:	ffc9a683          	lw	a3,-4(s3)
    80002328:	18cba703          	lw	a4,396(s7)
    8000232c:	00e6cd63          	blt	a3,a4,80002346 <scheduler+0x1ac>
          else if (p->no_of_times_scheduled == MinProcess->no_of_times_scheduled)
    80002330:	8c3e                	mv	s8,a5
    80002332:	f0e69ce3          	bne	a3,a4,8000224a <scheduler+0xb0>
            if (p->ctime > MinProcess->ctime)
    80002336:	fdc9a683          	lw	a3,-36(s3)
    8000233a:	16cba703          	lw	a4,364(s7)
    8000233e:	f0d776e3          	bgeu	a4,a3,8000224a <scheduler+0xb0>
    80002342:	8bd2                	mv	s7,s4
    80002344:	b719                	j	8000224a <scheduler+0xb0>
    80002346:	8c3e                	mv	s8,a5
    80002348:	8bd2                	mv	s7,s4
    8000234a:	b701                	j	8000224a <scheduler+0xb0>

000000008000234c <sched>:
{
    8000234c:	7179                	addi	sp,sp,-48
    8000234e:	f406                	sd	ra,40(sp)
    80002350:	f022                	sd	s0,32(sp)
    80002352:	ec26                	sd	s1,24(sp)
    80002354:	e84a                	sd	s2,16(sp)
    80002356:	e44e                	sd	s3,8(sp)
    80002358:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000235a:	00000097          	auipc	ra,0x0
    8000235e:	8b4080e7          	jalr	-1868(ra) # 80001c0e <myproc>
    80002362:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80002364:	fffff097          	auipc	ra,0xfffff
    80002368:	a1c080e7          	jalr	-1508(ra) # 80000d80 <holding>
    8000236c:	c93d                	beqz	a0,800023e2 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000236e:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80002370:	2781                	sext.w	a5,a5
    80002372:	079e                	slli	a5,a5,0x7
    80002374:	0022f717          	auipc	a4,0x22f
    80002378:	84470713          	addi	a4,a4,-1980 # 80230bb8 <pid_lock>
    8000237c:	97ba                	add	a5,a5,a4
    8000237e:	0a87a703          	lw	a4,168(a5)
    80002382:	4785                	li	a5,1
    80002384:	06f71763          	bne	a4,a5,800023f2 <sched+0xa6>
  if (p->state == RUNNING)
    80002388:	4c98                	lw	a4,24(s1)
    8000238a:	4791                	li	a5,4
    8000238c:	06f70b63          	beq	a4,a5,80002402 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002390:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002394:	8b89                	andi	a5,a5,2
  if (intr_get())
    80002396:	efb5                	bnez	a5,80002412 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002398:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000239a:	0022f917          	auipc	s2,0x22f
    8000239e:	81e90913          	addi	s2,s2,-2018 # 80230bb8 <pid_lock>
    800023a2:	2781                	sext.w	a5,a5
    800023a4:	079e                	slli	a5,a5,0x7
    800023a6:	97ca                	add	a5,a5,s2
    800023a8:	0ac7a983          	lw	s3,172(a5)
    800023ac:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800023ae:	2781                	sext.w	a5,a5
    800023b0:	079e                	slli	a5,a5,0x7
    800023b2:	0022f597          	auipc	a1,0x22f
    800023b6:	83e58593          	addi	a1,a1,-1986 # 80230bf0 <cpus+0x8>
    800023ba:	95be                	add	a1,a1,a5
    800023bc:	06048513          	addi	a0,s1,96
    800023c0:	00001097          	auipc	ra,0x1
    800023c4:	88c080e7          	jalr	-1908(ra) # 80002c4c <swtch>
    800023c8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800023ca:	2781                	sext.w	a5,a5
    800023cc:	079e                	slli	a5,a5,0x7
    800023ce:	97ca                	add	a5,a5,s2
    800023d0:	0b37a623          	sw	s3,172(a5)
}
    800023d4:	70a2                	ld	ra,40(sp)
    800023d6:	7402                	ld	s0,32(sp)
    800023d8:	64e2                	ld	s1,24(sp)
    800023da:	6942                	ld	s2,16(sp)
    800023dc:	69a2                	ld	s3,8(sp)
    800023de:	6145                	addi	sp,sp,48
    800023e0:	8082                	ret
    panic("sched p->lock");
    800023e2:	00006517          	auipc	a0,0x6
    800023e6:	e8650513          	addi	a0,a0,-378 # 80008268 <digits+0x228>
    800023ea:	ffffe097          	auipc	ra,0xffffe
    800023ee:	154080e7          	jalr	340(ra) # 8000053e <panic>
    panic("sched locks");
    800023f2:	00006517          	auipc	a0,0x6
    800023f6:	e8650513          	addi	a0,a0,-378 # 80008278 <digits+0x238>
    800023fa:	ffffe097          	auipc	ra,0xffffe
    800023fe:	144080e7          	jalr	324(ra) # 8000053e <panic>
    panic("sched running");
    80002402:	00006517          	auipc	a0,0x6
    80002406:	e8650513          	addi	a0,a0,-378 # 80008288 <digits+0x248>
    8000240a:	ffffe097          	auipc	ra,0xffffe
    8000240e:	134080e7          	jalr	308(ra) # 8000053e <panic>
    panic("sched interruptible");
    80002412:	00006517          	auipc	a0,0x6
    80002416:	e8650513          	addi	a0,a0,-378 # 80008298 <digits+0x258>
    8000241a:	ffffe097          	auipc	ra,0xffffe
    8000241e:	124080e7          	jalr	292(ra) # 8000053e <panic>

0000000080002422 <yield>:
{
    80002422:	1101                	addi	sp,sp,-32
    80002424:	ec06                	sd	ra,24(sp)
    80002426:	e822                	sd	s0,16(sp)
    80002428:	e426                	sd	s1,8(sp)
    8000242a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000242c:	fffff097          	auipc	ra,0xfffff
    80002430:	7e2080e7          	jalr	2018(ra) # 80001c0e <myproc>
    80002434:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002436:	fffff097          	auipc	ra,0xfffff
    8000243a:	9c4080e7          	jalr	-1596(ra) # 80000dfa <acquire>
  p->state = RUNNABLE;
    8000243e:	478d                	li	a5,3
    80002440:	cc9c                	sw	a5,24(s1)
  sched();
    80002442:	00000097          	auipc	ra,0x0
    80002446:	f0a080e7          	jalr	-246(ra) # 8000234c <sched>
  release(&p->lock);
    8000244a:	8526                	mv	a0,s1
    8000244c:	fffff097          	auipc	ra,0xfffff
    80002450:	a62080e7          	jalr	-1438(ra) # 80000eae <release>
}
    80002454:	60e2                	ld	ra,24(sp)
    80002456:	6442                	ld	s0,16(sp)
    80002458:	64a2                	ld	s1,8(sp)
    8000245a:	6105                	addi	sp,sp,32
    8000245c:	8082                	ret

000000008000245e <set_priority>:
{
    8000245e:	7179                	addi	sp,sp,-48
    80002460:	f406                	sd	ra,40(sp)
    80002462:	f022                	sd	s0,32(sp)
    80002464:	ec26                	sd	s1,24(sp)
    80002466:	e84a                	sd	s2,16(sp)
    80002468:	e44e                	sd	s3,8(sp)
    8000246a:	e052                	sd	s4,0(sp)
    8000246c:	1800                	addi	s0,sp,48
    8000246e:	8a2a                	mv	s4,a0
    80002470:	892e                	mv	s2,a1
  for (p = proc; p < &proc[NPROC]; p++)
    80002472:	0022f497          	auipc	s1,0x22f
    80002476:	b7648493          	addi	s1,s1,-1162 # 80230fe8 <proc>
    8000247a:	00235997          	auipc	s3,0x235
    8000247e:	f6e98993          	addi	s3,s3,-146 # 802373e8 <tickslock>
    acquire(&p->lock);
    80002482:	8526                	mv	a0,s1
    80002484:	fffff097          	auipc	ra,0xfffff
    80002488:	976080e7          	jalr	-1674(ra) # 80000dfa <acquire>
    if (p->pid == pid)
    8000248c:	589c                	lw	a5,48(s1)
    8000248e:	01278d63          	beq	a5,s2,800024a8 <set_priority+0x4a>
      release(&p->lock);
    80002492:	8526                	mv	a0,s1
    80002494:	fffff097          	auipc	ra,0xfffff
    80002498:	a1a080e7          	jalr	-1510(ra) # 80000eae <release>
  for (p = proc; p < &proc[NPROC]; p++)
    8000249c:	19048493          	addi	s1,s1,400
    800024a0:	ff3491e3          	bne	s1,s3,80002482 <set_priority+0x24>
  return oldPriorty;
    800024a4:	597d                	li	s2,-1
    800024a6:	a005                	j	800024c6 <set_priority+0x68>
      oldPriorty = p->SPriority;
    800024a8:	1744a903          	lw	s2,372(s1)
      p->SPriority = priority;
    800024ac:	1744aa23          	sw	s4,372(s1)
      p->RBI = 25;
    800024b0:	47e5                	li	a5,25
    800024b2:	18f4a023          	sw	a5,384(s1)
      release(&p->lock);
    800024b6:	8526                	mv	a0,s1
    800024b8:	fffff097          	auipc	ra,0xfffff
    800024bc:	9f6080e7          	jalr	-1546(ra) # 80000eae <release>
      if (oldPriorty > priority)
    800024c0:	012a4c63          	blt	s4,s2,800024d8 <set_priority+0x7a>
        oldPriorty = -1;
    800024c4:	597d                	li	s2,-1
}
    800024c6:	854a                	mv	a0,s2
    800024c8:	70a2                	ld	ra,40(sp)
    800024ca:	7402                	ld	s0,32(sp)
    800024cc:	64e2                	ld	s1,24(sp)
    800024ce:	6942                	ld	s2,16(sp)
    800024d0:	69a2                	ld	s3,8(sp)
    800024d2:	6a02                	ld	s4,0(sp)
    800024d4:	6145                	addi	sp,sp,48
    800024d6:	8082                	ret
        yield();
    800024d8:	00000097          	auipc	ra,0x0
    800024dc:	f4a080e7          	jalr	-182(ra) # 80002422 <yield>
    800024e0:	b7dd                	j	800024c6 <set_priority+0x68>

00000000800024e2 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    800024e2:	7179                	addi	sp,sp,-48
    800024e4:	f406                	sd	ra,40(sp)
    800024e6:	f022                	sd	s0,32(sp)
    800024e8:	ec26                	sd	s1,24(sp)
    800024ea:	e84a                	sd	s2,16(sp)
    800024ec:	e44e                	sd	s3,8(sp)
    800024ee:	1800                	addi	s0,sp,48
    800024f0:	89aa                	mv	s3,a0
    800024f2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800024f4:	fffff097          	auipc	ra,0xfffff
    800024f8:	71a080e7          	jalr	1818(ra) # 80001c0e <myproc>
    800024fc:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    800024fe:	fffff097          	auipc	ra,0xfffff
    80002502:	8fc080e7          	jalr	-1796(ra) # 80000dfa <acquire>
  release(lk);
    80002506:	854a                	mv	a0,s2
    80002508:	fffff097          	auipc	ra,0xfffff
    8000250c:	9a6080e7          	jalr	-1626(ra) # 80000eae <release>

  // Go to sleep.
  p->chan = chan;
    80002510:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002514:	4789                	li	a5,2
    80002516:	cc9c                	sw	a5,24(s1)

  sched();
    80002518:	00000097          	auipc	ra,0x0
    8000251c:	e34080e7          	jalr	-460(ra) # 8000234c <sched>

  // Tidy up.
  p->chan = 0;
    80002520:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002524:	8526                	mv	a0,s1
    80002526:	fffff097          	auipc	ra,0xfffff
    8000252a:	988080e7          	jalr	-1656(ra) # 80000eae <release>
  acquire(lk);
    8000252e:	854a                	mv	a0,s2
    80002530:	fffff097          	auipc	ra,0xfffff
    80002534:	8ca080e7          	jalr	-1846(ra) # 80000dfa <acquire>
}
    80002538:	70a2                	ld	ra,40(sp)
    8000253a:	7402                	ld	s0,32(sp)
    8000253c:	64e2                	ld	s1,24(sp)
    8000253e:	6942                	ld	s2,16(sp)
    80002540:	69a2                	ld	s3,8(sp)
    80002542:	6145                	addi	sp,sp,48
    80002544:	8082                	ret

0000000080002546 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80002546:	7139                	addi	sp,sp,-64
    80002548:	fc06                	sd	ra,56(sp)
    8000254a:	f822                	sd	s0,48(sp)
    8000254c:	f426                	sd	s1,40(sp)
    8000254e:	f04a                	sd	s2,32(sp)
    80002550:	ec4e                	sd	s3,24(sp)
    80002552:	e852                	sd	s4,16(sp)
    80002554:	e456                	sd	s5,8(sp)
    80002556:	0080                	addi	s0,sp,64
    80002558:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    8000255a:	0022f497          	auipc	s1,0x22f
    8000255e:	a8e48493          	addi	s1,s1,-1394 # 80230fe8 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    80002562:	4989                	li	s3,2
      {
        p->state = RUNNABLE;
    80002564:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    80002566:	00235917          	auipc	s2,0x235
    8000256a:	e8290913          	addi	s2,s2,-382 # 802373e8 <tickslock>
    8000256e:	a811                	j	80002582 <wakeup+0x3c>
      }
      release(&p->lock);
    80002570:	8526                	mv	a0,s1
    80002572:	fffff097          	auipc	ra,0xfffff
    80002576:	93c080e7          	jalr	-1732(ra) # 80000eae <release>
  for (p = proc; p < &proc[NPROC]; p++)
    8000257a:	19048493          	addi	s1,s1,400
    8000257e:	03248663          	beq	s1,s2,800025aa <wakeup+0x64>
    if (p != myproc())
    80002582:	fffff097          	auipc	ra,0xfffff
    80002586:	68c080e7          	jalr	1676(ra) # 80001c0e <myproc>
    8000258a:	fea488e3          	beq	s1,a0,8000257a <wakeup+0x34>
      acquire(&p->lock);
    8000258e:	8526                	mv	a0,s1
    80002590:	fffff097          	auipc	ra,0xfffff
    80002594:	86a080e7          	jalr	-1942(ra) # 80000dfa <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    80002598:	4c9c                	lw	a5,24(s1)
    8000259a:	fd379be3          	bne	a5,s3,80002570 <wakeup+0x2a>
    8000259e:	709c                	ld	a5,32(s1)
    800025a0:	fd4798e3          	bne	a5,s4,80002570 <wakeup+0x2a>
        p->state = RUNNABLE;
    800025a4:	0154ac23          	sw	s5,24(s1)
    800025a8:	b7e1                	j	80002570 <wakeup+0x2a>
    }
  }
}
    800025aa:	70e2                	ld	ra,56(sp)
    800025ac:	7442                	ld	s0,48(sp)
    800025ae:	74a2                	ld	s1,40(sp)
    800025b0:	7902                	ld	s2,32(sp)
    800025b2:	69e2                	ld	s3,24(sp)
    800025b4:	6a42                	ld	s4,16(sp)
    800025b6:	6aa2                	ld	s5,8(sp)
    800025b8:	6121                	addi	sp,sp,64
    800025ba:	8082                	ret

00000000800025bc <reparent>:
{
    800025bc:	7179                	addi	sp,sp,-48
    800025be:	f406                	sd	ra,40(sp)
    800025c0:	f022                	sd	s0,32(sp)
    800025c2:	ec26                	sd	s1,24(sp)
    800025c4:	e84a                	sd	s2,16(sp)
    800025c6:	e44e                	sd	s3,8(sp)
    800025c8:	e052                	sd	s4,0(sp)
    800025ca:	1800                	addi	s0,sp,48
    800025cc:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    800025ce:	0022f497          	auipc	s1,0x22f
    800025d2:	a1a48493          	addi	s1,s1,-1510 # 80230fe8 <proc>
      pp->parent = initproc;
    800025d6:	00006a17          	auipc	s4,0x6
    800025da:	352a0a13          	addi	s4,s4,850 # 80008928 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    800025de:	00235997          	auipc	s3,0x235
    800025e2:	e0a98993          	addi	s3,s3,-502 # 802373e8 <tickslock>
    800025e6:	a029                	j	800025f0 <reparent+0x34>
    800025e8:	19048493          	addi	s1,s1,400
    800025ec:	01348d63          	beq	s1,s3,80002606 <reparent+0x4a>
    if (pp->parent == p)
    800025f0:	7c9c                	ld	a5,56(s1)
    800025f2:	ff279be3          	bne	a5,s2,800025e8 <reparent+0x2c>
      pp->parent = initproc;
    800025f6:	000a3503          	ld	a0,0(s4)
    800025fa:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800025fc:	00000097          	auipc	ra,0x0
    80002600:	f4a080e7          	jalr	-182(ra) # 80002546 <wakeup>
    80002604:	b7d5                	j	800025e8 <reparent+0x2c>
}
    80002606:	70a2                	ld	ra,40(sp)
    80002608:	7402                	ld	s0,32(sp)
    8000260a:	64e2                	ld	s1,24(sp)
    8000260c:	6942                	ld	s2,16(sp)
    8000260e:	69a2                	ld	s3,8(sp)
    80002610:	6a02                	ld	s4,0(sp)
    80002612:	6145                	addi	sp,sp,48
    80002614:	8082                	ret

0000000080002616 <exit>:
{
    80002616:	7179                	addi	sp,sp,-48
    80002618:	f406                	sd	ra,40(sp)
    8000261a:	f022                	sd	s0,32(sp)
    8000261c:	ec26                	sd	s1,24(sp)
    8000261e:	e84a                	sd	s2,16(sp)
    80002620:	e44e                	sd	s3,8(sp)
    80002622:	e052                	sd	s4,0(sp)
    80002624:	1800                	addi	s0,sp,48
    80002626:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002628:	fffff097          	auipc	ra,0xfffff
    8000262c:	5e6080e7          	jalr	1510(ra) # 80001c0e <myproc>
    80002630:	89aa                	mv	s3,a0
  if (p == initproc)
    80002632:	00006797          	auipc	a5,0x6
    80002636:	2f67b783          	ld	a5,758(a5) # 80008928 <initproc>
    8000263a:	0d050493          	addi	s1,a0,208
    8000263e:	15050913          	addi	s2,a0,336
    80002642:	02a79363          	bne	a5,a0,80002668 <exit+0x52>
    panic("init exiting");
    80002646:	00006517          	auipc	a0,0x6
    8000264a:	c6a50513          	addi	a0,a0,-918 # 800082b0 <digits+0x270>
    8000264e:	ffffe097          	auipc	ra,0xffffe
    80002652:	ef0080e7          	jalr	-272(ra) # 8000053e <panic>
      fileclose(f);
    80002656:	00002097          	auipc	ra,0x2
    8000265a:	6ec080e7          	jalr	1772(ra) # 80004d42 <fileclose>
      p->ofile[fd] = 0;
    8000265e:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++)
    80002662:	04a1                	addi	s1,s1,8
    80002664:	01248563          	beq	s1,s2,8000266e <exit+0x58>
    if (p->ofile[fd])
    80002668:	6088                	ld	a0,0(s1)
    8000266a:	f575                	bnez	a0,80002656 <exit+0x40>
    8000266c:	bfdd                	j	80002662 <exit+0x4c>
  begin_op();
    8000266e:	00002097          	auipc	ra,0x2
    80002672:	208080e7          	jalr	520(ra) # 80004876 <begin_op>
  iput(p->cwd);
    80002676:	1509b503          	ld	a0,336(s3)
    8000267a:	00002097          	auipc	ra,0x2
    8000267e:	9f4080e7          	jalr	-1548(ra) # 8000406e <iput>
  end_op();
    80002682:	00002097          	auipc	ra,0x2
    80002686:	274080e7          	jalr	628(ra) # 800048f6 <end_op>
  p->cwd = 0;
    8000268a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000268e:	0022e497          	auipc	s1,0x22e
    80002692:	54248493          	addi	s1,s1,1346 # 80230bd0 <wait_lock>
    80002696:	8526                	mv	a0,s1
    80002698:	ffffe097          	auipc	ra,0xffffe
    8000269c:	762080e7          	jalr	1890(ra) # 80000dfa <acquire>
  reparent(p);
    800026a0:	854e                	mv	a0,s3
    800026a2:	00000097          	auipc	ra,0x0
    800026a6:	f1a080e7          	jalr	-230(ra) # 800025bc <reparent>
  wakeup(p->parent);
    800026aa:	0389b503          	ld	a0,56(s3)
    800026ae:	00000097          	auipc	ra,0x0
    800026b2:	e98080e7          	jalr	-360(ra) # 80002546 <wakeup>
  acquire(&p->lock);
    800026b6:	854e                	mv	a0,s3
    800026b8:	ffffe097          	auipc	ra,0xffffe
    800026bc:	742080e7          	jalr	1858(ra) # 80000dfa <acquire>
  p->xstate = status;
    800026c0:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800026c4:	4795                	li	a5,5
    800026c6:	00f9ac23          	sw	a5,24(s3)
  p->etime = ticks;
    800026ca:	00006797          	auipc	a5,0x6
    800026ce:	2667a783          	lw	a5,614(a5) # 80008930 <ticks>
    800026d2:	16f9a823          	sw	a5,368(s3)
  release(&wait_lock);
    800026d6:	8526                	mv	a0,s1
    800026d8:	ffffe097          	auipc	ra,0xffffe
    800026dc:	7d6080e7          	jalr	2006(ra) # 80000eae <release>
  sched();
    800026e0:	00000097          	auipc	ra,0x0
    800026e4:	c6c080e7          	jalr	-916(ra) # 8000234c <sched>
  panic("zombie exit");
    800026e8:	00006517          	auipc	a0,0x6
    800026ec:	bd850513          	addi	a0,a0,-1064 # 800082c0 <digits+0x280>
    800026f0:	ffffe097          	auipc	ra,0xffffe
    800026f4:	e4e080e7          	jalr	-434(ra) # 8000053e <panic>

00000000800026f8 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    800026f8:	7179                	addi	sp,sp,-48
    800026fa:	f406                	sd	ra,40(sp)
    800026fc:	f022                	sd	s0,32(sp)
    800026fe:	ec26                	sd	s1,24(sp)
    80002700:	e84a                	sd	s2,16(sp)
    80002702:	e44e                	sd	s3,8(sp)
    80002704:	1800                	addi	s0,sp,48
    80002706:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80002708:	0022f497          	auipc	s1,0x22f
    8000270c:	8e048493          	addi	s1,s1,-1824 # 80230fe8 <proc>
    80002710:	00235997          	auipc	s3,0x235
    80002714:	cd898993          	addi	s3,s3,-808 # 802373e8 <tickslock>
  {
    acquire(&p->lock);
    80002718:	8526                	mv	a0,s1
    8000271a:	ffffe097          	auipc	ra,0xffffe
    8000271e:	6e0080e7          	jalr	1760(ra) # 80000dfa <acquire>
    if (p->pid == pid)
    80002722:	589c                	lw	a5,48(s1)
    80002724:	01278d63          	beq	a5,s2,8000273e <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002728:	8526                	mv	a0,s1
    8000272a:	ffffe097          	auipc	ra,0xffffe
    8000272e:	784080e7          	jalr	1924(ra) # 80000eae <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002732:	19048493          	addi	s1,s1,400
    80002736:	ff3491e3          	bne	s1,s3,80002718 <kill+0x20>
  }
  return -1;
    8000273a:	557d                	li	a0,-1
    8000273c:	a829                	j	80002756 <kill+0x5e>
      p->killed = 1;
    8000273e:	4785                	li	a5,1
    80002740:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    80002742:	4c98                	lw	a4,24(s1)
    80002744:	4789                	li	a5,2
    80002746:	00f70f63          	beq	a4,a5,80002764 <kill+0x6c>
      release(&p->lock);
    8000274a:	8526                	mv	a0,s1
    8000274c:	ffffe097          	auipc	ra,0xffffe
    80002750:	762080e7          	jalr	1890(ra) # 80000eae <release>
      return 0;
    80002754:	4501                	li	a0,0
}
    80002756:	70a2                	ld	ra,40(sp)
    80002758:	7402                	ld	s0,32(sp)
    8000275a:	64e2                	ld	s1,24(sp)
    8000275c:	6942                	ld	s2,16(sp)
    8000275e:	69a2                	ld	s3,8(sp)
    80002760:	6145                	addi	sp,sp,48
    80002762:	8082                	ret
        p->state = RUNNABLE;
    80002764:	478d                	li	a5,3
    80002766:	cc9c                	sw	a5,24(s1)
    80002768:	b7cd                	j	8000274a <kill+0x52>

000000008000276a <setkilled>:

void setkilled(struct proc *p)
{
    8000276a:	1101                	addi	sp,sp,-32
    8000276c:	ec06                	sd	ra,24(sp)
    8000276e:	e822                	sd	s0,16(sp)
    80002770:	e426                	sd	s1,8(sp)
    80002772:	1000                	addi	s0,sp,32
    80002774:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002776:	ffffe097          	auipc	ra,0xffffe
    8000277a:	684080e7          	jalr	1668(ra) # 80000dfa <acquire>
  p->killed = 1;
    8000277e:	4785                	li	a5,1
    80002780:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002782:	8526                	mv	a0,s1
    80002784:	ffffe097          	auipc	ra,0xffffe
    80002788:	72a080e7          	jalr	1834(ra) # 80000eae <release>
}
    8000278c:	60e2                	ld	ra,24(sp)
    8000278e:	6442                	ld	s0,16(sp)
    80002790:	64a2                	ld	s1,8(sp)
    80002792:	6105                	addi	sp,sp,32
    80002794:	8082                	ret

0000000080002796 <killed>:

int killed(struct proc *p)
{
    80002796:	1101                	addi	sp,sp,-32
    80002798:	ec06                	sd	ra,24(sp)
    8000279a:	e822                	sd	s0,16(sp)
    8000279c:	e426                	sd	s1,8(sp)
    8000279e:	e04a                	sd	s2,0(sp)
    800027a0:	1000                	addi	s0,sp,32
    800027a2:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    800027a4:	ffffe097          	auipc	ra,0xffffe
    800027a8:	656080e7          	jalr	1622(ra) # 80000dfa <acquire>
  k = p->killed;
    800027ac:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800027b0:	8526                	mv	a0,s1
    800027b2:	ffffe097          	auipc	ra,0xffffe
    800027b6:	6fc080e7          	jalr	1788(ra) # 80000eae <release>
  return k;
}
    800027ba:	854a                	mv	a0,s2
    800027bc:	60e2                	ld	ra,24(sp)
    800027be:	6442                	ld	s0,16(sp)
    800027c0:	64a2                	ld	s1,8(sp)
    800027c2:	6902                	ld	s2,0(sp)
    800027c4:	6105                	addi	sp,sp,32
    800027c6:	8082                	ret

00000000800027c8 <wait>:
{
    800027c8:	715d                	addi	sp,sp,-80
    800027ca:	e486                	sd	ra,72(sp)
    800027cc:	e0a2                	sd	s0,64(sp)
    800027ce:	fc26                	sd	s1,56(sp)
    800027d0:	f84a                	sd	s2,48(sp)
    800027d2:	f44e                	sd	s3,40(sp)
    800027d4:	f052                	sd	s4,32(sp)
    800027d6:	ec56                	sd	s5,24(sp)
    800027d8:	e85a                	sd	s6,16(sp)
    800027da:	e45e                	sd	s7,8(sp)
    800027dc:	e062                	sd	s8,0(sp)
    800027de:	0880                	addi	s0,sp,80
    800027e0:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800027e2:	fffff097          	auipc	ra,0xfffff
    800027e6:	42c080e7          	jalr	1068(ra) # 80001c0e <myproc>
    800027ea:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800027ec:	0022e517          	auipc	a0,0x22e
    800027f0:	3e450513          	addi	a0,a0,996 # 80230bd0 <wait_lock>
    800027f4:	ffffe097          	auipc	ra,0xffffe
    800027f8:	606080e7          	jalr	1542(ra) # 80000dfa <acquire>
    havekids = 0;
    800027fc:	4b81                	li	s7,0
        if (pp->state == ZOMBIE)
    800027fe:	4a15                	li	s4,5
        havekids = 1;
    80002800:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002802:	00235997          	auipc	s3,0x235
    80002806:	be698993          	addi	s3,s3,-1050 # 802373e8 <tickslock>
    sleep(p, &wait_lock); // DOC: wait-sleep
    8000280a:	0022ec17          	auipc	s8,0x22e
    8000280e:	3c6c0c13          	addi	s8,s8,966 # 80230bd0 <wait_lock>
    havekids = 0;
    80002812:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002814:	0022e497          	auipc	s1,0x22e
    80002818:	7d448493          	addi	s1,s1,2004 # 80230fe8 <proc>
    8000281c:	a0bd                	j	8000288a <wait+0xc2>
          pid = pp->pid;
    8000281e:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002822:	000b0e63          	beqz	s6,8000283e <wait+0x76>
    80002826:	4691                	li	a3,4
    80002828:	02c48613          	addi	a2,s1,44
    8000282c:	85da                	mv	a1,s6
    8000282e:	05093503          	ld	a0,80(s2)
    80002832:	fffff097          	auipc	ra,0xfffff
    80002836:	060080e7          	jalr	96(ra) # 80001892 <copyout>
    8000283a:	02054563          	bltz	a0,80002864 <wait+0x9c>
          freeproc(pp);
    8000283e:	8526                	mv	a0,s1
    80002840:	fffff097          	auipc	ra,0xfffff
    80002844:	580080e7          	jalr	1408(ra) # 80001dc0 <freeproc>
          release(&pp->lock);
    80002848:	8526                	mv	a0,s1
    8000284a:	ffffe097          	auipc	ra,0xffffe
    8000284e:	664080e7          	jalr	1636(ra) # 80000eae <release>
          release(&wait_lock);
    80002852:	0022e517          	auipc	a0,0x22e
    80002856:	37e50513          	addi	a0,a0,894 # 80230bd0 <wait_lock>
    8000285a:	ffffe097          	auipc	ra,0xffffe
    8000285e:	654080e7          	jalr	1620(ra) # 80000eae <release>
          return pid;
    80002862:	a0b5                	j	800028ce <wait+0x106>
            release(&pp->lock);
    80002864:	8526                	mv	a0,s1
    80002866:	ffffe097          	auipc	ra,0xffffe
    8000286a:	648080e7          	jalr	1608(ra) # 80000eae <release>
            release(&wait_lock);
    8000286e:	0022e517          	auipc	a0,0x22e
    80002872:	36250513          	addi	a0,a0,866 # 80230bd0 <wait_lock>
    80002876:	ffffe097          	auipc	ra,0xffffe
    8000287a:	638080e7          	jalr	1592(ra) # 80000eae <release>
            return -1;
    8000287e:	59fd                	li	s3,-1
    80002880:	a0b9                	j	800028ce <wait+0x106>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002882:	19048493          	addi	s1,s1,400
    80002886:	03348463          	beq	s1,s3,800028ae <wait+0xe6>
      if (pp->parent == p)
    8000288a:	7c9c                	ld	a5,56(s1)
    8000288c:	ff279be3          	bne	a5,s2,80002882 <wait+0xba>
        acquire(&pp->lock);
    80002890:	8526                	mv	a0,s1
    80002892:	ffffe097          	auipc	ra,0xffffe
    80002896:	568080e7          	jalr	1384(ra) # 80000dfa <acquire>
        if (pp->state == ZOMBIE)
    8000289a:	4c9c                	lw	a5,24(s1)
    8000289c:	f94781e3          	beq	a5,s4,8000281e <wait+0x56>
        release(&pp->lock);
    800028a0:	8526                	mv	a0,s1
    800028a2:	ffffe097          	auipc	ra,0xffffe
    800028a6:	60c080e7          	jalr	1548(ra) # 80000eae <release>
        havekids = 1;
    800028aa:	8756                	mv	a4,s5
    800028ac:	bfd9                	j	80002882 <wait+0xba>
    if (!havekids || killed(p))
    800028ae:	c719                	beqz	a4,800028bc <wait+0xf4>
    800028b0:	854a                	mv	a0,s2
    800028b2:	00000097          	auipc	ra,0x0
    800028b6:	ee4080e7          	jalr	-284(ra) # 80002796 <killed>
    800028ba:	c51d                	beqz	a0,800028e8 <wait+0x120>
      release(&wait_lock);
    800028bc:	0022e517          	auipc	a0,0x22e
    800028c0:	31450513          	addi	a0,a0,788 # 80230bd0 <wait_lock>
    800028c4:	ffffe097          	auipc	ra,0xffffe
    800028c8:	5ea080e7          	jalr	1514(ra) # 80000eae <release>
      return -1;
    800028cc:	59fd                	li	s3,-1
}
    800028ce:	854e                	mv	a0,s3
    800028d0:	60a6                	ld	ra,72(sp)
    800028d2:	6406                	ld	s0,64(sp)
    800028d4:	74e2                	ld	s1,56(sp)
    800028d6:	7942                	ld	s2,48(sp)
    800028d8:	79a2                	ld	s3,40(sp)
    800028da:	7a02                	ld	s4,32(sp)
    800028dc:	6ae2                	ld	s5,24(sp)
    800028de:	6b42                	ld	s6,16(sp)
    800028e0:	6ba2                	ld	s7,8(sp)
    800028e2:	6c02                	ld	s8,0(sp)
    800028e4:	6161                	addi	sp,sp,80
    800028e6:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    800028e8:	85e2                	mv	a1,s8
    800028ea:	854a                	mv	a0,s2
    800028ec:	00000097          	auipc	ra,0x0
    800028f0:	bf6080e7          	jalr	-1034(ra) # 800024e2 <sleep>
    havekids = 0;
    800028f4:	bf39                	j	80002812 <wait+0x4a>

00000000800028f6 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800028f6:	7179                	addi	sp,sp,-48
    800028f8:	f406                	sd	ra,40(sp)
    800028fa:	f022                	sd	s0,32(sp)
    800028fc:	ec26                	sd	s1,24(sp)
    800028fe:	e84a                	sd	s2,16(sp)
    80002900:	e44e                	sd	s3,8(sp)
    80002902:	e052                	sd	s4,0(sp)
    80002904:	1800                	addi	s0,sp,48
    80002906:	84aa                	mv	s1,a0
    80002908:	892e                	mv	s2,a1
    8000290a:	89b2                	mv	s3,a2
    8000290c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000290e:	fffff097          	auipc	ra,0xfffff
    80002912:	300080e7          	jalr	768(ra) # 80001c0e <myproc>
  if (user_dst)
    80002916:	c08d                	beqz	s1,80002938 <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    80002918:	86d2                	mv	a3,s4
    8000291a:	864e                	mv	a2,s3
    8000291c:	85ca                	mv	a1,s2
    8000291e:	6928                	ld	a0,80(a0)
    80002920:	fffff097          	auipc	ra,0xfffff
    80002924:	f72080e7          	jalr	-142(ra) # 80001892 <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002928:	70a2                	ld	ra,40(sp)
    8000292a:	7402                	ld	s0,32(sp)
    8000292c:	64e2                	ld	s1,24(sp)
    8000292e:	6942                	ld	s2,16(sp)
    80002930:	69a2                	ld	s3,8(sp)
    80002932:	6a02                	ld	s4,0(sp)
    80002934:	6145                	addi	sp,sp,48
    80002936:	8082                	ret
    memmove((char *)dst, src, len);
    80002938:	000a061b          	sext.w	a2,s4
    8000293c:	85ce                	mv	a1,s3
    8000293e:	854a                	mv	a0,s2
    80002940:	ffffe097          	auipc	ra,0xffffe
    80002944:	612080e7          	jalr	1554(ra) # 80000f52 <memmove>
    return 0;
    80002948:	8526                	mv	a0,s1
    8000294a:	bff9                	j	80002928 <either_copyout+0x32>

000000008000294c <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000294c:	7179                	addi	sp,sp,-48
    8000294e:	f406                	sd	ra,40(sp)
    80002950:	f022                	sd	s0,32(sp)
    80002952:	ec26                	sd	s1,24(sp)
    80002954:	e84a                	sd	s2,16(sp)
    80002956:	e44e                	sd	s3,8(sp)
    80002958:	e052                	sd	s4,0(sp)
    8000295a:	1800                	addi	s0,sp,48
    8000295c:	892a                	mv	s2,a0
    8000295e:	84ae                	mv	s1,a1
    80002960:	89b2                	mv	s3,a2
    80002962:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002964:	fffff097          	auipc	ra,0xfffff
    80002968:	2aa080e7          	jalr	682(ra) # 80001c0e <myproc>
  if (user_src)
    8000296c:	c08d                	beqz	s1,8000298e <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    8000296e:	86d2                	mv	a3,s4
    80002970:	864e                	mv	a2,s3
    80002972:	85ca                	mv	a1,s2
    80002974:	6928                	ld	a0,80(a0)
    80002976:	fffff097          	auipc	ra,0xfffff
    8000297a:	fe0080e7          	jalr	-32(ra) # 80001956 <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    8000297e:	70a2                	ld	ra,40(sp)
    80002980:	7402                	ld	s0,32(sp)
    80002982:	64e2                	ld	s1,24(sp)
    80002984:	6942                	ld	s2,16(sp)
    80002986:	69a2                	ld	s3,8(sp)
    80002988:	6a02                	ld	s4,0(sp)
    8000298a:	6145                	addi	sp,sp,48
    8000298c:	8082                	ret
    memmove(dst, (char *)src, len);
    8000298e:	000a061b          	sext.w	a2,s4
    80002992:	85ce                	mv	a1,s3
    80002994:	854a                	mv	a0,s2
    80002996:	ffffe097          	auipc	ra,0xffffe
    8000299a:	5bc080e7          	jalr	1468(ra) # 80000f52 <memmove>
    return 0;
    8000299e:	8526                	mv	a0,s1
    800029a0:	bff9                	j	8000297e <either_copyin+0x32>

00000000800029a2 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800029a2:	715d                	addi	sp,sp,-80
    800029a4:	e486                	sd	ra,72(sp)
    800029a6:	e0a2                	sd	s0,64(sp)
    800029a8:	fc26                	sd	s1,56(sp)
    800029aa:	f84a                	sd	s2,48(sp)
    800029ac:	f44e                	sd	s3,40(sp)
    800029ae:	f052                	sd	s4,32(sp)
    800029b0:	ec56                	sd	s5,24(sp)
    800029b2:	e85a                	sd	s6,16(sp)
    800029b4:	e45e                	sd	s7,8(sp)
    800029b6:	e062                	sd	s8,0(sp)
    800029b8:	0880                	addi	s0,sp,80
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    800029ba:	00005517          	auipc	a0,0x5
    800029be:	75e50513          	addi	a0,a0,1886 # 80008118 <digits+0xd8>
    800029c2:	ffffe097          	auipc	ra,0xffffe
    800029c6:	bc6080e7          	jalr	-1082(ra) # 80000588 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    800029ca:	0022e497          	auipc	s1,0x22e
    800029ce:	61e48493          	addi	s1,s1,1566 # 80230fe8 <proc>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029d2:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800029d4:	00006997          	auipc	s3,0x6
    800029d8:	8fc98993          	addi	s3,s3,-1796 # 800082d0 <digits+0x290>
    // printf("%d %s %s", p->pid, state, p->name);·
    dp_calculator(p);
    printf("%d %s %d %d %d %d", p->pid, state, p->RTime, p->WTime, p->STime, p->DPriority);
    800029dc:	00006a97          	auipc	s5,0x6
    800029e0:	8fca8a93          	addi	s5,s5,-1796 # 800082d8 <digits+0x298>
    printf("\n");
    800029e4:	00005a17          	auipc	s4,0x5
    800029e8:	734a0a13          	addi	s4,s4,1844 # 80008118 <digits+0xd8>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029ec:	00006b97          	auipc	s7,0x6
    800029f0:	934b8b93          	addi	s7,s7,-1740 # 80008320 <states.0>
  for (p = proc; p < &proc[NPROC]; p++)
    800029f4:	00235917          	auipc	s2,0x235
    800029f8:	9f490913          	addi	s2,s2,-1548 # 802373e8 <tickslock>
    800029fc:	a835                	j	80002a38 <procdump+0x96>
    dp_calculator(p);
    800029fe:	8526                	mv	a0,s1
    80002a00:	fffff097          	auipc	ra,0xfffff
    80002a04:	73e080e7          	jalr	1854(ra) # 8000213e <dp_calculator>
    printf("%d %s %d %d %d %d", p->pid, state, p->RTime, p->WTime, p->STime, p->DPriority);
    80002a08:	1784a803          	lw	a6,376(s1)
    80002a0c:	1844a783          	lw	a5,388(s1)
    80002a10:	1884a703          	lw	a4,392(s1)
    80002a14:	17c4a683          	lw	a3,380(s1)
    80002a18:	8662                	mv	a2,s8
    80002a1a:	588c                	lw	a1,48(s1)
    80002a1c:	8556                	mv	a0,s5
    80002a1e:	ffffe097          	auipc	ra,0xffffe
    80002a22:	b6a080e7          	jalr	-1174(ra) # 80000588 <printf>
    printf("\n");
    80002a26:	8552                	mv	a0,s4
    80002a28:	ffffe097          	auipc	ra,0xffffe
    80002a2c:	b60080e7          	jalr	-1184(ra) # 80000588 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80002a30:	19048493          	addi	s1,s1,400
    80002a34:	03248163          	beq	s1,s2,80002a56 <procdump+0xb4>
    if (p->state == UNUSED)
    80002a38:	4c9c                	lw	a5,24(s1)
    80002a3a:	dbfd                	beqz	a5,80002a30 <procdump+0x8e>
      state = "???";
    80002a3c:	8c4e                	mv	s8,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a3e:	fcfb60e3          	bltu	s6,a5,800029fe <procdump+0x5c>
    80002a42:	1782                	slli	a5,a5,0x20
    80002a44:	9381                	srli	a5,a5,0x20
    80002a46:	078e                	slli	a5,a5,0x3
    80002a48:	97de                	add	a5,a5,s7
    80002a4a:	0007bc03          	ld	s8,0(a5)
    80002a4e:	fa0c18e3          	bnez	s8,800029fe <procdump+0x5c>
      state = "???";
    80002a52:	8c4e                	mv	s8,s3
    80002a54:	b76d                	j	800029fe <procdump+0x5c>
  }
}
    80002a56:	60a6                	ld	ra,72(sp)
    80002a58:	6406                	ld	s0,64(sp)
    80002a5a:	74e2                	ld	s1,56(sp)
    80002a5c:	7942                	ld	s2,48(sp)
    80002a5e:	79a2                	ld	s3,40(sp)
    80002a60:	7a02                	ld	s4,32(sp)
    80002a62:	6ae2                	ld	s5,24(sp)
    80002a64:	6b42                	ld	s6,16(sp)
    80002a66:	6ba2                	ld	s7,8(sp)
    80002a68:	6c02                	ld	s8,0(sp)
    80002a6a:	6161                	addi	sp,sp,80
    80002a6c:	8082                	ret

0000000080002a6e <waitx>:

// waitx
int waitx(uint64 addr, uint *wtime, uint *rtime)
{
    80002a6e:	711d                	addi	sp,sp,-96
    80002a70:	ec86                	sd	ra,88(sp)
    80002a72:	e8a2                	sd	s0,80(sp)
    80002a74:	e4a6                	sd	s1,72(sp)
    80002a76:	e0ca                	sd	s2,64(sp)
    80002a78:	fc4e                	sd	s3,56(sp)
    80002a7a:	f852                	sd	s4,48(sp)
    80002a7c:	f456                	sd	s5,40(sp)
    80002a7e:	f05a                	sd	s6,32(sp)
    80002a80:	ec5e                	sd	s7,24(sp)
    80002a82:	e862                	sd	s8,16(sp)
    80002a84:	e466                	sd	s9,8(sp)
    80002a86:	e06a                	sd	s10,0(sp)
    80002a88:	1080                	addi	s0,sp,96
    80002a8a:	8b2a                	mv	s6,a0
    80002a8c:	8bae                	mv	s7,a1
    80002a8e:	8c32                	mv	s8,a2
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();
    80002a90:	fffff097          	auipc	ra,0xfffff
    80002a94:	17e080e7          	jalr	382(ra) # 80001c0e <myproc>
    80002a98:	892a                	mv	s2,a0

  acquire(&wait_lock);
    80002a9a:	0022e517          	auipc	a0,0x22e
    80002a9e:	13650513          	addi	a0,a0,310 # 80230bd0 <wait_lock>
    80002aa2:	ffffe097          	auipc	ra,0xffffe
    80002aa6:	358080e7          	jalr	856(ra) # 80000dfa <acquire>

  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    80002aaa:	4c81                	li	s9,0
      {
        // make sure the child isn't still in exit() or swtch().
        acquire(&np->lock);

        havekids = 1;
        if (np->state == ZOMBIE)
    80002aac:	4a15                	li	s4,5
        havekids = 1;
    80002aae:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++)
    80002ab0:	00235997          	auipc	s3,0x235
    80002ab4:	93898993          	addi	s3,s3,-1736 # 802373e8 <tickslock>
      release(&wait_lock);
      return -1;
    }

    // Wait for a child to exit.
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002ab8:	0022ed17          	auipc	s10,0x22e
    80002abc:	118d0d13          	addi	s10,s10,280 # 80230bd0 <wait_lock>
    havekids = 0;
    80002ac0:	8766                	mv	a4,s9
    for (np = proc; np < &proc[NPROC]; np++)
    80002ac2:	0022e497          	auipc	s1,0x22e
    80002ac6:	52648493          	addi	s1,s1,1318 # 80230fe8 <proc>
    80002aca:	a059                	j	80002b50 <waitx+0xe2>
          pid = np->pid;
    80002acc:	0304a983          	lw	s3,48(s1)
          *rtime = np->rtime;
    80002ad0:	1684a703          	lw	a4,360(s1)
    80002ad4:	00ec2023          	sw	a4,0(s8)
          *wtime = np->etime - np->ctime - np->rtime;
    80002ad8:	16c4a783          	lw	a5,364(s1)
    80002adc:	9f3d                	addw	a4,a4,a5
    80002ade:	1704a783          	lw	a5,368(s1)
    80002ae2:	9f99                	subw	a5,a5,a4
    80002ae4:	00fba023          	sw	a5,0(s7)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002ae8:	000b0e63          	beqz	s6,80002b04 <waitx+0x96>
    80002aec:	4691                	li	a3,4
    80002aee:	02c48613          	addi	a2,s1,44
    80002af2:	85da                	mv	a1,s6
    80002af4:	05093503          	ld	a0,80(s2)
    80002af8:	fffff097          	auipc	ra,0xfffff
    80002afc:	d9a080e7          	jalr	-614(ra) # 80001892 <copyout>
    80002b00:	02054563          	bltz	a0,80002b2a <waitx+0xbc>
          freeproc(np);
    80002b04:	8526                	mv	a0,s1
    80002b06:	fffff097          	auipc	ra,0xfffff
    80002b0a:	2ba080e7          	jalr	698(ra) # 80001dc0 <freeproc>
          release(&np->lock);
    80002b0e:	8526                	mv	a0,s1
    80002b10:	ffffe097          	auipc	ra,0xffffe
    80002b14:	39e080e7          	jalr	926(ra) # 80000eae <release>
          release(&wait_lock);
    80002b18:	0022e517          	auipc	a0,0x22e
    80002b1c:	0b850513          	addi	a0,a0,184 # 80230bd0 <wait_lock>
    80002b20:	ffffe097          	auipc	ra,0xffffe
    80002b24:	38e080e7          	jalr	910(ra) # 80000eae <release>
          return pid;
    80002b28:	a09d                	j	80002b8e <waitx+0x120>
            release(&np->lock);
    80002b2a:	8526                	mv	a0,s1
    80002b2c:	ffffe097          	auipc	ra,0xffffe
    80002b30:	382080e7          	jalr	898(ra) # 80000eae <release>
            release(&wait_lock);
    80002b34:	0022e517          	auipc	a0,0x22e
    80002b38:	09c50513          	addi	a0,a0,156 # 80230bd0 <wait_lock>
    80002b3c:	ffffe097          	auipc	ra,0xffffe
    80002b40:	372080e7          	jalr	882(ra) # 80000eae <release>
            return -1;
    80002b44:	59fd                	li	s3,-1
    80002b46:	a0a1                	j	80002b8e <waitx+0x120>
    for (np = proc; np < &proc[NPROC]; np++)
    80002b48:	19048493          	addi	s1,s1,400
    80002b4c:	03348463          	beq	s1,s3,80002b74 <waitx+0x106>
      if (np->parent == p)
    80002b50:	7c9c                	ld	a5,56(s1)
    80002b52:	ff279be3          	bne	a5,s2,80002b48 <waitx+0xda>
        acquire(&np->lock);
    80002b56:	8526                	mv	a0,s1
    80002b58:	ffffe097          	auipc	ra,0xffffe
    80002b5c:	2a2080e7          	jalr	674(ra) # 80000dfa <acquire>
        if (np->state == ZOMBIE)
    80002b60:	4c9c                	lw	a5,24(s1)
    80002b62:	f74785e3          	beq	a5,s4,80002acc <waitx+0x5e>
        release(&np->lock);
    80002b66:	8526                	mv	a0,s1
    80002b68:	ffffe097          	auipc	ra,0xffffe
    80002b6c:	346080e7          	jalr	838(ra) # 80000eae <release>
        havekids = 1;
    80002b70:	8756                	mv	a4,s5
    80002b72:	bfd9                	j	80002b48 <waitx+0xda>
    if (!havekids || p->killed)
    80002b74:	c701                	beqz	a4,80002b7c <waitx+0x10e>
    80002b76:	02892783          	lw	a5,40(s2)
    80002b7a:	cb8d                	beqz	a5,80002bac <waitx+0x13e>
      release(&wait_lock);
    80002b7c:	0022e517          	auipc	a0,0x22e
    80002b80:	05450513          	addi	a0,a0,84 # 80230bd0 <wait_lock>
    80002b84:	ffffe097          	auipc	ra,0xffffe
    80002b88:	32a080e7          	jalr	810(ra) # 80000eae <release>
      return -1;
    80002b8c:	59fd                	li	s3,-1
  }
}
    80002b8e:	854e                	mv	a0,s3
    80002b90:	60e6                	ld	ra,88(sp)
    80002b92:	6446                	ld	s0,80(sp)
    80002b94:	64a6                	ld	s1,72(sp)
    80002b96:	6906                	ld	s2,64(sp)
    80002b98:	79e2                	ld	s3,56(sp)
    80002b9a:	7a42                	ld	s4,48(sp)
    80002b9c:	7aa2                	ld	s5,40(sp)
    80002b9e:	7b02                	ld	s6,32(sp)
    80002ba0:	6be2                	ld	s7,24(sp)
    80002ba2:	6c42                	ld	s8,16(sp)
    80002ba4:	6ca2                	ld	s9,8(sp)
    80002ba6:	6d02                	ld	s10,0(sp)
    80002ba8:	6125                	addi	sp,sp,96
    80002baa:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002bac:	85ea                	mv	a1,s10
    80002bae:	854a                	mv	a0,s2
    80002bb0:	00000097          	auipc	ra,0x0
    80002bb4:	932080e7          	jalr	-1742(ra) # 800024e2 <sleep>
    havekids = 0;
    80002bb8:	b721                	j	80002ac0 <waitx+0x52>

0000000080002bba <update_time>:

void update_time()
{
    80002bba:	7139                	addi	sp,sp,-64
    80002bbc:	fc06                	sd	ra,56(sp)
    80002bbe:	f822                	sd	s0,48(sp)
    80002bc0:	f426                	sd	s1,40(sp)
    80002bc2:	f04a                	sd	s2,32(sp)
    80002bc4:	ec4e                	sd	s3,24(sp)
    80002bc6:	e852                	sd	s4,16(sp)
    80002bc8:	e456                	sd	s5,8(sp)
    80002bca:	0080                	addi	s0,sp,64
  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++)
    80002bcc:	0022e497          	auipc	s1,0x22e
    80002bd0:	41c48493          	addi	s1,s1,1052 # 80230fe8 <proc>
  {
    acquire(&p->lock);
    if (p->state == RUNNING)
    80002bd4:	4991                	li	s3,4
    {
      p->RTime++;
      p->rtime++;
    }
    else if (p->state == SLEEPING)
    80002bd6:	4a09                	li	s4,2
    {
      p->STime++;
    }
    else if (p->state == RUNNABLE)
    80002bd8:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    80002bda:	00235917          	auipc	s2,0x235
    80002bde:	80e90913          	addi	s2,s2,-2034 # 802373e8 <tickslock>
    80002be2:	a025                	j	80002c0a <update_time+0x50>
      p->RTime++;
    80002be4:	17c4a783          	lw	a5,380(s1)
    80002be8:	2785                	addiw	a5,a5,1
    80002bea:	16f4ae23          	sw	a5,380(s1)
      p->rtime++;
    80002bee:	1684a783          	lw	a5,360(s1)
    80002bf2:	2785                	addiw	a5,a5,1
    80002bf4:	16f4a423          	sw	a5,360(s1)
    {
      p->WTime++;
    }
    release(&p->lock);
    80002bf8:	8526                	mv	a0,s1
    80002bfa:	ffffe097          	auipc	ra,0xffffe
    80002bfe:	2b4080e7          	jalr	692(ra) # 80000eae <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002c02:	19048493          	addi	s1,s1,400
    80002c06:	03248a63          	beq	s1,s2,80002c3a <update_time+0x80>
    acquire(&p->lock);
    80002c0a:	8526                	mv	a0,s1
    80002c0c:	ffffe097          	auipc	ra,0xffffe
    80002c10:	1ee080e7          	jalr	494(ra) # 80000dfa <acquire>
    if (p->state == RUNNING)
    80002c14:	4c9c                	lw	a5,24(s1)
    80002c16:	fd3787e3          	beq	a5,s3,80002be4 <update_time+0x2a>
    else if (p->state == SLEEPING)
    80002c1a:	01478a63          	beq	a5,s4,80002c2e <update_time+0x74>
    else if (p->state == RUNNABLE)
    80002c1e:	fd579de3          	bne	a5,s5,80002bf8 <update_time+0x3e>
      p->WTime++;
    80002c22:	1884a783          	lw	a5,392(s1)
    80002c26:	2785                	addiw	a5,a5,1
    80002c28:	18f4a423          	sw	a5,392(s1)
    80002c2c:	b7f1                	j	80002bf8 <update_time+0x3e>
      p->STime++;
    80002c2e:	1844a783          	lw	a5,388(s1)
    80002c32:	2785                	addiw	a5,a5,1
    80002c34:	18f4a223          	sw	a5,388(s1)
    80002c38:	b7c1                	j	80002bf8 <update_time+0x3e>
  }
    80002c3a:	70e2                	ld	ra,56(sp)
    80002c3c:	7442                	ld	s0,48(sp)
    80002c3e:	74a2                	ld	s1,40(sp)
    80002c40:	7902                	ld	s2,32(sp)
    80002c42:	69e2                	ld	s3,24(sp)
    80002c44:	6a42                	ld	s4,16(sp)
    80002c46:	6aa2                	ld	s5,8(sp)
    80002c48:	6121                	addi	sp,sp,64
    80002c4a:	8082                	ret

0000000080002c4c <swtch>:
    80002c4c:	00153023          	sd	ra,0(a0)
    80002c50:	00253423          	sd	sp,8(a0)
    80002c54:	e900                	sd	s0,16(a0)
    80002c56:	ed04                	sd	s1,24(a0)
    80002c58:	03253023          	sd	s2,32(a0)
    80002c5c:	03353423          	sd	s3,40(a0)
    80002c60:	03453823          	sd	s4,48(a0)
    80002c64:	03553c23          	sd	s5,56(a0)
    80002c68:	05653023          	sd	s6,64(a0)
    80002c6c:	05753423          	sd	s7,72(a0)
    80002c70:	05853823          	sd	s8,80(a0)
    80002c74:	05953c23          	sd	s9,88(a0)
    80002c78:	07a53023          	sd	s10,96(a0)
    80002c7c:	07b53423          	sd	s11,104(a0)
    80002c80:	0005b083          	ld	ra,0(a1)
    80002c84:	0085b103          	ld	sp,8(a1)
    80002c88:	6980                	ld	s0,16(a1)
    80002c8a:	6d84                	ld	s1,24(a1)
    80002c8c:	0205b903          	ld	s2,32(a1)
    80002c90:	0285b983          	ld	s3,40(a1)
    80002c94:	0305ba03          	ld	s4,48(a1)
    80002c98:	0385ba83          	ld	s5,56(a1)
    80002c9c:	0405bb03          	ld	s6,64(a1)
    80002ca0:	0485bb83          	ld	s7,72(a1)
    80002ca4:	0505bc03          	ld	s8,80(a1)
    80002ca8:	0585bc83          	ld	s9,88(a1)
    80002cac:	0605bd03          	ld	s10,96(a1)
    80002cb0:	0685bd83          	ld	s11,104(a1)
    80002cb4:	8082                	ret

0000000080002cb6 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002cb6:	1141                	addi	sp,sp,-16
    80002cb8:	e406                	sd	ra,8(sp)
    80002cba:	e022                	sd	s0,0(sp)
    80002cbc:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002cbe:	00005597          	auipc	a1,0x5
    80002cc2:	69258593          	addi	a1,a1,1682 # 80008350 <states.0+0x30>
    80002cc6:	00234517          	auipc	a0,0x234
    80002cca:	72250513          	addi	a0,a0,1826 # 802373e8 <tickslock>
    80002cce:	ffffe097          	auipc	ra,0xffffe
    80002cd2:	09c080e7          	jalr	156(ra) # 80000d6a <initlock>
}
    80002cd6:	60a2                	ld	ra,8(sp)
    80002cd8:	6402                	ld	s0,0(sp)
    80002cda:	0141                	addi	sp,sp,16
    80002cdc:	8082                	ret

0000000080002cde <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002cde:	1141                	addi	sp,sp,-16
    80002ce0:	e422                	sd	s0,8(sp)
    80002ce2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002ce4:	00003797          	auipc	a5,0x3
    80002ce8:	6cc78793          	addi	a5,a5,1740 # 800063b0 <kernelvec>
    80002cec:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002cf0:	6422                	ld	s0,8(sp)
    80002cf2:	0141                	addi	sp,sp,16
    80002cf4:	8082                	ret

0000000080002cf6 <handle_page>:

// }

// return -1 or -2 on error and 0 on sucess
int handle_page(uint64 pg_fault_addr, pagetable_t pagetable)
{
    80002cf6:	7179                	addi	sp,sp,-48
    80002cf8:	f406                	sd	ra,40(sp)
    80002cfa:	f022                	sd	s0,32(sp)
    80002cfc:	ec26                	sd	s1,24(sp)
    80002cfe:	e84a                	sd	s2,16(sp)
    80002d00:	e44e                	sd	s3,8(sp)
    80002d02:	1800                	addi	s0,sp,48
    80002d04:	892a                	mv	s2,a0
    80002d06:	852e                	mv	a0,a1
  pte_t *pte;
  // error handlig copied from uvmcopy fn of vm.c
  if ((pte = walk(pagetable, PGROUNDDOWN(pg_fault_addr), 0)) == 0)
    80002d08:	4601                	li	a2,0
    80002d0a:	75fd                	lui	a1,0xfffff
    80002d0c:	00b975b3          	and	a1,s2,a1
    80002d10:	ffffe097          	auipc	ra,0xffffe
    80002d14:	4ca080e7          	jalr	1226(ra) # 800011da <walk>
    80002d18:	c929                	beqz	a0,80002d6a <handle_page+0x74>
    80002d1a:	84aa                	mv	s1,a0
  {
    panic("uvmcopy: pte should exist");
    return -1;
  }
  if ((*pte & PTE_V) == 0)
    80002d1c:	611c                	ld	a5,0(a0)
    80002d1e:	8b85                	andi	a5,a5,1
    80002d20:	cfa9                	beqz	a5,80002d7a <handle_page+0x84>
  {
    panic("uvmcopy: page not present");
    return -1;
  }
  struct proc *p = myproc();
    80002d22:	fffff097          	auipc	ra,0xfffff
    80002d26:	eec080e7          	jalr	-276(ra) # 80001c0e <myproc>
  uint64 val = PGROUNDDOWN(p->trapframe->sp);
    80002d2a:	6d3c                	ld	a5,88(a0)
    80002d2c:	7b98                	ld	a4,48(a5)
    80002d2e:	77fd                	lui	a5,0xfffff
    80002d30:	8ff9                	and	a5,a5,a4
  if (pg_fault_addr >= MAXVA || (pg_fault_addr <= val && pg_fault_addr >= val - PGSIZE))
    80002d32:	577d                	li	a4,-1
    80002d34:	8369                	srli	a4,a4,0x1a
    80002d36:	09276b63          	bltu	a4,s2,80002dcc <handle_page+0xd6>
    80002d3a:	0127e663          	bltu	a5,s2,80002d46 <handle_page+0x50>
    80002d3e:	777d                	lui	a4,0xfffff
    80002d40:	97ba                	add	a5,a5,a4
    80002d42:	08f97763          	bgeu	s2,a5,80002dd0 <handle_page+0xda>
  {
    return -2;
  }
  uint flags;
  uint64 pa;
  pa = PTE2PA(*pte);
    80002d46:	609c                	ld	a5,0(s1)
    80002d48:	00a7d713          	srli	a4,a5,0xa
    80002d4c:	0732                	slli	a4,a4,0xc
  pg_fault_addr = PGROUNDDOWN(pg_fault_addr);
  if (pte == 0 || pa == 0)
    80002d4e:	c359                	beqz	a4,80002dd4 <handle_page+0xde>
  {
    return -1;
  }
  flags = PTE_FLAGS(*pte);
    80002d50:	0007871b          	sext.w	a4,a5
  if (flags & PTE_C)
    80002d54:	1007f793          	andi	a5,a5,256
      return -1;
    memmove(mem, (void *)PTE2PA(*pte), PGSIZE);
    kfree((void *)PTE2PA(*pte));
    *pte = PA2PTE(mem) | flg;
  }
  return 0;
    80002d58:	4501                	li	a0,0
  if (flags & PTE_C)
    80002d5a:	eb85                	bnez	a5,80002d8a <handle_page+0x94>
}
    80002d5c:	70a2                	ld	ra,40(sp)
    80002d5e:	7402                	ld	s0,32(sp)
    80002d60:	64e2                	ld	s1,24(sp)
    80002d62:	6942                	ld	s2,16(sp)
    80002d64:	69a2                	ld	s3,8(sp)
    80002d66:	6145                	addi	sp,sp,48
    80002d68:	8082                	ret
    panic("uvmcopy: pte should exist");
    80002d6a:	00005517          	auipc	a0,0x5
    80002d6e:	46e50513          	addi	a0,a0,1134 # 800081d8 <digits+0x198>
    80002d72:	ffffd097          	auipc	ra,0xffffd
    80002d76:	7cc080e7          	jalr	1996(ra) # 8000053e <panic>
    panic("uvmcopy: page not present");
    80002d7a:	00005517          	auipc	a0,0x5
    80002d7e:	47e50513          	addi	a0,a0,1150 # 800081f8 <digits+0x1b8>
    80002d82:	ffffd097          	auipc	ra,0xffffd
    80002d86:	7bc080e7          	jalr	1980(ra) # 8000053e <panic>
    flg = (flags | PTE_W) & (~PTE_C);
    80002d8a:	2ff77713          	andi	a4,a4,767
    80002d8e:	00476913          	ori	s2,a4,4
    if ((mem = kalloc()) == 0)
    80002d92:	ffffe097          	auipc	ra,0xffffe
    80002d96:	f6c080e7          	jalr	-148(ra) # 80000cfe <kalloc>
    80002d9a:	89aa                	mv	s3,a0
    80002d9c:	cd15                	beqz	a0,80002dd8 <handle_page+0xe2>
    memmove(mem, (void *)PTE2PA(*pte), PGSIZE);
    80002d9e:	608c                	ld	a1,0(s1)
    80002da0:	81a9                	srli	a1,a1,0xa
    80002da2:	6605                	lui	a2,0x1
    80002da4:	05b2                	slli	a1,a1,0xc
    80002da6:	ffffe097          	auipc	ra,0xffffe
    80002daa:	1ac080e7          	jalr	428(ra) # 80000f52 <memmove>
    kfree((void *)PTE2PA(*pte));
    80002dae:	6088                	ld	a0,0(s1)
    80002db0:	8129                	srli	a0,a0,0xa
    80002db2:	0532                	slli	a0,a0,0xc
    80002db4:	ffffe097          	auipc	ra,0xffffe
    80002db8:	dc2080e7          	jalr	-574(ra) # 80000b76 <kfree>
    *pte = PA2PTE(mem) | flg;
    80002dbc:	00c9d713          	srli	a4,s3,0xc
    80002dc0:	072a                	slli	a4,a4,0xa
    80002dc2:	00e96733          	or	a4,s2,a4
    80002dc6:	e098                	sd	a4,0(s1)
  return 0;
    80002dc8:	4501                	li	a0,0
    80002dca:	bf49                	j	80002d5c <handle_page+0x66>
    return -2;
    80002dcc:	5579                	li	a0,-2
    80002dce:	b779                	j	80002d5c <handle_page+0x66>
    80002dd0:	5579                	li	a0,-2
    80002dd2:	b769                	j	80002d5c <handle_page+0x66>
    return -1;
    80002dd4:	557d                	li	a0,-1
    80002dd6:	b759                	j	80002d5c <handle_page+0x66>
      return -1;
    80002dd8:	557d                	li	a0,-1
    80002dda:	b749                	j	80002d5c <handle_page+0x66>

0000000080002ddc <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002ddc:	1141                	addi	sp,sp,-16
    80002dde:	e406                	sd	ra,8(sp)
    80002de0:	e022                	sd	s0,0(sp)
    80002de2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002de4:	fffff097          	auipc	ra,0xfffff
    80002de8:	e2a080e7          	jalr	-470(ra) # 80001c0e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002dec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002df0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002df2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002df6:	00004617          	auipc	a2,0x4
    80002dfa:	20a60613          	addi	a2,a2,522 # 80007000 <_trampoline>
    80002dfe:	00004697          	auipc	a3,0x4
    80002e02:	20268693          	addi	a3,a3,514 # 80007000 <_trampoline>
    80002e06:	8e91                	sub	a3,a3,a2
    80002e08:	040007b7          	lui	a5,0x4000
    80002e0c:	17fd                	addi	a5,a5,-1
    80002e0e:	07b2                	slli	a5,a5,0xc
    80002e10:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002e12:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002e16:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002e18:	180026f3          	csrr	a3,satp
    80002e1c:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002e1e:	6d38                	ld	a4,88(a0)
    80002e20:	6134                	ld	a3,64(a0)
    80002e22:	6585                	lui	a1,0x1
    80002e24:	96ae                	add	a3,a3,a1
    80002e26:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002e28:	6d38                	ld	a4,88(a0)
    80002e2a:	00000697          	auipc	a3,0x0
    80002e2e:	13e68693          	addi	a3,a3,318 # 80002f68 <usertrap>
    80002e32:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002e34:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002e36:	8692                	mv	a3,tp
    80002e38:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e3a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002e3e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002e42:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e46:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002e4a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002e4c:	6f18                	ld	a4,24(a4)
    80002e4e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002e52:	6928                	ld	a0,80(a0)
    80002e54:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002e56:	00004717          	auipc	a4,0x4
    80002e5a:	24670713          	addi	a4,a4,582 # 8000709c <userret>
    80002e5e:	8f11                	sub	a4,a4,a2
    80002e60:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002e62:	577d                	li	a4,-1
    80002e64:	177e                	slli	a4,a4,0x3f
    80002e66:	8d59                	or	a0,a0,a4
    80002e68:	9782                	jalr	a5
}
    80002e6a:	60a2                	ld	ra,8(sp)
    80002e6c:	6402                	ld	s0,0(sp)
    80002e6e:	0141                	addi	sp,sp,16
    80002e70:	8082                	ret

0000000080002e72 <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80002e72:	1101                	addi	sp,sp,-32
    80002e74:	ec06                	sd	ra,24(sp)
    80002e76:	e822                	sd	s0,16(sp)
    80002e78:	e426                	sd	s1,8(sp)
    80002e7a:	e04a                	sd	s2,0(sp)
    80002e7c:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002e7e:	00234917          	auipc	s2,0x234
    80002e82:	56a90913          	addi	s2,s2,1386 # 802373e8 <tickslock>
    80002e86:	854a                	mv	a0,s2
    80002e88:	ffffe097          	auipc	ra,0xffffe
    80002e8c:	f72080e7          	jalr	-142(ra) # 80000dfa <acquire>
  ticks++;
    80002e90:	00006497          	auipc	s1,0x6
    80002e94:	aa048493          	addi	s1,s1,-1376 # 80008930 <ticks>
    80002e98:	409c                	lw	a5,0(s1)
    80002e9a:	2785                	addiw	a5,a5,1
    80002e9c:	c09c                	sw	a5,0(s1)
  update_time();
    80002e9e:	00000097          	auipc	ra,0x0
    80002ea2:	d1c080e7          	jalr	-740(ra) # 80002bba <update_time>
  //   // {
  //   //   p->wtime++;
  //   // }
  //   release(&p->lock);
  // }
  wakeup(&ticks);
    80002ea6:	8526                	mv	a0,s1
    80002ea8:	fffff097          	auipc	ra,0xfffff
    80002eac:	69e080e7          	jalr	1694(ra) # 80002546 <wakeup>
  release(&tickslock);
    80002eb0:	854a                	mv	a0,s2
    80002eb2:	ffffe097          	auipc	ra,0xffffe
    80002eb6:	ffc080e7          	jalr	-4(ra) # 80000eae <release>
}
    80002eba:	60e2                	ld	ra,24(sp)
    80002ebc:	6442                	ld	s0,16(sp)
    80002ebe:	64a2                	ld	s1,8(sp)
    80002ec0:	6902                	ld	s2,0(sp)
    80002ec2:	6105                	addi	sp,sp,32
    80002ec4:	8082                	ret

0000000080002ec6 <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80002ec6:	1101                	addi	sp,sp,-32
    80002ec8:	ec06                	sd	ra,24(sp)
    80002eca:	e822                	sd	s0,16(sp)
    80002ecc:	e426                	sd	s1,8(sp)
    80002ece:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ed0:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) &&
    80002ed4:	00074d63          	bltz	a4,80002eee <devintr+0x28>
    if (irq)
      plic_complete(irq);

    return 1;
  }
  else if (scause == 0x8000000000000001L)
    80002ed8:	57fd                	li	a5,-1
    80002eda:	17fe                	slli	a5,a5,0x3f
    80002edc:	0785                	addi	a5,a5,1

    return 2;
  }
  else
  {
    return 0;
    80002ede:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80002ee0:	06f70363          	beq	a4,a5,80002f46 <devintr+0x80>
  }
}
    80002ee4:	60e2                	ld	ra,24(sp)
    80002ee6:	6442                	ld	s0,16(sp)
    80002ee8:	64a2                	ld	s1,8(sp)
    80002eea:	6105                	addi	sp,sp,32
    80002eec:	8082                	ret
      (scause & 0xff) == 9)
    80002eee:	0ff77793          	andi	a5,a4,255
  if ((scause & 0x8000000000000000L) &&
    80002ef2:	46a5                	li	a3,9
    80002ef4:	fed792e3          	bne	a5,a3,80002ed8 <devintr+0x12>
    int irq = plic_claim();
    80002ef8:	00003097          	auipc	ra,0x3
    80002efc:	5c0080e7          	jalr	1472(ra) # 800064b8 <plic_claim>
    80002f00:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80002f02:	47a9                	li	a5,10
    80002f04:	02f50763          	beq	a0,a5,80002f32 <devintr+0x6c>
    else if (irq == VIRTIO0_IRQ)
    80002f08:	4785                	li	a5,1
    80002f0a:	02f50963          	beq	a0,a5,80002f3c <devintr+0x76>
    return 1;
    80002f0e:	4505                	li	a0,1
    else if (irq)
    80002f10:	d8f1                	beqz	s1,80002ee4 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002f12:	85a6                	mv	a1,s1
    80002f14:	00005517          	auipc	a0,0x5
    80002f18:	44450513          	addi	a0,a0,1092 # 80008358 <states.0+0x38>
    80002f1c:	ffffd097          	auipc	ra,0xffffd
    80002f20:	66c080e7          	jalr	1644(ra) # 80000588 <printf>
      plic_complete(irq);
    80002f24:	8526                	mv	a0,s1
    80002f26:	00003097          	auipc	ra,0x3
    80002f2a:	5b6080e7          	jalr	1462(ra) # 800064dc <plic_complete>
    return 1;
    80002f2e:	4505                	li	a0,1
    80002f30:	bf55                	j	80002ee4 <devintr+0x1e>
      uartintr();
    80002f32:	ffffe097          	auipc	ra,0xffffe
    80002f36:	a68080e7          	jalr	-1432(ra) # 8000099a <uartintr>
    80002f3a:	b7ed                	j	80002f24 <devintr+0x5e>
      virtio_disk_intr();
    80002f3c:	00004097          	auipc	ra,0x4
    80002f40:	a6c080e7          	jalr	-1428(ra) # 800069a8 <virtio_disk_intr>
    80002f44:	b7c5                	j	80002f24 <devintr+0x5e>
    if (cpuid() == 0)
    80002f46:	fffff097          	auipc	ra,0xfffff
    80002f4a:	c9c080e7          	jalr	-868(ra) # 80001be2 <cpuid>
    80002f4e:	c901                	beqz	a0,80002f5e <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002f50:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002f54:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002f56:	14479073          	csrw	sip,a5
    return 2;
    80002f5a:	4509                	li	a0,2
    80002f5c:	b761                	j	80002ee4 <devintr+0x1e>
      clockintr();
    80002f5e:	00000097          	auipc	ra,0x0
    80002f62:	f14080e7          	jalr	-236(ra) # 80002e72 <clockintr>
    80002f66:	b7ed                	j	80002f50 <devintr+0x8a>

0000000080002f68 <usertrap>:
{
    80002f68:	1101                	addi	sp,sp,-32
    80002f6a:	ec06                	sd	ra,24(sp)
    80002f6c:	e822                	sd	s0,16(sp)
    80002f6e:	e426                	sd	s1,8(sp)
    80002f70:	e04a                	sd	s2,0(sp)
    80002f72:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f74:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002f78:	1007f793          	andi	a5,a5,256
    80002f7c:	efb1                	bnez	a5,80002fd8 <usertrap+0x70>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002f7e:	00003797          	auipc	a5,0x3
    80002f82:	43278793          	addi	a5,a5,1074 # 800063b0 <kernelvec>
    80002f86:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002f8a:	fffff097          	auipc	ra,0xfffff
    80002f8e:	c84080e7          	jalr	-892(ra) # 80001c0e <myproc>
    80002f92:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002f94:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f96:	14102773          	csrr	a4,sepc
    80002f9a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002f9c:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80002fa0:	47a1                	li	a5,8
    80002fa2:	04f70363          	beq	a4,a5,80002fe8 <usertrap+0x80>
  else if ((which_dev = devintr()) != 0)
    80002fa6:	00000097          	auipc	ra,0x0
    80002faa:	f20080e7          	jalr	-224(ra) # 80002ec6 <devintr>
    80002fae:	892a                	mv	s2,a0
    80002fb0:	e171                	bnez	a0,80003074 <usertrap+0x10c>
    80002fb2:	14202773          	csrr	a4,scause
  else if (r_scause() == 15)
    80002fb6:	47bd                	li	a5,15
    80002fb8:	08f71163          	bne	a4,a5,8000303a <usertrap+0xd2>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002fbc:	14302573          	csrr	a0,stval
    if (!address)
    80002fc0:	e119                	bnez	a0,80002fc6 <usertrap+0x5e>
      p->killed = 1;
    80002fc2:	4785                	li	a5,1
    80002fc4:	d49c                	sw	a5,40(s1)
    if (handle_page(address, p->pagetable) == 0)
    80002fc6:	68ac                	ld	a1,80(s1)
    80002fc8:	00000097          	auipc	ra,0x0
    80002fcc:	d2e080e7          	jalr	-722(ra) # 80002cf6 <handle_page>
    80002fd0:	cd1d                	beqz	a0,8000300e <usertrap+0xa6>
      p->killed = 1;
    80002fd2:	4785                	li	a5,1
    80002fd4:	d49c                	sw	a5,40(s1)
    80002fd6:	a825                	j	8000300e <usertrap+0xa6>
    panic("usertrap: not from user mode");
    80002fd8:	00005517          	auipc	a0,0x5
    80002fdc:	3a050513          	addi	a0,a0,928 # 80008378 <states.0+0x58>
    80002fe0:	ffffd097          	auipc	ra,0xffffd
    80002fe4:	55e080e7          	jalr	1374(ra) # 8000053e <panic>
    if (killed(p))
    80002fe8:	fffff097          	auipc	ra,0xfffff
    80002fec:	7ae080e7          	jalr	1966(ra) # 80002796 <killed>
    80002ff0:	ed1d                	bnez	a0,8000302e <usertrap+0xc6>
    p->trapframe->epc += 4;
    80002ff2:	6cb8                	ld	a4,88(s1)
    80002ff4:	6f1c                	ld	a5,24(a4)
    80002ff6:	0791                	addi	a5,a5,4
    80002ff8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ffa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002ffe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003002:	10079073          	csrw	sstatus,a5
    syscall();
    80003006:	00000097          	auipc	ra,0x0
    8000300a:	2e2080e7          	jalr	738(ra) # 800032e8 <syscall>
  if (killed(p))
    8000300e:	8526                	mv	a0,s1
    80003010:	fffff097          	auipc	ra,0xfffff
    80003014:	786080e7          	jalr	1926(ra) # 80002796 <killed>
    80003018:	e52d                	bnez	a0,80003082 <usertrap+0x11a>
  usertrapret();
    8000301a:	00000097          	auipc	ra,0x0
    8000301e:	dc2080e7          	jalr	-574(ra) # 80002ddc <usertrapret>
}
    80003022:	60e2                	ld	ra,24(sp)
    80003024:	6442                	ld	s0,16(sp)
    80003026:	64a2                	ld	s1,8(sp)
    80003028:	6902                	ld	s2,0(sp)
    8000302a:	6105                	addi	sp,sp,32
    8000302c:	8082                	ret
      exit(-1);
    8000302e:	557d                	li	a0,-1
    80003030:	fffff097          	auipc	ra,0xfffff
    80003034:	5e6080e7          	jalr	1510(ra) # 80002616 <exit>
    80003038:	bf6d                	j	80002ff2 <usertrap+0x8a>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000303a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000303e:	5890                	lw	a2,48(s1)
    80003040:	00005517          	auipc	a0,0x5
    80003044:	35850513          	addi	a0,a0,856 # 80008398 <states.0+0x78>
    80003048:	ffffd097          	auipc	ra,0xffffd
    8000304c:	540080e7          	jalr	1344(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003050:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003054:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003058:	00005517          	auipc	a0,0x5
    8000305c:	37050513          	addi	a0,a0,880 # 800083c8 <states.0+0xa8>
    80003060:	ffffd097          	auipc	ra,0xffffd
    80003064:	528080e7          	jalr	1320(ra) # 80000588 <printf>
    setkilled(p);
    80003068:	8526                	mv	a0,s1
    8000306a:	fffff097          	auipc	ra,0xfffff
    8000306e:	700080e7          	jalr	1792(ra) # 8000276a <setkilled>
    80003072:	bf71                	j	8000300e <usertrap+0xa6>
  if (killed(p))
    80003074:	8526                	mv	a0,s1
    80003076:	fffff097          	auipc	ra,0xfffff
    8000307a:	720080e7          	jalr	1824(ra) # 80002796 <killed>
    8000307e:	c901                	beqz	a0,8000308e <usertrap+0x126>
    80003080:	a011                	j	80003084 <usertrap+0x11c>
    80003082:	4901                	li	s2,0
    exit(-1);
    80003084:	557d                	li	a0,-1
    80003086:	fffff097          	auipc	ra,0xfffff
    8000308a:	590080e7          	jalr	1424(ra) # 80002616 <exit>
  if (which_dev == 2)
    8000308e:	4789                	li	a5,2
    80003090:	f8f915e3          	bne	s2,a5,8000301a <usertrap+0xb2>
    yield();
    80003094:	fffff097          	auipc	ra,0xfffff
    80003098:	38e080e7          	jalr	910(ra) # 80002422 <yield>
    8000309c:	bfbd                	j	8000301a <usertrap+0xb2>

000000008000309e <kerneltrap>:
{
    8000309e:	7179                	addi	sp,sp,-48
    800030a0:	f406                	sd	ra,40(sp)
    800030a2:	f022                	sd	s0,32(sp)
    800030a4:	ec26                	sd	s1,24(sp)
    800030a6:	e84a                	sd	s2,16(sp)
    800030a8:	e44e                	sd	s3,8(sp)
    800030aa:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800030ac:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800030b0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800030b4:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    800030b8:	1004f793          	andi	a5,s1,256
    800030bc:	cb85                	beqz	a5,800030ec <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800030be:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800030c2:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    800030c4:	ef85                	bnez	a5,800030fc <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    800030c6:	00000097          	auipc	ra,0x0
    800030ca:	e00080e7          	jalr	-512(ra) # 80002ec6 <devintr>
    800030ce:	cd1d                	beqz	a0,8000310c <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800030d0:	4789                	li	a5,2
    800030d2:	06f50a63          	beq	a0,a5,80003146 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800030d6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800030da:	10049073          	csrw	sstatus,s1
}
    800030de:	70a2                	ld	ra,40(sp)
    800030e0:	7402                	ld	s0,32(sp)
    800030e2:	64e2                	ld	s1,24(sp)
    800030e4:	6942                	ld	s2,16(sp)
    800030e6:	69a2                	ld	s3,8(sp)
    800030e8:	6145                	addi	sp,sp,48
    800030ea:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800030ec:	00005517          	auipc	a0,0x5
    800030f0:	2fc50513          	addi	a0,a0,764 # 800083e8 <states.0+0xc8>
    800030f4:	ffffd097          	auipc	ra,0xffffd
    800030f8:	44a080e7          	jalr	1098(ra) # 8000053e <panic>
    panic("kerneltrap: interrupts enabled");
    800030fc:	00005517          	auipc	a0,0x5
    80003100:	31450513          	addi	a0,a0,788 # 80008410 <states.0+0xf0>
    80003104:	ffffd097          	auipc	ra,0xffffd
    80003108:	43a080e7          	jalr	1082(ra) # 8000053e <panic>
    printf("scause %p\n", scause);
    8000310c:	85ce                	mv	a1,s3
    8000310e:	00005517          	auipc	a0,0x5
    80003112:	32250513          	addi	a0,a0,802 # 80008430 <states.0+0x110>
    80003116:	ffffd097          	auipc	ra,0xffffd
    8000311a:	472080e7          	jalr	1138(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000311e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003122:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003126:	00005517          	auipc	a0,0x5
    8000312a:	31a50513          	addi	a0,a0,794 # 80008440 <states.0+0x120>
    8000312e:	ffffd097          	auipc	ra,0xffffd
    80003132:	45a080e7          	jalr	1114(ra) # 80000588 <printf>
    panic("kerneltrap");
    80003136:	00005517          	auipc	a0,0x5
    8000313a:	32250513          	addi	a0,a0,802 # 80008458 <states.0+0x138>
    8000313e:	ffffd097          	auipc	ra,0xffffd
    80003142:	400080e7          	jalr	1024(ra) # 8000053e <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003146:	fffff097          	auipc	ra,0xfffff
    8000314a:	ac8080e7          	jalr	-1336(ra) # 80001c0e <myproc>
    8000314e:	d541                	beqz	a0,800030d6 <kerneltrap+0x38>
    80003150:	fffff097          	auipc	ra,0xfffff
    80003154:	abe080e7          	jalr	-1346(ra) # 80001c0e <myproc>
    80003158:	4d18                	lw	a4,24(a0)
    8000315a:	4791                	li	a5,4
    8000315c:	f6f71de3          	bne	a4,a5,800030d6 <kerneltrap+0x38>
    yield();
    80003160:	fffff097          	auipc	ra,0xfffff
    80003164:	2c2080e7          	jalr	706(ra) # 80002422 <yield>
    80003168:	b7bd                	j	800030d6 <kerneltrap+0x38>

000000008000316a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000316a:	1101                	addi	sp,sp,-32
    8000316c:	ec06                	sd	ra,24(sp)
    8000316e:	e822                	sd	s0,16(sp)
    80003170:	e426                	sd	s1,8(sp)
    80003172:	1000                	addi	s0,sp,32
    80003174:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80003176:	fffff097          	auipc	ra,0xfffff
    8000317a:	a98080e7          	jalr	-1384(ra) # 80001c0e <myproc>
  switch (n) {
    8000317e:	4795                	li	a5,5
    80003180:	0497e163          	bltu	a5,s1,800031c2 <argraw+0x58>
    80003184:	048a                	slli	s1,s1,0x2
    80003186:	00005717          	auipc	a4,0x5
    8000318a:	30a70713          	addi	a4,a4,778 # 80008490 <states.0+0x170>
    8000318e:	94ba                	add	s1,s1,a4
    80003190:	409c                	lw	a5,0(s1)
    80003192:	97ba                	add	a5,a5,a4
    80003194:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80003196:	6d3c                	ld	a5,88(a0)
    80003198:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000319a:	60e2                	ld	ra,24(sp)
    8000319c:	6442                	ld	s0,16(sp)
    8000319e:	64a2                	ld	s1,8(sp)
    800031a0:	6105                	addi	sp,sp,32
    800031a2:	8082                	ret
    return p->trapframe->a1;
    800031a4:	6d3c                	ld	a5,88(a0)
    800031a6:	7fa8                	ld	a0,120(a5)
    800031a8:	bfcd                	j	8000319a <argraw+0x30>
    return p->trapframe->a2;
    800031aa:	6d3c                	ld	a5,88(a0)
    800031ac:	63c8                	ld	a0,128(a5)
    800031ae:	b7f5                	j	8000319a <argraw+0x30>
    return p->trapframe->a3;
    800031b0:	6d3c                	ld	a5,88(a0)
    800031b2:	67c8                	ld	a0,136(a5)
    800031b4:	b7dd                	j	8000319a <argraw+0x30>
    return p->trapframe->a4;
    800031b6:	6d3c                	ld	a5,88(a0)
    800031b8:	6bc8                	ld	a0,144(a5)
    800031ba:	b7c5                	j	8000319a <argraw+0x30>
    return p->trapframe->a5;
    800031bc:	6d3c                	ld	a5,88(a0)
    800031be:	6fc8                	ld	a0,152(a5)
    800031c0:	bfe9                	j	8000319a <argraw+0x30>
  panic("argraw");
    800031c2:	00005517          	auipc	a0,0x5
    800031c6:	2a650513          	addi	a0,a0,678 # 80008468 <states.0+0x148>
    800031ca:	ffffd097          	auipc	ra,0xffffd
    800031ce:	374080e7          	jalr	884(ra) # 8000053e <panic>

00000000800031d2 <fetchaddr>:
{
    800031d2:	1101                	addi	sp,sp,-32
    800031d4:	ec06                	sd	ra,24(sp)
    800031d6:	e822                	sd	s0,16(sp)
    800031d8:	e426                	sd	s1,8(sp)
    800031da:	e04a                	sd	s2,0(sp)
    800031dc:	1000                	addi	s0,sp,32
    800031de:	84aa                	mv	s1,a0
    800031e0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800031e2:	fffff097          	auipc	ra,0xfffff
    800031e6:	a2c080e7          	jalr	-1492(ra) # 80001c0e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800031ea:	653c                	ld	a5,72(a0)
    800031ec:	02f4f863          	bgeu	s1,a5,8000321c <fetchaddr+0x4a>
    800031f0:	00848713          	addi	a4,s1,8
    800031f4:	02e7e663          	bltu	a5,a4,80003220 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800031f8:	46a1                	li	a3,8
    800031fa:	8626                	mv	a2,s1
    800031fc:	85ca                	mv	a1,s2
    800031fe:	6928                	ld	a0,80(a0)
    80003200:	ffffe097          	auipc	ra,0xffffe
    80003204:	756080e7          	jalr	1878(ra) # 80001956 <copyin>
    80003208:	00a03533          	snez	a0,a0
    8000320c:	40a00533          	neg	a0,a0
}
    80003210:	60e2                	ld	ra,24(sp)
    80003212:	6442                	ld	s0,16(sp)
    80003214:	64a2                	ld	s1,8(sp)
    80003216:	6902                	ld	s2,0(sp)
    80003218:	6105                	addi	sp,sp,32
    8000321a:	8082                	ret
    return -1;
    8000321c:	557d                	li	a0,-1
    8000321e:	bfcd                	j	80003210 <fetchaddr+0x3e>
    80003220:	557d                	li	a0,-1
    80003222:	b7fd                	j	80003210 <fetchaddr+0x3e>

0000000080003224 <fetchstr>:
{
    80003224:	7179                	addi	sp,sp,-48
    80003226:	f406                	sd	ra,40(sp)
    80003228:	f022                	sd	s0,32(sp)
    8000322a:	ec26                	sd	s1,24(sp)
    8000322c:	e84a                	sd	s2,16(sp)
    8000322e:	e44e                	sd	s3,8(sp)
    80003230:	1800                	addi	s0,sp,48
    80003232:	892a                	mv	s2,a0
    80003234:	84ae                	mv	s1,a1
    80003236:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80003238:	fffff097          	auipc	ra,0xfffff
    8000323c:	9d6080e7          	jalr	-1578(ra) # 80001c0e <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80003240:	86ce                	mv	a3,s3
    80003242:	864a                	mv	a2,s2
    80003244:	85a6                	mv	a1,s1
    80003246:	6928                	ld	a0,80(a0)
    80003248:	ffffe097          	auipc	ra,0xffffe
    8000324c:	79c080e7          	jalr	1948(ra) # 800019e4 <copyinstr>
    80003250:	00054e63          	bltz	a0,8000326c <fetchstr+0x48>
  return strlen(buf);
    80003254:	8526                	mv	a0,s1
    80003256:	ffffe097          	auipc	ra,0xffffe
    8000325a:	e1c080e7          	jalr	-484(ra) # 80001072 <strlen>
}
    8000325e:	70a2                	ld	ra,40(sp)
    80003260:	7402                	ld	s0,32(sp)
    80003262:	64e2                	ld	s1,24(sp)
    80003264:	6942                	ld	s2,16(sp)
    80003266:	69a2                	ld	s3,8(sp)
    80003268:	6145                	addi	sp,sp,48
    8000326a:	8082                	ret
    return -1;
    8000326c:	557d                	li	a0,-1
    8000326e:	bfc5                	j	8000325e <fetchstr+0x3a>

0000000080003270 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80003270:	1101                	addi	sp,sp,-32
    80003272:	ec06                	sd	ra,24(sp)
    80003274:	e822                	sd	s0,16(sp)
    80003276:	e426                	sd	s1,8(sp)
    80003278:	1000                	addi	s0,sp,32
    8000327a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000327c:	00000097          	auipc	ra,0x0
    80003280:	eee080e7          	jalr	-274(ra) # 8000316a <argraw>
    80003284:	c088                	sw	a0,0(s1)
}
    80003286:	60e2                	ld	ra,24(sp)
    80003288:	6442                	ld	s0,16(sp)
    8000328a:	64a2                	ld	s1,8(sp)
    8000328c:	6105                	addi	sp,sp,32
    8000328e:	8082                	ret

0000000080003290 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80003290:	1101                	addi	sp,sp,-32
    80003292:	ec06                	sd	ra,24(sp)
    80003294:	e822                	sd	s0,16(sp)
    80003296:	e426                	sd	s1,8(sp)
    80003298:	1000                	addi	s0,sp,32
    8000329a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000329c:	00000097          	auipc	ra,0x0
    800032a0:	ece080e7          	jalr	-306(ra) # 8000316a <argraw>
    800032a4:	e088                	sd	a0,0(s1)
}
    800032a6:	60e2                	ld	ra,24(sp)
    800032a8:	6442                	ld	s0,16(sp)
    800032aa:	64a2                	ld	s1,8(sp)
    800032ac:	6105                	addi	sp,sp,32
    800032ae:	8082                	ret

00000000800032b0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800032b0:	7179                	addi	sp,sp,-48
    800032b2:	f406                	sd	ra,40(sp)
    800032b4:	f022                	sd	s0,32(sp)
    800032b6:	ec26                	sd	s1,24(sp)
    800032b8:	e84a                	sd	s2,16(sp)
    800032ba:	1800                	addi	s0,sp,48
    800032bc:	84ae                	mv	s1,a1
    800032be:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800032c0:	fd840593          	addi	a1,s0,-40
    800032c4:	00000097          	auipc	ra,0x0
    800032c8:	fcc080e7          	jalr	-52(ra) # 80003290 <argaddr>
  return fetchstr(addr, buf, max);
    800032cc:	864a                	mv	a2,s2
    800032ce:	85a6                	mv	a1,s1
    800032d0:	fd843503          	ld	a0,-40(s0)
    800032d4:	00000097          	auipc	ra,0x0
    800032d8:	f50080e7          	jalr	-176(ra) # 80003224 <fetchstr>
}
    800032dc:	70a2                	ld	ra,40(sp)
    800032de:	7402                	ld	s0,32(sp)
    800032e0:	64e2                	ld	s1,24(sp)
    800032e2:	6942                	ld	s2,16(sp)
    800032e4:	6145                	addi	sp,sp,48
    800032e6:	8082                	ret

00000000800032e8 <syscall>:
[SYS_set_priority] sys_set_priority,
};

void
syscall(void)
{
    800032e8:	1101                	addi	sp,sp,-32
    800032ea:	ec06                	sd	ra,24(sp)
    800032ec:	e822                	sd	s0,16(sp)
    800032ee:	e426                	sd	s1,8(sp)
    800032f0:	e04a                	sd	s2,0(sp)
    800032f2:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800032f4:	fffff097          	auipc	ra,0xfffff
    800032f8:	91a080e7          	jalr	-1766(ra) # 80001c0e <myproc>
    800032fc:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800032fe:	05853903          	ld	s2,88(a0)
    80003302:	0a893783          	ld	a5,168(s2)
    80003306:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000330a:	37fd                	addiw	a5,a5,-1
    8000330c:	475d                	li	a4,23
    8000330e:	00f76f63          	bltu	a4,a5,8000332c <syscall+0x44>
    80003312:	00369713          	slli	a4,a3,0x3
    80003316:	00005797          	auipc	a5,0x5
    8000331a:	19278793          	addi	a5,a5,402 # 800084a8 <syscalls>
    8000331e:	97ba                	add	a5,a5,a4
    80003320:	639c                	ld	a5,0(a5)
    80003322:	c789                	beqz	a5,8000332c <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80003324:	9782                	jalr	a5
    80003326:	06a93823          	sd	a0,112(s2)
    8000332a:	a839                	j	80003348 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000332c:	15848613          	addi	a2,s1,344
    80003330:	588c                	lw	a1,48(s1)
    80003332:	00005517          	auipc	a0,0x5
    80003336:	13e50513          	addi	a0,a0,318 # 80008470 <states.0+0x150>
    8000333a:	ffffd097          	auipc	ra,0xffffd
    8000333e:	24e080e7          	jalr	590(ra) # 80000588 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003342:	6cbc                	ld	a5,88(s1)
    80003344:	577d                	li	a4,-1
    80003346:	fbb8                	sd	a4,112(a5)
  }
}
    80003348:	60e2                	ld	ra,24(sp)
    8000334a:	6442                	ld	s0,16(sp)
    8000334c:	64a2                	ld	s1,8(sp)
    8000334e:	6902                	ld	s2,0(sp)
    80003350:	6105                	addi	sp,sp,32
    80003352:	8082                	ret

0000000080003354 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80003354:	1101                	addi	sp,sp,-32
    80003356:	ec06                	sd	ra,24(sp)
    80003358:	e822                	sd	s0,16(sp)
    8000335a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000335c:	fec40593          	addi	a1,s0,-20
    80003360:	4501                	li	a0,0
    80003362:	00000097          	auipc	ra,0x0
    80003366:	f0e080e7          	jalr	-242(ra) # 80003270 <argint>
  exit(n);
    8000336a:	fec42503          	lw	a0,-20(s0)
    8000336e:	fffff097          	auipc	ra,0xfffff
    80003372:	2a8080e7          	jalr	680(ra) # 80002616 <exit>
  return 0; // not reached
}
    80003376:	4501                	li	a0,0
    80003378:	60e2                	ld	ra,24(sp)
    8000337a:	6442                	ld	s0,16(sp)
    8000337c:	6105                	addi	sp,sp,32
    8000337e:	8082                	ret

0000000080003380 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003380:	1141                	addi	sp,sp,-16
    80003382:	e406                	sd	ra,8(sp)
    80003384:	e022                	sd	s0,0(sp)
    80003386:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80003388:	fffff097          	auipc	ra,0xfffff
    8000338c:	886080e7          	jalr	-1914(ra) # 80001c0e <myproc>
}
    80003390:	5908                	lw	a0,48(a0)
    80003392:	60a2                	ld	ra,8(sp)
    80003394:	6402                	ld	s0,0(sp)
    80003396:	0141                	addi	sp,sp,16
    80003398:	8082                	ret

000000008000339a <sys_fork>:

uint64
sys_fork(void)
{
    8000339a:	1141                	addi	sp,sp,-16
    8000339c:	e406                	sd	ra,8(sp)
    8000339e:	e022                	sd	s0,0(sp)
    800033a0:	0800                	addi	s0,sp,16
  return fork();
    800033a2:	fffff097          	auipc	ra,0xfffff
    800033a6:	c5c080e7          	jalr	-932(ra) # 80001ffe <fork>
}
    800033aa:	60a2                	ld	ra,8(sp)
    800033ac:	6402                	ld	s0,0(sp)
    800033ae:	0141                	addi	sp,sp,16
    800033b0:	8082                	ret

00000000800033b2 <sys_wait>:

uint64
sys_wait(void)
{
    800033b2:	1101                	addi	sp,sp,-32
    800033b4:	ec06                	sd	ra,24(sp)
    800033b6:	e822                	sd	s0,16(sp)
    800033b8:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800033ba:	fe840593          	addi	a1,s0,-24
    800033be:	4501                	li	a0,0
    800033c0:	00000097          	auipc	ra,0x0
    800033c4:	ed0080e7          	jalr	-304(ra) # 80003290 <argaddr>
  return wait(p);
    800033c8:	fe843503          	ld	a0,-24(s0)
    800033cc:	fffff097          	auipc	ra,0xfffff
    800033d0:	3fc080e7          	jalr	1020(ra) # 800027c8 <wait>
}
    800033d4:	60e2                	ld	ra,24(sp)
    800033d6:	6442                	ld	s0,16(sp)
    800033d8:	6105                	addi	sp,sp,32
    800033da:	8082                	ret

00000000800033dc <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800033dc:	7179                	addi	sp,sp,-48
    800033de:	f406                	sd	ra,40(sp)
    800033e0:	f022                	sd	s0,32(sp)
    800033e2:	ec26                	sd	s1,24(sp)
    800033e4:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800033e6:	fdc40593          	addi	a1,s0,-36
    800033ea:	4501                	li	a0,0
    800033ec:	00000097          	auipc	ra,0x0
    800033f0:	e84080e7          	jalr	-380(ra) # 80003270 <argint>
  addr = myproc()->sz;
    800033f4:	fffff097          	auipc	ra,0xfffff
    800033f8:	81a080e7          	jalr	-2022(ra) # 80001c0e <myproc>
    800033fc:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0)
    800033fe:	fdc42503          	lw	a0,-36(s0)
    80003402:	fffff097          	auipc	ra,0xfffff
    80003406:	ba0080e7          	jalr	-1120(ra) # 80001fa2 <growproc>
    8000340a:	00054863          	bltz	a0,8000341a <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    8000340e:	8526                	mv	a0,s1
    80003410:	70a2                	ld	ra,40(sp)
    80003412:	7402                	ld	s0,32(sp)
    80003414:	64e2                	ld	s1,24(sp)
    80003416:	6145                	addi	sp,sp,48
    80003418:	8082                	ret
    return -1;
    8000341a:	54fd                	li	s1,-1
    8000341c:	bfcd                	j	8000340e <sys_sbrk+0x32>

000000008000341e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000341e:	7139                	addi	sp,sp,-64
    80003420:	fc06                	sd	ra,56(sp)
    80003422:	f822                	sd	s0,48(sp)
    80003424:	f426                	sd	s1,40(sp)
    80003426:	f04a                	sd	s2,32(sp)
    80003428:	ec4e                	sd	s3,24(sp)
    8000342a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000342c:	fcc40593          	addi	a1,s0,-52
    80003430:	4501                	li	a0,0
    80003432:	00000097          	auipc	ra,0x0
    80003436:	e3e080e7          	jalr	-450(ra) # 80003270 <argint>
  acquire(&tickslock);
    8000343a:	00234517          	auipc	a0,0x234
    8000343e:	fae50513          	addi	a0,a0,-82 # 802373e8 <tickslock>
    80003442:	ffffe097          	auipc	ra,0xffffe
    80003446:	9b8080e7          	jalr	-1608(ra) # 80000dfa <acquire>
  ticks0 = ticks;
    8000344a:	00005917          	auipc	s2,0x5
    8000344e:	4e692903          	lw	s2,1254(s2) # 80008930 <ticks>
  while (ticks - ticks0 < n)
    80003452:	fcc42783          	lw	a5,-52(s0)
    80003456:	cf9d                	beqz	a5,80003494 <sys_sleep+0x76>
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003458:	00234997          	auipc	s3,0x234
    8000345c:	f9098993          	addi	s3,s3,-112 # 802373e8 <tickslock>
    80003460:	00005497          	auipc	s1,0x5
    80003464:	4d048493          	addi	s1,s1,1232 # 80008930 <ticks>
    if (killed(myproc()))
    80003468:	ffffe097          	auipc	ra,0xffffe
    8000346c:	7a6080e7          	jalr	1958(ra) # 80001c0e <myproc>
    80003470:	fffff097          	auipc	ra,0xfffff
    80003474:	326080e7          	jalr	806(ra) # 80002796 <killed>
    80003478:	ed15                	bnez	a0,800034b4 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    8000347a:	85ce                	mv	a1,s3
    8000347c:	8526                	mv	a0,s1
    8000347e:	fffff097          	auipc	ra,0xfffff
    80003482:	064080e7          	jalr	100(ra) # 800024e2 <sleep>
  while (ticks - ticks0 < n)
    80003486:	409c                	lw	a5,0(s1)
    80003488:	412787bb          	subw	a5,a5,s2
    8000348c:	fcc42703          	lw	a4,-52(s0)
    80003490:	fce7ece3          	bltu	a5,a4,80003468 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80003494:	00234517          	auipc	a0,0x234
    80003498:	f5450513          	addi	a0,a0,-172 # 802373e8 <tickslock>
    8000349c:	ffffe097          	auipc	ra,0xffffe
    800034a0:	a12080e7          	jalr	-1518(ra) # 80000eae <release>
  return 0;
    800034a4:	4501                	li	a0,0
}
    800034a6:	70e2                	ld	ra,56(sp)
    800034a8:	7442                	ld	s0,48(sp)
    800034aa:	74a2                	ld	s1,40(sp)
    800034ac:	7902                	ld	s2,32(sp)
    800034ae:	69e2                	ld	s3,24(sp)
    800034b0:	6121                	addi	sp,sp,64
    800034b2:	8082                	ret
      release(&tickslock);
    800034b4:	00234517          	auipc	a0,0x234
    800034b8:	f3450513          	addi	a0,a0,-204 # 802373e8 <tickslock>
    800034bc:	ffffe097          	auipc	ra,0xffffe
    800034c0:	9f2080e7          	jalr	-1550(ra) # 80000eae <release>
      return -1;
    800034c4:	557d                	li	a0,-1
    800034c6:	b7c5                	j	800034a6 <sys_sleep+0x88>

00000000800034c8 <sys_kill>:

uint64
sys_kill(void)
{
    800034c8:	1101                	addi	sp,sp,-32
    800034ca:	ec06                	sd	ra,24(sp)
    800034cc:	e822                	sd	s0,16(sp)
    800034ce:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800034d0:	fec40593          	addi	a1,s0,-20
    800034d4:	4501                	li	a0,0
    800034d6:	00000097          	auipc	ra,0x0
    800034da:	d9a080e7          	jalr	-614(ra) # 80003270 <argint>
  return kill(pid);
    800034de:	fec42503          	lw	a0,-20(s0)
    800034e2:	fffff097          	auipc	ra,0xfffff
    800034e6:	216080e7          	jalr	534(ra) # 800026f8 <kill>
}
    800034ea:	60e2                	ld	ra,24(sp)
    800034ec:	6442                	ld	s0,16(sp)
    800034ee:	6105                	addi	sp,sp,32
    800034f0:	8082                	ret

00000000800034f2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800034f2:	1101                	addi	sp,sp,-32
    800034f4:	ec06                	sd	ra,24(sp)
    800034f6:	e822                	sd	s0,16(sp)
    800034f8:	e426                	sd	s1,8(sp)
    800034fa:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800034fc:	00234517          	auipc	a0,0x234
    80003500:	eec50513          	addi	a0,a0,-276 # 802373e8 <tickslock>
    80003504:	ffffe097          	auipc	ra,0xffffe
    80003508:	8f6080e7          	jalr	-1802(ra) # 80000dfa <acquire>
  xticks = ticks;
    8000350c:	00005497          	auipc	s1,0x5
    80003510:	4244a483          	lw	s1,1060(s1) # 80008930 <ticks>
  release(&tickslock);
    80003514:	00234517          	auipc	a0,0x234
    80003518:	ed450513          	addi	a0,a0,-300 # 802373e8 <tickslock>
    8000351c:	ffffe097          	auipc	ra,0xffffe
    80003520:	992080e7          	jalr	-1646(ra) # 80000eae <release>
  return xticks;
}
    80003524:	02049513          	slli	a0,s1,0x20
    80003528:	9101                	srli	a0,a0,0x20
    8000352a:	60e2                	ld	ra,24(sp)
    8000352c:	6442                	ld	s0,16(sp)
    8000352e:	64a2                	ld	s1,8(sp)
    80003530:	6105                	addi	sp,sp,32
    80003532:	8082                	ret

0000000080003534 <sys_waitx>:

uint64
sys_waitx(void)
{
    80003534:	7139                	addi	sp,sp,-64
    80003536:	fc06                	sd	ra,56(sp)
    80003538:	f822                	sd	s0,48(sp)
    8000353a:	f426                	sd	s1,40(sp)
    8000353c:	f04a                	sd	s2,32(sp)
    8000353e:	0080                	addi	s0,sp,64
  uint64 addr, addr1, addr2;
  uint wtime, rtime;
  argaddr(0, &addr);
    80003540:	fd840593          	addi	a1,s0,-40
    80003544:	4501                	li	a0,0
    80003546:	00000097          	auipc	ra,0x0
    8000354a:	d4a080e7          	jalr	-694(ra) # 80003290 <argaddr>
  argaddr(1, &addr1); // user virtual memory
    8000354e:	fd040593          	addi	a1,s0,-48
    80003552:	4505                	li	a0,1
    80003554:	00000097          	auipc	ra,0x0
    80003558:	d3c080e7          	jalr	-708(ra) # 80003290 <argaddr>
  argaddr(2, &addr2);
    8000355c:	fc840593          	addi	a1,s0,-56
    80003560:	4509                	li	a0,2
    80003562:	00000097          	auipc	ra,0x0
    80003566:	d2e080e7          	jalr	-722(ra) # 80003290 <argaddr>
  int ret = waitx(addr, &wtime, &rtime);
    8000356a:	fc040613          	addi	a2,s0,-64
    8000356e:	fc440593          	addi	a1,s0,-60
    80003572:	fd843503          	ld	a0,-40(s0)
    80003576:	fffff097          	auipc	ra,0xfffff
    8000357a:	4f8080e7          	jalr	1272(ra) # 80002a6e <waitx>
    8000357e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80003580:	ffffe097          	auipc	ra,0xffffe
    80003584:	68e080e7          	jalr	1678(ra) # 80001c0e <myproc>
    80003588:	84aa                	mv	s1,a0
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    8000358a:	4691                	li	a3,4
    8000358c:	fc440613          	addi	a2,s0,-60
    80003590:	fd043583          	ld	a1,-48(s0)
    80003594:	6928                	ld	a0,80(a0)
    80003596:	ffffe097          	auipc	ra,0xffffe
    8000359a:	2fc080e7          	jalr	764(ra) # 80001892 <copyout>
    return -1;
    8000359e:	57fd                	li	a5,-1
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    800035a0:	00054f63          	bltz	a0,800035be <sys_waitx+0x8a>
  if (copyout(p->pagetable, addr2, (char *)&rtime, sizeof(int)) < 0)
    800035a4:	4691                	li	a3,4
    800035a6:	fc040613          	addi	a2,s0,-64
    800035aa:	fc843583          	ld	a1,-56(s0)
    800035ae:	68a8                	ld	a0,80(s1)
    800035b0:	ffffe097          	auipc	ra,0xffffe
    800035b4:	2e2080e7          	jalr	738(ra) # 80001892 <copyout>
    800035b8:	00054a63          	bltz	a0,800035cc <sys_waitx+0x98>
    return -1;
  return ret;
    800035bc:	87ca                	mv	a5,s2
}
    800035be:	853e                	mv	a0,a5
    800035c0:	70e2                	ld	ra,56(sp)
    800035c2:	7442                	ld	s0,48(sp)
    800035c4:	74a2                	ld	s1,40(sp)
    800035c6:	7902                	ld	s2,32(sp)
    800035c8:	6121                	addi	sp,sp,64
    800035ca:	8082                	ret
    return -1;
    800035cc:	57fd                	li	a5,-1
    800035ce:	bfc5                	j	800035be <sys_waitx+0x8a>

00000000800035d0 <sys_set_priority>:

uint64
sys_set_priority(void)
{
    800035d0:	1101                	addi	sp,sp,-32
    800035d2:	ec06                	sd	ra,24(sp)
    800035d4:	e822                	sd	s0,16(sp)
    800035d6:	1000                	addi	s0,sp,32
  int pid, priority;
  argint(0, &priority) ;
    800035d8:	fe840593          	addi	a1,s0,-24
    800035dc:	4501                	li	a0,0
    800035de:	00000097          	auipc	ra,0x0
    800035e2:	c92080e7          	jalr	-878(ra) # 80003270 <argint>
  argint(1, &pid) ;
    800035e6:	fec40593          	addi	a1,s0,-20
    800035ea:	4505                	li	a0,1
    800035ec:	00000097          	auipc	ra,0x0
    800035f0:	c84080e7          	jalr	-892(ra) # 80003270 <argint>
  return set_priority(priority, pid);
    800035f4:	fec42583          	lw	a1,-20(s0)
    800035f8:	fe842503          	lw	a0,-24(s0)
    800035fc:	fffff097          	auipc	ra,0xfffff
    80003600:	e62080e7          	jalr	-414(ra) # 8000245e <set_priority>
    80003604:	60e2                	ld	ra,24(sp)
    80003606:	6442                	ld	s0,16(sp)
    80003608:	6105                	addi	sp,sp,32
    8000360a:	8082                	ret

000000008000360c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000360c:	7179                	addi	sp,sp,-48
    8000360e:	f406                	sd	ra,40(sp)
    80003610:	f022                	sd	s0,32(sp)
    80003612:	ec26                	sd	s1,24(sp)
    80003614:	e84a                	sd	s2,16(sp)
    80003616:	e44e                	sd	s3,8(sp)
    80003618:	e052                	sd	s4,0(sp)
    8000361a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000361c:	00005597          	auipc	a1,0x5
    80003620:	f5458593          	addi	a1,a1,-172 # 80008570 <syscalls+0xc8>
    80003624:	00234517          	auipc	a0,0x234
    80003628:	ddc50513          	addi	a0,a0,-548 # 80237400 <bcache>
    8000362c:	ffffd097          	auipc	ra,0xffffd
    80003630:	73e080e7          	jalr	1854(ra) # 80000d6a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003634:	0023c797          	auipc	a5,0x23c
    80003638:	dcc78793          	addi	a5,a5,-564 # 8023f400 <bcache+0x8000>
    8000363c:	0023c717          	auipc	a4,0x23c
    80003640:	02c70713          	addi	a4,a4,44 # 8023f668 <bcache+0x8268>
    80003644:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003648:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000364c:	00234497          	auipc	s1,0x234
    80003650:	dcc48493          	addi	s1,s1,-564 # 80237418 <bcache+0x18>
    b->next = bcache.head.next;
    80003654:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003656:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003658:	00005a17          	auipc	s4,0x5
    8000365c:	f20a0a13          	addi	s4,s4,-224 # 80008578 <syscalls+0xd0>
    b->next = bcache.head.next;
    80003660:	2b893783          	ld	a5,696(s2)
    80003664:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003666:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000366a:	85d2                	mv	a1,s4
    8000366c:	01048513          	addi	a0,s1,16
    80003670:	00001097          	auipc	ra,0x1
    80003674:	4c4080e7          	jalr	1220(ra) # 80004b34 <initsleeplock>
    bcache.head.next->prev = b;
    80003678:	2b893783          	ld	a5,696(s2)
    8000367c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000367e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003682:	45848493          	addi	s1,s1,1112
    80003686:	fd349de3          	bne	s1,s3,80003660 <binit+0x54>
  }
}
    8000368a:	70a2                	ld	ra,40(sp)
    8000368c:	7402                	ld	s0,32(sp)
    8000368e:	64e2                	ld	s1,24(sp)
    80003690:	6942                	ld	s2,16(sp)
    80003692:	69a2                	ld	s3,8(sp)
    80003694:	6a02                	ld	s4,0(sp)
    80003696:	6145                	addi	sp,sp,48
    80003698:	8082                	ret

000000008000369a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000369a:	7179                	addi	sp,sp,-48
    8000369c:	f406                	sd	ra,40(sp)
    8000369e:	f022                	sd	s0,32(sp)
    800036a0:	ec26                	sd	s1,24(sp)
    800036a2:	e84a                	sd	s2,16(sp)
    800036a4:	e44e                	sd	s3,8(sp)
    800036a6:	1800                	addi	s0,sp,48
    800036a8:	892a                	mv	s2,a0
    800036aa:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800036ac:	00234517          	auipc	a0,0x234
    800036b0:	d5450513          	addi	a0,a0,-684 # 80237400 <bcache>
    800036b4:	ffffd097          	auipc	ra,0xffffd
    800036b8:	746080e7          	jalr	1862(ra) # 80000dfa <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800036bc:	0023c497          	auipc	s1,0x23c
    800036c0:	ffc4b483          	ld	s1,-4(s1) # 8023f6b8 <bcache+0x82b8>
    800036c4:	0023c797          	auipc	a5,0x23c
    800036c8:	fa478793          	addi	a5,a5,-92 # 8023f668 <bcache+0x8268>
    800036cc:	02f48f63          	beq	s1,a5,8000370a <bread+0x70>
    800036d0:	873e                	mv	a4,a5
    800036d2:	a021                	j	800036da <bread+0x40>
    800036d4:	68a4                	ld	s1,80(s1)
    800036d6:	02e48a63          	beq	s1,a4,8000370a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800036da:	449c                	lw	a5,8(s1)
    800036dc:	ff279ce3          	bne	a5,s2,800036d4 <bread+0x3a>
    800036e0:	44dc                	lw	a5,12(s1)
    800036e2:	ff3799e3          	bne	a5,s3,800036d4 <bread+0x3a>
      b->refcnt++;
    800036e6:	40bc                	lw	a5,64(s1)
    800036e8:	2785                	addiw	a5,a5,1
    800036ea:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800036ec:	00234517          	auipc	a0,0x234
    800036f0:	d1450513          	addi	a0,a0,-748 # 80237400 <bcache>
    800036f4:	ffffd097          	auipc	ra,0xffffd
    800036f8:	7ba080e7          	jalr	1978(ra) # 80000eae <release>
      acquiresleep(&b->lock);
    800036fc:	01048513          	addi	a0,s1,16
    80003700:	00001097          	auipc	ra,0x1
    80003704:	46e080e7          	jalr	1134(ra) # 80004b6e <acquiresleep>
      return b;
    80003708:	a8b9                	j	80003766 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000370a:	0023c497          	auipc	s1,0x23c
    8000370e:	fa64b483          	ld	s1,-90(s1) # 8023f6b0 <bcache+0x82b0>
    80003712:	0023c797          	auipc	a5,0x23c
    80003716:	f5678793          	addi	a5,a5,-170 # 8023f668 <bcache+0x8268>
    8000371a:	00f48863          	beq	s1,a5,8000372a <bread+0x90>
    8000371e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003720:	40bc                	lw	a5,64(s1)
    80003722:	cf81                	beqz	a5,8000373a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003724:	64a4                	ld	s1,72(s1)
    80003726:	fee49de3          	bne	s1,a4,80003720 <bread+0x86>
  panic("bget: no buffers");
    8000372a:	00005517          	auipc	a0,0x5
    8000372e:	e5650513          	addi	a0,a0,-426 # 80008580 <syscalls+0xd8>
    80003732:	ffffd097          	auipc	ra,0xffffd
    80003736:	e0c080e7          	jalr	-500(ra) # 8000053e <panic>
      b->dev = dev;
    8000373a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000373e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003742:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003746:	4785                	li	a5,1
    80003748:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000374a:	00234517          	auipc	a0,0x234
    8000374e:	cb650513          	addi	a0,a0,-842 # 80237400 <bcache>
    80003752:	ffffd097          	auipc	ra,0xffffd
    80003756:	75c080e7          	jalr	1884(ra) # 80000eae <release>
      acquiresleep(&b->lock);
    8000375a:	01048513          	addi	a0,s1,16
    8000375e:	00001097          	auipc	ra,0x1
    80003762:	410080e7          	jalr	1040(ra) # 80004b6e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003766:	409c                	lw	a5,0(s1)
    80003768:	cb89                	beqz	a5,8000377a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000376a:	8526                	mv	a0,s1
    8000376c:	70a2                	ld	ra,40(sp)
    8000376e:	7402                	ld	s0,32(sp)
    80003770:	64e2                	ld	s1,24(sp)
    80003772:	6942                	ld	s2,16(sp)
    80003774:	69a2                	ld	s3,8(sp)
    80003776:	6145                	addi	sp,sp,48
    80003778:	8082                	ret
    virtio_disk_rw(b, 0);
    8000377a:	4581                	li	a1,0
    8000377c:	8526                	mv	a0,s1
    8000377e:	00003097          	auipc	ra,0x3
    80003782:	ff6080e7          	jalr	-10(ra) # 80006774 <virtio_disk_rw>
    b->valid = 1;
    80003786:	4785                	li	a5,1
    80003788:	c09c                	sw	a5,0(s1)
  return b;
    8000378a:	b7c5                	j	8000376a <bread+0xd0>

000000008000378c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000378c:	1101                	addi	sp,sp,-32
    8000378e:	ec06                	sd	ra,24(sp)
    80003790:	e822                	sd	s0,16(sp)
    80003792:	e426                	sd	s1,8(sp)
    80003794:	1000                	addi	s0,sp,32
    80003796:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003798:	0541                	addi	a0,a0,16
    8000379a:	00001097          	auipc	ra,0x1
    8000379e:	46e080e7          	jalr	1134(ra) # 80004c08 <holdingsleep>
    800037a2:	cd01                	beqz	a0,800037ba <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800037a4:	4585                	li	a1,1
    800037a6:	8526                	mv	a0,s1
    800037a8:	00003097          	auipc	ra,0x3
    800037ac:	fcc080e7          	jalr	-52(ra) # 80006774 <virtio_disk_rw>
}
    800037b0:	60e2                	ld	ra,24(sp)
    800037b2:	6442                	ld	s0,16(sp)
    800037b4:	64a2                	ld	s1,8(sp)
    800037b6:	6105                	addi	sp,sp,32
    800037b8:	8082                	ret
    panic("bwrite");
    800037ba:	00005517          	auipc	a0,0x5
    800037be:	dde50513          	addi	a0,a0,-546 # 80008598 <syscalls+0xf0>
    800037c2:	ffffd097          	auipc	ra,0xffffd
    800037c6:	d7c080e7          	jalr	-644(ra) # 8000053e <panic>

00000000800037ca <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800037ca:	1101                	addi	sp,sp,-32
    800037cc:	ec06                	sd	ra,24(sp)
    800037ce:	e822                	sd	s0,16(sp)
    800037d0:	e426                	sd	s1,8(sp)
    800037d2:	e04a                	sd	s2,0(sp)
    800037d4:	1000                	addi	s0,sp,32
    800037d6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800037d8:	01050913          	addi	s2,a0,16
    800037dc:	854a                	mv	a0,s2
    800037de:	00001097          	auipc	ra,0x1
    800037e2:	42a080e7          	jalr	1066(ra) # 80004c08 <holdingsleep>
    800037e6:	c92d                	beqz	a0,80003858 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800037e8:	854a                	mv	a0,s2
    800037ea:	00001097          	auipc	ra,0x1
    800037ee:	3da080e7          	jalr	986(ra) # 80004bc4 <releasesleep>

  acquire(&bcache.lock);
    800037f2:	00234517          	auipc	a0,0x234
    800037f6:	c0e50513          	addi	a0,a0,-1010 # 80237400 <bcache>
    800037fa:	ffffd097          	auipc	ra,0xffffd
    800037fe:	600080e7          	jalr	1536(ra) # 80000dfa <acquire>
  b->refcnt--;
    80003802:	40bc                	lw	a5,64(s1)
    80003804:	37fd                	addiw	a5,a5,-1
    80003806:	0007871b          	sext.w	a4,a5
    8000380a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000380c:	eb05                	bnez	a4,8000383c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000380e:	68bc                	ld	a5,80(s1)
    80003810:	64b8                	ld	a4,72(s1)
    80003812:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003814:	64bc                	ld	a5,72(s1)
    80003816:	68b8                	ld	a4,80(s1)
    80003818:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000381a:	0023c797          	auipc	a5,0x23c
    8000381e:	be678793          	addi	a5,a5,-1050 # 8023f400 <bcache+0x8000>
    80003822:	2b87b703          	ld	a4,696(a5)
    80003826:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003828:	0023c717          	auipc	a4,0x23c
    8000382c:	e4070713          	addi	a4,a4,-448 # 8023f668 <bcache+0x8268>
    80003830:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003832:	2b87b703          	ld	a4,696(a5)
    80003836:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003838:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000383c:	00234517          	auipc	a0,0x234
    80003840:	bc450513          	addi	a0,a0,-1084 # 80237400 <bcache>
    80003844:	ffffd097          	auipc	ra,0xffffd
    80003848:	66a080e7          	jalr	1642(ra) # 80000eae <release>
}
    8000384c:	60e2                	ld	ra,24(sp)
    8000384e:	6442                	ld	s0,16(sp)
    80003850:	64a2                	ld	s1,8(sp)
    80003852:	6902                	ld	s2,0(sp)
    80003854:	6105                	addi	sp,sp,32
    80003856:	8082                	ret
    panic("brelse");
    80003858:	00005517          	auipc	a0,0x5
    8000385c:	d4850513          	addi	a0,a0,-696 # 800085a0 <syscalls+0xf8>
    80003860:	ffffd097          	auipc	ra,0xffffd
    80003864:	cde080e7          	jalr	-802(ra) # 8000053e <panic>

0000000080003868 <bpin>:

void
bpin(struct buf *b) {
    80003868:	1101                	addi	sp,sp,-32
    8000386a:	ec06                	sd	ra,24(sp)
    8000386c:	e822                	sd	s0,16(sp)
    8000386e:	e426                	sd	s1,8(sp)
    80003870:	1000                	addi	s0,sp,32
    80003872:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003874:	00234517          	auipc	a0,0x234
    80003878:	b8c50513          	addi	a0,a0,-1140 # 80237400 <bcache>
    8000387c:	ffffd097          	auipc	ra,0xffffd
    80003880:	57e080e7          	jalr	1406(ra) # 80000dfa <acquire>
  b->refcnt++;
    80003884:	40bc                	lw	a5,64(s1)
    80003886:	2785                	addiw	a5,a5,1
    80003888:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000388a:	00234517          	auipc	a0,0x234
    8000388e:	b7650513          	addi	a0,a0,-1162 # 80237400 <bcache>
    80003892:	ffffd097          	auipc	ra,0xffffd
    80003896:	61c080e7          	jalr	1564(ra) # 80000eae <release>
}
    8000389a:	60e2                	ld	ra,24(sp)
    8000389c:	6442                	ld	s0,16(sp)
    8000389e:	64a2                	ld	s1,8(sp)
    800038a0:	6105                	addi	sp,sp,32
    800038a2:	8082                	ret

00000000800038a4 <bunpin>:

void
bunpin(struct buf *b) {
    800038a4:	1101                	addi	sp,sp,-32
    800038a6:	ec06                	sd	ra,24(sp)
    800038a8:	e822                	sd	s0,16(sp)
    800038aa:	e426                	sd	s1,8(sp)
    800038ac:	1000                	addi	s0,sp,32
    800038ae:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800038b0:	00234517          	auipc	a0,0x234
    800038b4:	b5050513          	addi	a0,a0,-1200 # 80237400 <bcache>
    800038b8:	ffffd097          	auipc	ra,0xffffd
    800038bc:	542080e7          	jalr	1346(ra) # 80000dfa <acquire>
  b->refcnt--;
    800038c0:	40bc                	lw	a5,64(s1)
    800038c2:	37fd                	addiw	a5,a5,-1
    800038c4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800038c6:	00234517          	auipc	a0,0x234
    800038ca:	b3a50513          	addi	a0,a0,-1222 # 80237400 <bcache>
    800038ce:	ffffd097          	auipc	ra,0xffffd
    800038d2:	5e0080e7          	jalr	1504(ra) # 80000eae <release>
}
    800038d6:	60e2                	ld	ra,24(sp)
    800038d8:	6442                	ld	s0,16(sp)
    800038da:	64a2                	ld	s1,8(sp)
    800038dc:	6105                	addi	sp,sp,32
    800038de:	8082                	ret

00000000800038e0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800038e0:	1101                	addi	sp,sp,-32
    800038e2:	ec06                	sd	ra,24(sp)
    800038e4:	e822                	sd	s0,16(sp)
    800038e6:	e426                	sd	s1,8(sp)
    800038e8:	e04a                	sd	s2,0(sp)
    800038ea:	1000                	addi	s0,sp,32
    800038ec:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800038ee:	00d5d59b          	srliw	a1,a1,0xd
    800038f2:	0023c797          	auipc	a5,0x23c
    800038f6:	1ea7a783          	lw	a5,490(a5) # 8023fadc <sb+0x1c>
    800038fa:	9dbd                	addw	a1,a1,a5
    800038fc:	00000097          	auipc	ra,0x0
    80003900:	d9e080e7          	jalr	-610(ra) # 8000369a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003904:	0074f713          	andi	a4,s1,7
    80003908:	4785                	li	a5,1
    8000390a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000390e:	14ce                	slli	s1,s1,0x33
    80003910:	90d9                	srli	s1,s1,0x36
    80003912:	00950733          	add	a4,a0,s1
    80003916:	05874703          	lbu	a4,88(a4)
    8000391a:	00e7f6b3          	and	a3,a5,a4
    8000391e:	c69d                	beqz	a3,8000394c <bfree+0x6c>
    80003920:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003922:	94aa                	add	s1,s1,a0
    80003924:	fff7c793          	not	a5,a5
    80003928:	8ff9                	and	a5,a5,a4
    8000392a:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000392e:	00001097          	auipc	ra,0x1
    80003932:	120080e7          	jalr	288(ra) # 80004a4e <log_write>
  brelse(bp);
    80003936:	854a                	mv	a0,s2
    80003938:	00000097          	auipc	ra,0x0
    8000393c:	e92080e7          	jalr	-366(ra) # 800037ca <brelse>
}
    80003940:	60e2                	ld	ra,24(sp)
    80003942:	6442                	ld	s0,16(sp)
    80003944:	64a2                	ld	s1,8(sp)
    80003946:	6902                	ld	s2,0(sp)
    80003948:	6105                	addi	sp,sp,32
    8000394a:	8082                	ret
    panic("freeing free block");
    8000394c:	00005517          	auipc	a0,0x5
    80003950:	c5c50513          	addi	a0,a0,-932 # 800085a8 <syscalls+0x100>
    80003954:	ffffd097          	auipc	ra,0xffffd
    80003958:	bea080e7          	jalr	-1046(ra) # 8000053e <panic>

000000008000395c <balloc>:
{
    8000395c:	711d                	addi	sp,sp,-96
    8000395e:	ec86                	sd	ra,88(sp)
    80003960:	e8a2                	sd	s0,80(sp)
    80003962:	e4a6                	sd	s1,72(sp)
    80003964:	e0ca                	sd	s2,64(sp)
    80003966:	fc4e                	sd	s3,56(sp)
    80003968:	f852                	sd	s4,48(sp)
    8000396a:	f456                	sd	s5,40(sp)
    8000396c:	f05a                	sd	s6,32(sp)
    8000396e:	ec5e                	sd	s7,24(sp)
    80003970:	e862                	sd	s8,16(sp)
    80003972:	e466                	sd	s9,8(sp)
    80003974:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003976:	0023c797          	auipc	a5,0x23c
    8000397a:	14e7a783          	lw	a5,334(a5) # 8023fac4 <sb+0x4>
    8000397e:	10078163          	beqz	a5,80003a80 <balloc+0x124>
    80003982:	8baa                	mv	s7,a0
    80003984:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003986:	0023cb17          	auipc	s6,0x23c
    8000398a:	13ab0b13          	addi	s6,s6,314 # 8023fac0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000398e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003990:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003992:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003994:	6c89                	lui	s9,0x2
    80003996:	a061                	j	80003a1e <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003998:	974a                	add	a4,a4,s2
    8000399a:	8fd5                	or	a5,a5,a3
    8000399c:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800039a0:	854a                	mv	a0,s2
    800039a2:	00001097          	auipc	ra,0x1
    800039a6:	0ac080e7          	jalr	172(ra) # 80004a4e <log_write>
        brelse(bp);
    800039aa:	854a                	mv	a0,s2
    800039ac:	00000097          	auipc	ra,0x0
    800039b0:	e1e080e7          	jalr	-482(ra) # 800037ca <brelse>
  bp = bread(dev, bno);
    800039b4:	85a6                	mv	a1,s1
    800039b6:	855e                	mv	a0,s7
    800039b8:	00000097          	auipc	ra,0x0
    800039bc:	ce2080e7          	jalr	-798(ra) # 8000369a <bread>
    800039c0:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800039c2:	40000613          	li	a2,1024
    800039c6:	4581                	li	a1,0
    800039c8:	05850513          	addi	a0,a0,88
    800039cc:	ffffd097          	auipc	ra,0xffffd
    800039d0:	52a080e7          	jalr	1322(ra) # 80000ef6 <memset>
  log_write(bp);
    800039d4:	854a                	mv	a0,s2
    800039d6:	00001097          	auipc	ra,0x1
    800039da:	078080e7          	jalr	120(ra) # 80004a4e <log_write>
  brelse(bp);
    800039de:	854a                	mv	a0,s2
    800039e0:	00000097          	auipc	ra,0x0
    800039e4:	dea080e7          	jalr	-534(ra) # 800037ca <brelse>
}
    800039e8:	8526                	mv	a0,s1
    800039ea:	60e6                	ld	ra,88(sp)
    800039ec:	6446                	ld	s0,80(sp)
    800039ee:	64a6                	ld	s1,72(sp)
    800039f0:	6906                	ld	s2,64(sp)
    800039f2:	79e2                	ld	s3,56(sp)
    800039f4:	7a42                	ld	s4,48(sp)
    800039f6:	7aa2                	ld	s5,40(sp)
    800039f8:	7b02                	ld	s6,32(sp)
    800039fa:	6be2                	ld	s7,24(sp)
    800039fc:	6c42                	ld	s8,16(sp)
    800039fe:	6ca2                	ld	s9,8(sp)
    80003a00:	6125                	addi	sp,sp,96
    80003a02:	8082                	ret
    brelse(bp);
    80003a04:	854a                	mv	a0,s2
    80003a06:	00000097          	auipc	ra,0x0
    80003a0a:	dc4080e7          	jalr	-572(ra) # 800037ca <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003a0e:	015c87bb          	addw	a5,s9,s5
    80003a12:	00078a9b          	sext.w	s5,a5
    80003a16:	004b2703          	lw	a4,4(s6)
    80003a1a:	06eaf363          	bgeu	s5,a4,80003a80 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80003a1e:	41fad79b          	sraiw	a5,s5,0x1f
    80003a22:	0137d79b          	srliw	a5,a5,0x13
    80003a26:	015787bb          	addw	a5,a5,s5
    80003a2a:	40d7d79b          	sraiw	a5,a5,0xd
    80003a2e:	01cb2583          	lw	a1,28(s6)
    80003a32:	9dbd                	addw	a1,a1,a5
    80003a34:	855e                	mv	a0,s7
    80003a36:	00000097          	auipc	ra,0x0
    80003a3a:	c64080e7          	jalr	-924(ra) # 8000369a <bread>
    80003a3e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003a40:	004b2503          	lw	a0,4(s6)
    80003a44:	000a849b          	sext.w	s1,s5
    80003a48:	8662                	mv	a2,s8
    80003a4a:	faa4fde3          	bgeu	s1,a0,80003a04 <balloc+0xa8>
      m = 1 << (bi % 8);
    80003a4e:	41f6579b          	sraiw	a5,a2,0x1f
    80003a52:	01d7d69b          	srliw	a3,a5,0x1d
    80003a56:	00c6873b          	addw	a4,a3,a2
    80003a5a:	00777793          	andi	a5,a4,7
    80003a5e:	9f95                	subw	a5,a5,a3
    80003a60:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003a64:	4037571b          	sraiw	a4,a4,0x3
    80003a68:	00e906b3          	add	a3,s2,a4
    80003a6c:	0586c683          	lbu	a3,88(a3)
    80003a70:	00d7f5b3          	and	a1,a5,a3
    80003a74:	d195                	beqz	a1,80003998 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003a76:	2605                	addiw	a2,a2,1
    80003a78:	2485                	addiw	s1,s1,1
    80003a7a:	fd4618e3          	bne	a2,s4,80003a4a <balloc+0xee>
    80003a7e:	b759                	j	80003a04 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80003a80:	00005517          	auipc	a0,0x5
    80003a84:	b4050513          	addi	a0,a0,-1216 # 800085c0 <syscalls+0x118>
    80003a88:	ffffd097          	auipc	ra,0xffffd
    80003a8c:	b00080e7          	jalr	-1280(ra) # 80000588 <printf>
  return 0;
    80003a90:	4481                	li	s1,0
    80003a92:	bf99                	j	800039e8 <balloc+0x8c>

0000000080003a94 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003a94:	7179                	addi	sp,sp,-48
    80003a96:	f406                	sd	ra,40(sp)
    80003a98:	f022                	sd	s0,32(sp)
    80003a9a:	ec26                	sd	s1,24(sp)
    80003a9c:	e84a                	sd	s2,16(sp)
    80003a9e:	e44e                	sd	s3,8(sp)
    80003aa0:	e052                	sd	s4,0(sp)
    80003aa2:	1800                	addi	s0,sp,48
    80003aa4:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003aa6:	47ad                	li	a5,11
    80003aa8:	02b7e763          	bltu	a5,a1,80003ad6 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80003aac:	02059493          	slli	s1,a1,0x20
    80003ab0:	9081                	srli	s1,s1,0x20
    80003ab2:	048a                	slli	s1,s1,0x2
    80003ab4:	94aa                	add	s1,s1,a0
    80003ab6:	0504a903          	lw	s2,80(s1)
    80003aba:	06091e63          	bnez	s2,80003b36 <bmap+0xa2>
      addr = balloc(ip->dev);
    80003abe:	4108                	lw	a0,0(a0)
    80003ac0:	00000097          	auipc	ra,0x0
    80003ac4:	e9c080e7          	jalr	-356(ra) # 8000395c <balloc>
    80003ac8:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003acc:	06090563          	beqz	s2,80003b36 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80003ad0:	0524a823          	sw	s2,80(s1)
    80003ad4:	a08d                	j	80003b36 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003ad6:	ff45849b          	addiw	s1,a1,-12
    80003ada:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003ade:	0ff00793          	li	a5,255
    80003ae2:	08e7e563          	bltu	a5,a4,80003b6c <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003ae6:	08052903          	lw	s2,128(a0)
    80003aea:	00091d63          	bnez	s2,80003b04 <bmap+0x70>
      addr = balloc(ip->dev);
    80003aee:	4108                	lw	a0,0(a0)
    80003af0:	00000097          	auipc	ra,0x0
    80003af4:	e6c080e7          	jalr	-404(ra) # 8000395c <balloc>
    80003af8:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003afc:	02090d63          	beqz	s2,80003b36 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003b00:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80003b04:	85ca                	mv	a1,s2
    80003b06:	0009a503          	lw	a0,0(s3)
    80003b0a:	00000097          	auipc	ra,0x0
    80003b0e:	b90080e7          	jalr	-1136(ra) # 8000369a <bread>
    80003b12:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003b14:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003b18:	02049593          	slli	a1,s1,0x20
    80003b1c:	9181                	srli	a1,a1,0x20
    80003b1e:	058a                	slli	a1,a1,0x2
    80003b20:	00b784b3          	add	s1,a5,a1
    80003b24:	0004a903          	lw	s2,0(s1)
    80003b28:	02090063          	beqz	s2,80003b48 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003b2c:	8552                	mv	a0,s4
    80003b2e:	00000097          	auipc	ra,0x0
    80003b32:	c9c080e7          	jalr	-868(ra) # 800037ca <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003b36:	854a                	mv	a0,s2
    80003b38:	70a2                	ld	ra,40(sp)
    80003b3a:	7402                	ld	s0,32(sp)
    80003b3c:	64e2                	ld	s1,24(sp)
    80003b3e:	6942                	ld	s2,16(sp)
    80003b40:	69a2                	ld	s3,8(sp)
    80003b42:	6a02                	ld	s4,0(sp)
    80003b44:	6145                	addi	sp,sp,48
    80003b46:	8082                	ret
      addr = balloc(ip->dev);
    80003b48:	0009a503          	lw	a0,0(s3)
    80003b4c:	00000097          	auipc	ra,0x0
    80003b50:	e10080e7          	jalr	-496(ra) # 8000395c <balloc>
    80003b54:	0005091b          	sext.w	s2,a0
      if(addr){
    80003b58:	fc090ae3          	beqz	s2,80003b2c <bmap+0x98>
        a[bn] = addr;
    80003b5c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003b60:	8552                	mv	a0,s4
    80003b62:	00001097          	auipc	ra,0x1
    80003b66:	eec080e7          	jalr	-276(ra) # 80004a4e <log_write>
    80003b6a:	b7c9                	j	80003b2c <bmap+0x98>
  panic("bmap: out of range");
    80003b6c:	00005517          	auipc	a0,0x5
    80003b70:	a6c50513          	addi	a0,a0,-1428 # 800085d8 <syscalls+0x130>
    80003b74:	ffffd097          	auipc	ra,0xffffd
    80003b78:	9ca080e7          	jalr	-1590(ra) # 8000053e <panic>

0000000080003b7c <iget>:
{
    80003b7c:	7179                	addi	sp,sp,-48
    80003b7e:	f406                	sd	ra,40(sp)
    80003b80:	f022                	sd	s0,32(sp)
    80003b82:	ec26                	sd	s1,24(sp)
    80003b84:	e84a                	sd	s2,16(sp)
    80003b86:	e44e                	sd	s3,8(sp)
    80003b88:	e052                	sd	s4,0(sp)
    80003b8a:	1800                	addi	s0,sp,48
    80003b8c:	89aa                	mv	s3,a0
    80003b8e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003b90:	0023c517          	auipc	a0,0x23c
    80003b94:	f5050513          	addi	a0,a0,-176 # 8023fae0 <itable>
    80003b98:	ffffd097          	auipc	ra,0xffffd
    80003b9c:	262080e7          	jalr	610(ra) # 80000dfa <acquire>
  empty = 0;
    80003ba0:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003ba2:	0023c497          	auipc	s1,0x23c
    80003ba6:	f5648493          	addi	s1,s1,-170 # 8023faf8 <itable+0x18>
    80003baa:	0023e697          	auipc	a3,0x23e
    80003bae:	9de68693          	addi	a3,a3,-1570 # 80241588 <log>
    80003bb2:	a039                	j	80003bc0 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003bb4:	02090b63          	beqz	s2,80003bea <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003bb8:	08848493          	addi	s1,s1,136
    80003bbc:	02d48a63          	beq	s1,a3,80003bf0 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003bc0:	449c                	lw	a5,8(s1)
    80003bc2:	fef059e3          	blez	a5,80003bb4 <iget+0x38>
    80003bc6:	4098                	lw	a4,0(s1)
    80003bc8:	ff3716e3          	bne	a4,s3,80003bb4 <iget+0x38>
    80003bcc:	40d8                	lw	a4,4(s1)
    80003bce:	ff4713e3          	bne	a4,s4,80003bb4 <iget+0x38>
      ip->ref++;
    80003bd2:	2785                	addiw	a5,a5,1
    80003bd4:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003bd6:	0023c517          	auipc	a0,0x23c
    80003bda:	f0a50513          	addi	a0,a0,-246 # 8023fae0 <itable>
    80003bde:	ffffd097          	auipc	ra,0xffffd
    80003be2:	2d0080e7          	jalr	720(ra) # 80000eae <release>
      return ip;
    80003be6:	8926                	mv	s2,s1
    80003be8:	a03d                	j	80003c16 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003bea:	f7f9                	bnez	a5,80003bb8 <iget+0x3c>
    80003bec:	8926                	mv	s2,s1
    80003bee:	b7e9                	j	80003bb8 <iget+0x3c>
  if(empty == 0)
    80003bf0:	02090c63          	beqz	s2,80003c28 <iget+0xac>
  ip->dev = dev;
    80003bf4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003bf8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003bfc:	4785                	li	a5,1
    80003bfe:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003c02:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003c06:	0023c517          	auipc	a0,0x23c
    80003c0a:	eda50513          	addi	a0,a0,-294 # 8023fae0 <itable>
    80003c0e:	ffffd097          	auipc	ra,0xffffd
    80003c12:	2a0080e7          	jalr	672(ra) # 80000eae <release>
}
    80003c16:	854a                	mv	a0,s2
    80003c18:	70a2                	ld	ra,40(sp)
    80003c1a:	7402                	ld	s0,32(sp)
    80003c1c:	64e2                	ld	s1,24(sp)
    80003c1e:	6942                	ld	s2,16(sp)
    80003c20:	69a2                	ld	s3,8(sp)
    80003c22:	6a02                	ld	s4,0(sp)
    80003c24:	6145                	addi	sp,sp,48
    80003c26:	8082                	ret
    panic("iget: no inodes");
    80003c28:	00005517          	auipc	a0,0x5
    80003c2c:	9c850513          	addi	a0,a0,-1592 # 800085f0 <syscalls+0x148>
    80003c30:	ffffd097          	auipc	ra,0xffffd
    80003c34:	90e080e7          	jalr	-1778(ra) # 8000053e <panic>

0000000080003c38 <fsinit>:
fsinit(int dev) {
    80003c38:	7179                	addi	sp,sp,-48
    80003c3a:	f406                	sd	ra,40(sp)
    80003c3c:	f022                	sd	s0,32(sp)
    80003c3e:	ec26                	sd	s1,24(sp)
    80003c40:	e84a                	sd	s2,16(sp)
    80003c42:	e44e                	sd	s3,8(sp)
    80003c44:	1800                	addi	s0,sp,48
    80003c46:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003c48:	4585                	li	a1,1
    80003c4a:	00000097          	auipc	ra,0x0
    80003c4e:	a50080e7          	jalr	-1456(ra) # 8000369a <bread>
    80003c52:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003c54:	0023c997          	auipc	s3,0x23c
    80003c58:	e6c98993          	addi	s3,s3,-404 # 8023fac0 <sb>
    80003c5c:	02000613          	li	a2,32
    80003c60:	05850593          	addi	a1,a0,88
    80003c64:	854e                	mv	a0,s3
    80003c66:	ffffd097          	auipc	ra,0xffffd
    80003c6a:	2ec080e7          	jalr	748(ra) # 80000f52 <memmove>
  brelse(bp);
    80003c6e:	8526                	mv	a0,s1
    80003c70:	00000097          	auipc	ra,0x0
    80003c74:	b5a080e7          	jalr	-1190(ra) # 800037ca <brelse>
  if(sb.magic != FSMAGIC)
    80003c78:	0009a703          	lw	a4,0(s3)
    80003c7c:	102037b7          	lui	a5,0x10203
    80003c80:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003c84:	02f71263          	bne	a4,a5,80003ca8 <fsinit+0x70>
  initlog(dev, &sb);
    80003c88:	0023c597          	auipc	a1,0x23c
    80003c8c:	e3858593          	addi	a1,a1,-456 # 8023fac0 <sb>
    80003c90:	854a                	mv	a0,s2
    80003c92:	00001097          	auipc	ra,0x1
    80003c96:	b40080e7          	jalr	-1216(ra) # 800047d2 <initlog>
}
    80003c9a:	70a2                	ld	ra,40(sp)
    80003c9c:	7402                	ld	s0,32(sp)
    80003c9e:	64e2                	ld	s1,24(sp)
    80003ca0:	6942                	ld	s2,16(sp)
    80003ca2:	69a2                	ld	s3,8(sp)
    80003ca4:	6145                	addi	sp,sp,48
    80003ca6:	8082                	ret
    panic("invalid file system");
    80003ca8:	00005517          	auipc	a0,0x5
    80003cac:	95850513          	addi	a0,a0,-1704 # 80008600 <syscalls+0x158>
    80003cb0:	ffffd097          	auipc	ra,0xffffd
    80003cb4:	88e080e7          	jalr	-1906(ra) # 8000053e <panic>

0000000080003cb8 <iinit>:
{
    80003cb8:	7179                	addi	sp,sp,-48
    80003cba:	f406                	sd	ra,40(sp)
    80003cbc:	f022                	sd	s0,32(sp)
    80003cbe:	ec26                	sd	s1,24(sp)
    80003cc0:	e84a                	sd	s2,16(sp)
    80003cc2:	e44e                	sd	s3,8(sp)
    80003cc4:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003cc6:	00005597          	auipc	a1,0x5
    80003cca:	95258593          	addi	a1,a1,-1710 # 80008618 <syscalls+0x170>
    80003cce:	0023c517          	auipc	a0,0x23c
    80003cd2:	e1250513          	addi	a0,a0,-494 # 8023fae0 <itable>
    80003cd6:	ffffd097          	auipc	ra,0xffffd
    80003cda:	094080e7          	jalr	148(ra) # 80000d6a <initlock>
  for(i = 0; i < NINODE; i++) {
    80003cde:	0023c497          	auipc	s1,0x23c
    80003ce2:	e2a48493          	addi	s1,s1,-470 # 8023fb08 <itable+0x28>
    80003ce6:	0023e997          	auipc	s3,0x23e
    80003cea:	8b298993          	addi	s3,s3,-1870 # 80241598 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003cee:	00005917          	auipc	s2,0x5
    80003cf2:	93290913          	addi	s2,s2,-1742 # 80008620 <syscalls+0x178>
    80003cf6:	85ca                	mv	a1,s2
    80003cf8:	8526                	mv	a0,s1
    80003cfa:	00001097          	auipc	ra,0x1
    80003cfe:	e3a080e7          	jalr	-454(ra) # 80004b34 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003d02:	08848493          	addi	s1,s1,136
    80003d06:	ff3498e3          	bne	s1,s3,80003cf6 <iinit+0x3e>
}
    80003d0a:	70a2                	ld	ra,40(sp)
    80003d0c:	7402                	ld	s0,32(sp)
    80003d0e:	64e2                	ld	s1,24(sp)
    80003d10:	6942                	ld	s2,16(sp)
    80003d12:	69a2                	ld	s3,8(sp)
    80003d14:	6145                	addi	sp,sp,48
    80003d16:	8082                	ret

0000000080003d18 <ialloc>:
{
    80003d18:	715d                	addi	sp,sp,-80
    80003d1a:	e486                	sd	ra,72(sp)
    80003d1c:	e0a2                	sd	s0,64(sp)
    80003d1e:	fc26                	sd	s1,56(sp)
    80003d20:	f84a                	sd	s2,48(sp)
    80003d22:	f44e                	sd	s3,40(sp)
    80003d24:	f052                	sd	s4,32(sp)
    80003d26:	ec56                	sd	s5,24(sp)
    80003d28:	e85a                	sd	s6,16(sp)
    80003d2a:	e45e                	sd	s7,8(sp)
    80003d2c:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003d2e:	0023c717          	auipc	a4,0x23c
    80003d32:	d9e72703          	lw	a4,-610(a4) # 8023facc <sb+0xc>
    80003d36:	4785                	li	a5,1
    80003d38:	04e7fa63          	bgeu	a5,a4,80003d8c <ialloc+0x74>
    80003d3c:	8aaa                	mv	s5,a0
    80003d3e:	8bae                	mv	s7,a1
    80003d40:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003d42:	0023ca17          	auipc	s4,0x23c
    80003d46:	d7ea0a13          	addi	s4,s4,-642 # 8023fac0 <sb>
    80003d4a:	00048b1b          	sext.w	s6,s1
    80003d4e:	0044d793          	srli	a5,s1,0x4
    80003d52:	018a2583          	lw	a1,24(s4)
    80003d56:	9dbd                	addw	a1,a1,a5
    80003d58:	8556                	mv	a0,s5
    80003d5a:	00000097          	auipc	ra,0x0
    80003d5e:	940080e7          	jalr	-1728(ra) # 8000369a <bread>
    80003d62:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003d64:	05850993          	addi	s3,a0,88
    80003d68:	00f4f793          	andi	a5,s1,15
    80003d6c:	079a                	slli	a5,a5,0x6
    80003d6e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003d70:	00099783          	lh	a5,0(s3)
    80003d74:	c3a1                	beqz	a5,80003db4 <ialloc+0x9c>
    brelse(bp);
    80003d76:	00000097          	auipc	ra,0x0
    80003d7a:	a54080e7          	jalr	-1452(ra) # 800037ca <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003d7e:	0485                	addi	s1,s1,1
    80003d80:	00ca2703          	lw	a4,12(s4)
    80003d84:	0004879b          	sext.w	a5,s1
    80003d88:	fce7e1e3          	bltu	a5,a4,80003d4a <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80003d8c:	00005517          	auipc	a0,0x5
    80003d90:	89c50513          	addi	a0,a0,-1892 # 80008628 <syscalls+0x180>
    80003d94:	ffffc097          	auipc	ra,0xffffc
    80003d98:	7f4080e7          	jalr	2036(ra) # 80000588 <printf>
  return 0;
    80003d9c:	4501                	li	a0,0
}
    80003d9e:	60a6                	ld	ra,72(sp)
    80003da0:	6406                	ld	s0,64(sp)
    80003da2:	74e2                	ld	s1,56(sp)
    80003da4:	7942                	ld	s2,48(sp)
    80003da6:	79a2                	ld	s3,40(sp)
    80003da8:	7a02                	ld	s4,32(sp)
    80003daa:	6ae2                	ld	s5,24(sp)
    80003dac:	6b42                	ld	s6,16(sp)
    80003dae:	6ba2                	ld	s7,8(sp)
    80003db0:	6161                	addi	sp,sp,80
    80003db2:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003db4:	04000613          	li	a2,64
    80003db8:	4581                	li	a1,0
    80003dba:	854e                	mv	a0,s3
    80003dbc:	ffffd097          	auipc	ra,0xffffd
    80003dc0:	13a080e7          	jalr	314(ra) # 80000ef6 <memset>
      dip->type = type;
    80003dc4:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003dc8:	854a                	mv	a0,s2
    80003dca:	00001097          	auipc	ra,0x1
    80003dce:	c84080e7          	jalr	-892(ra) # 80004a4e <log_write>
      brelse(bp);
    80003dd2:	854a                	mv	a0,s2
    80003dd4:	00000097          	auipc	ra,0x0
    80003dd8:	9f6080e7          	jalr	-1546(ra) # 800037ca <brelse>
      return iget(dev, inum);
    80003ddc:	85da                	mv	a1,s6
    80003dde:	8556                	mv	a0,s5
    80003de0:	00000097          	auipc	ra,0x0
    80003de4:	d9c080e7          	jalr	-612(ra) # 80003b7c <iget>
    80003de8:	bf5d                	j	80003d9e <ialloc+0x86>

0000000080003dea <iupdate>:
{
    80003dea:	1101                	addi	sp,sp,-32
    80003dec:	ec06                	sd	ra,24(sp)
    80003dee:	e822                	sd	s0,16(sp)
    80003df0:	e426                	sd	s1,8(sp)
    80003df2:	e04a                	sd	s2,0(sp)
    80003df4:	1000                	addi	s0,sp,32
    80003df6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003df8:	415c                	lw	a5,4(a0)
    80003dfa:	0047d79b          	srliw	a5,a5,0x4
    80003dfe:	0023c597          	auipc	a1,0x23c
    80003e02:	cda5a583          	lw	a1,-806(a1) # 8023fad8 <sb+0x18>
    80003e06:	9dbd                	addw	a1,a1,a5
    80003e08:	4108                	lw	a0,0(a0)
    80003e0a:	00000097          	auipc	ra,0x0
    80003e0e:	890080e7          	jalr	-1904(ra) # 8000369a <bread>
    80003e12:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003e14:	05850793          	addi	a5,a0,88
    80003e18:	40c8                	lw	a0,4(s1)
    80003e1a:	893d                	andi	a0,a0,15
    80003e1c:	051a                	slli	a0,a0,0x6
    80003e1e:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003e20:	04449703          	lh	a4,68(s1)
    80003e24:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003e28:	04649703          	lh	a4,70(s1)
    80003e2c:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003e30:	04849703          	lh	a4,72(s1)
    80003e34:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003e38:	04a49703          	lh	a4,74(s1)
    80003e3c:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003e40:	44f8                	lw	a4,76(s1)
    80003e42:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003e44:	03400613          	li	a2,52
    80003e48:	05048593          	addi	a1,s1,80
    80003e4c:	0531                	addi	a0,a0,12
    80003e4e:	ffffd097          	auipc	ra,0xffffd
    80003e52:	104080e7          	jalr	260(ra) # 80000f52 <memmove>
  log_write(bp);
    80003e56:	854a                	mv	a0,s2
    80003e58:	00001097          	auipc	ra,0x1
    80003e5c:	bf6080e7          	jalr	-1034(ra) # 80004a4e <log_write>
  brelse(bp);
    80003e60:	854a                	mv	a0,s2
    80003e62:	00000097          	auipc	ra,0x0
    80003e66:	968080e7          	jalr	-1688(ra) # 800037ca <brelse>
}
    80003e6a:	60e2                	ld	ra,24(sp)
    80003e6c:	6442                	ld	s0,16(sp)
    80003e6e:	64a2                	ld	s1,8(sp)
    80003e70:	6902                	ld	s2,0(sp)
    80003e72:	6105                	addi	sp,sp,32
    80003e74:	8082                	ret

0000000080003e76 <idup>:
{
    80003e76:	1101                	addi	sp,sp,-32
    80003e78:	ec06                	sd	ra,24(sp)
    80003e7a:	e822                	sd	s0,16(sp)
    80003e7c:	e426                	sd	s1,8(sp)
    80003e7e:	1000                	addi	s0,sp,32
    80003e80:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003e82:	0023c517          	auipc	a0,0x23c
    80003e86:	c5e50513          	addi	a0,a0,-930 # 8023fae0 <itable>
    80003e8a:	ffffd097          	auipc	ra,0xffffd
    80003e8e:	f70080e7          	jalr	-144(ra) # 80000dfa <acquire>
  ip->ref++;
    80003e92:	449c                	lw	a5,8(s1)
    80003e94:	2785                	addiw	a5,a5,1
    80003e96:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003e98:	0023c517          	auipc	a0,0x23c
    80003e9c:	c4850513          	addi	a0,a0,-952 # 8023fae0 <itable>
    80003ea0:	ffffd097          	auipc	ra,0xffffd
    80003ea4:	00e080e7          	jalr	14(ra) # 80000eae <release>
}
    80003ea8:	8526                	mv	a0,s1
    80003eaa:	60e2                	ld	ra,24(sp)
    80003eac:	6442                	ld	s0,16(sp)
    80003eae:	64a2                	ld	s1,8(sp)
    80003eb0:	6105                	addi	sp,sp,32
    80003eb2:	8082                	ret

0000000080003eb4 <ilock>:
{
    80003eb4:	1101                	addi	sp,sp,-32
    80003eb6:	ec06                	sd	ra,24(sp)
    80003eb8:	e822                	sd	s0,16(sp)
    80003eba:	e426                	sd	s1,8(sp)
    80003ebc:	e04a                	sd	s2,0(sp)
    80003ebe:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003ec0:	c115                	beqz	a0,80003ee4 <ilock+0x30>
    80003ec2:	84aa                	mv	s1,a0
    80003ec4:	451c                	lw	a5,8(a0)
    80003ec6:	00f05f63          	blez	a5,80003ee4 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003eca:	0541                	addi	a0,a0,16
    80003ecc:	00001097          	auipc	ra,0x1
    80003ed0:	ca2080e7          	jalr	-862(ra) # 80004b6e <acquiresleep>
  if(ip->valid == 0){
    80003ed4:	40bc                	lw	a5,64(s1)
    80003ed6:	cf99                	beqz	a5,80003ef4 <ilock+0x40>
}
    80003ed8:	60e2                	ld	ra,24(sp)
    80003eda:	6442                	ld	s0,16(sp)
    80003edc:	64a2                	ld	s1,8(sp)
    80003ede:	6902                	ld	s2,0(sp)
    80003ee0:	6105                	addi	sp,sp,32
    80003ee2:	8082                	ret
    panic("ilock");
    80003ee4:	00004517          	auipc	a0,0x4
    80003ee8:	75c50513          	addi	a0,a0,1884 # 80008640 <syscalls+0x198>
    80003eec:	ffffc097          	auipc	ra,0xffffc
    80003ef0:	652080e7          	jalr	1618(ra) # 8000053e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003ef4:	40dc                	lw	a5,4(s1)
    80003ef6:	0047d79b          	srliw	a5,a5,0x4
    80003efa:	0023c597          	auipc	a1,0x23c
    80003efe:	bde5a583          	lw	a1,-1058(a1) # 8023fad8 <sb+0x18>
    80003f02:	9dbd                	addw	a1,a1,a5
    80003f04:	4088                	lw	a0,0(s1)
    80003f06:	fffff097          	auipc	ra,0xfffff
    80003f0a:	794080e7          	jalr	1940(ra) # 8000369a <bread>
    80003f0e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003f10:	05850593          	addi	a1,a0,88
    80003f14:	40dc                	lw	a5,4(s1)
    80003f16:	8bbd                	andi	a5,a5,15
    80003f18:	079a                	slli	a5,a5,0x6
    80003f1a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003f1c:	00059783          	lh	a5,0(a1)
    80003f20:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003f24:	00259783          	lh	a5,2(a1)
    80003f28:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003f2c:	00459783          	lh	a5,4(a1)
    80003f30:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003f34:	00659783          	lh	a5,6(a1)
    80003f38:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003f3c:	459c                	lw	a5,8(a1)
    80003f3e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003f40:	03400613          	li	a2,52
    80003f44:	05b1                	addi	a1,a1,12
    80003f46:	05048513          	addi	a0,s1,80
    80003f4a:	ffffd097          	auipc	ra,0xffffd
    80003f4e:	008080e7          	jalr	8(ra) # 80000f52 <memmove>
    brelse(bp);
    80003f52:	854a                	mv	a0,s2
    80003f54:	00000097          	auipc	ra,0x0
    80003f58:	876080e7          	jalr	-1930(ra) # 800037ca <brelse>
    ip->valid = 1;
    80003f5c:	4785                	li	a5,1
    80003f5e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003f60:	04449783          	lh	a5,68(s1)
    80003f64:	fbb5                	bnez	a5,80003ed8 <ilock+0x24>
      panic("ilock: no type");
    80003f66:	00004517          	auipc	a0,0x4
    80003f6a:	6e250513          	addi	a0,a0,1762 # 80008648 <syscalls+0x1a0>
    80003f6e:	ffffc097          	auipc	ra,0xffffc
    80003f72:	5d0080e7          	jalr	1488(ra) # 8000053e <panic>

0000000080003f76 <iunlock>:
{
    80003f76:	1101                	addi	sp,sp,-32
    80003f78:	ec06                	sd	ra,24(sp)
    80003f7a:	e822                	sd	s0,16(sp)
    80003f7c:	e426                	sd	s1,8(sp)
    80003f7e:	e04a                	sd	s2,0(sp)
    80003f80:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003f82:	c905                	beqz	a0,80003fb2 <iunlock+0x3c>
    80003f84:	84aa                	mv	s1,a0
    80003f86:	01050913          	addi	s2,a0,16
    80003f8a:	854a                	mv	a0,s2
    80003f8c:	00001097          	auipc	ra,0x1
    80003f90:	c7c080e7          	jalr	-900(ra) # 80004c08 <holdingsleep>
    80003f94:	cd19                	beqz	a0,80003fb2 <iunlock+0x3c>
    80003f96:	449c                	lw	a5,8(s1)
    80003f98:	00f05d63          	blez	a5,80003fb2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003f9c:	854a                	mv	a0,s2
    80003f9e:	00001097          	auipc	ra,0x1
    80003fa2:	c26080e7          	jalr	-986(ra) # 80004bc4 <releasesleep>
}
    80003fa6:	60e2                	ld	ra,24(sp)
    80003fa8:	6442                	ld	s0,16(sp)
    80003faa:	64a2                	ld	s1,8(sp)
    80003fac:	6902                	ld	s2,0(sp)
    80003fae:	6105                	addi	sp,sp,32
    80003fb0:	8082                	ret
    panic("iunlock");
    80003fb2:	00004517          	auipc	a0,0x4
    80003fb6:	6a650513          	addi	a0,a0,1702 # 80008658 <syscalls+0x1b0>
    80003fba:	ffffc097          	auipc	ra,0xffffc
    80003fbe:	584080e7          	jalr	1412(ra) # 8000053e <panic>

0000000080003fc2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003fc2:	7179                	addi	sp,sp,-48
    80003fc4:	f406                	sd	ra,40(sp)
    80003fc6:	f022                	sd	s0,32(sp)
    80003fc8:	ec26                	sd	s1,24(sp)
    80003fca:	e84a                	sd	s2,16(sp)
    80003fcc:	e44e                	sd	s3,8(sp)
    80003fce:	e052                	sd	s4,0(sp)
    80003fd0:	1800                	addi	s0,sp,48
    80003fd2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003fd4:	05050493          	addi	s1,a0,80
    80003fd8:	08050913          	addi	s2,a0,128
    80003fdc:	a021                	j	80003fe4 <itrunc+0x22>
    80003fde:	0491                	addi	s1,s1,4
    80003fe0:	01248d63          	beq	s1,s2,80003ffa <itrunc+0x38>
    if(ip->addrs[i]){
    80003fe4:	408c                	lw	a1,0(s1)
    80003fe6:	dde5                	beqz	a1,80003fde <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003fe8:	0009a503          	lw	a0,0(s3)
    80003fec:	00000097          	auipc	ra,0x0
    80003ff0:	8f4080e7          	jalr	-1804(ra) # 800038e0 <bfree>
      ip->addrs[i] = 0;
    80003ff4:	0004a023          	sw	zero,0(s1)
    80003ff8:	b7dd                	j	80003fde <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003ffa:	0809a583          	lw	a1,128(s3)
    80003ffe:	e185                	bnez	a1,8000401e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80004000:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80004004:	854e                	mv	a0,s3
    80004006:	00000097          	auipc	ra,0x0
    8000400a:	de4080e7          	jalr	-540(ra) # 80003dea <iupdate>
}
    8000400e:	70a2                	ld	ra,40(sp)
    80004010:	7402                	ld	s0,32(sp)
    80004012:	64e2                	ld	s1,24(sp)
    80004014:	6942                	ld	s2,16(sp)
    80004016:	69a2                	ld	s3,8(sp)
    80004018:	6a02                	ld	s4,0(sp)
    8000401a:	6145                	addi	sp,sp,48
    8000401c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000401e:	0009a503          	lw	a0,0(s3)
    80004022:	fffff097          	auipc	ra,0xfffff
    80004026:	678080e7          	jalr	1656(ra) # 8000369a <bread>
    8000402a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000402c:	05850493          	addi	s1,a0,88
    80004030:	45850913          	addi	s2,a0,1112
    80004034:	a021                	j	8000403c <itrunc+0x7a>
    80004036:	0491                	addi	s1,s1,4
    80004038:	01248b63          	beq	s1,s2,8000404e <itrunc+0x8c>
      if(a[j])
    8000403c:	408c                	lw	a1,0(s1)
    8000403e:	dde5                	beqz	a1,80004036 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80004040:	0009a503          	lw	a0,0(s3)
    80004044:	00000097          	auipc	ra,0x0
    80004048:	89c080e7          	jalr	-1892(ra) # 800038e0 <bfree>
    8000404c:	b7ed                	j	80004036 <itrunc+0x74>
    brelse(bp);
    8000404e:	8552                	mv	a0,s4
    80004050:	fffff097          	auipc	ra,0xfffff
    80004054:	77a080e7          	jalr	1914(ra) # 800037ca <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004058:	0809a583          	lw	a1,128(s3)
    8000405c:	0009a503          	lw	a0,0(s3)
    80004060:	00000097          	auipc	ra,0x0
    80004064:	880080e7          	jalr	-1920(ra) # 800038e0 <bfree>
    ip->addrs[NDIRECT] = 0;
    80004068:	0809a023          	sw	zero,128(s3)
    8000406c:	bf51                	j	80004000 <itrunc+0x3e>

000000008000406e <iput>:
{
    8000406e:	1101                	addi	sp,sp,-32
    80004070:	ec06                	sd	ra,24(sp)
    80004072:	e822                	sd	s0,16(sp)
    80004074:	e426                	sd	s1,8(sp)
    80004076:	e04a                	sd	s2,0(sp)
    80004078:	1000                	addi	s0,sp,32
    8000407a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000407c:	0023c517          	auipc	a0,0x23c
    80004080:	a6450513          	addi	a0,a0,-1436 # 8023fae0 <itable>
    80004084:	ffffd097          	auipc	ra,0xffffd
    80004088:	d76080e7          	jalr	-650(ra) # 80000dfa <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000408c:	4498                	lw	a4,8(s1)
    8000408e:	4785                	li	a5,1
    80004090:	02f70363          	beq	a4,a5,800040b6 <iput+0x48>
  ip->ref--;
    80004094:	449c                	lw	a5,8(s1)
    80004096:	37fd                	addiw	a5,a5,-1
    80004098:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000409a:	0023c517          	auipc	a0,0x23c
    8000409e:	a4650513          	addi	a0,a0,-1466 # 8023fae0 <itable>
    800040a2:	ffffd097          	auipc	ra,0xffffd
    800040a6:	e0c080e7          	jalr	-500(ra) # 80000eae <release>
}
    800040aa:	60e2                	ld	ra,24(sp)
    800040ac:	6442                	ld	s0,16(sp)
    800040ae:	64a2                	ld	s1,8(sp)
    800040b0:	6902                	ld	s2,0(sp)
    800040b2:	6105                	addi	sp,sp,32
    800040b4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800040b6:	40bc                	lw	a5,64(s1)
    800040b8:	dff1                	beqz	a5,80004094 <iput+0x26>
    800040ba:	04a49783          	lh	a5,74(s1)
    800040be:	fbf9                	bnez	a5,80004094 <iput+0x26>
    acquiresleep(&ip->lock);
    800040c0:	01048913          	addi	s2,s1,16
    800040c4:	854a                	mv	a0,s2
    800040c6:	00001097          	auipc	ra,0x1
    800040ca:	aa8080e7          	jalr	-1368(ra) # 80004b6e <acquiresleep>
    release(&itable.lock);
    800040ce:	0023c517          	auipc	a0,0x23c
    800040d2:	a1250513          	addi	a0,a0,-1518 # 8023fae0 <itable>
    800040d6:	ffffd097          	auipc	ra,0xffffd
    800040da:	dd8080e7          	jalr	-552(ra) # 80000eae <release>
    itrunc(ip);
    800040de:	8526                	mv	a0,s1
    800040e0:	00000097          	auipc	ra,0x0
    800040e4:	ee2080e7          	jalr	-286(ra) # 80003fc2 <itrunc>
    ip->type = 0;
    800040e8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800040ec:	8526                	mv	a0,s1
    800040ee:	00000097          	auipc	ra,0x0
    800040f2:	cfc080e7          	jalr	-772(ra) # 80003dea <iupdate>
    ip->valid = 0;
    800040f6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800040fa:	854a                	mv	a0,s2
    800040fc:	00001097          	auipc	ra,0x1
    80004100:	ac8080e7          	jalr	-1336(ra) # 80004bc4 <releasesleep>
    acquire(&itable.lock);
    80004104:	0023c517          	auipc	a0,0x23c
    80004108:	9dc50513          	addi	a0,a0,-1572 # 8023fae0 <itable>
    8000410c:	ffffd097          	auipc	ra,0xffffd
    80004110:	cee080e7          	jalr	-786(ra) # 80000dfa <acquire>
    80004114:	b741                	j	80004094 <iput+0x26>

0000000080004116 <iunlockput>:
{
    80004116:	1101                	addi	sp,sp,-32
    80004118:	ec06                	sd	ra,24(sp)
    8000411a:	e822                	sd	s0,16(sp)
    8000411c:	e426                	sd	s1,8(sp)
    8000411e:	1000                	addi	s0,sp,32
    80004120:	84aa                	mv	s1,a0
  iunlock(ip);
    80004122:	00000097          	auipc	ra,0x0
    80004126:	e54080e7          	jalr	-428(ra) # 80003f76 <iunlock>
  iput(ip);
    8000412a:	8526                	mv	a0,s1
    8000412c:	00000097          	auipc	ra,0x0
    80004130:	f42080e7          	jalr	-190(ra) # 8000406e <iput>
}
    80004134:	60e2                	ld	ra,24(sp)
    80004136:	6442                	ld	s0,16(sp)
    80004138:	64a2                	ld	s1,8(sp)
    8000413a:	6105                	addi	sp,sp,32
    8000413c:	8082                	ret

000000008000413e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000413e:	1141                	addi	sp,sp,-16
    80004140:	e422                	sd	s0,8(sp)
    80004142:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80004144:	411c                	lw	a5,0(a0)
    80004146:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80004148:	415c                	lw	a5,4(a0)
    8000414a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000414c:	04451783          	lh	a5,68(a0)
    80004150:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004154:	04a51783          	lh	a5,74(a0)
    80004158:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000415c:	04c56783          	lwu	a5,76(a0)
    80004160:	e99c                	sd	a5,16(a1)
}
    80004162:	6422                	ld	s0,8(sp)
    80004164:	0141                	addi	sp,sp,16
    80004166:	8082                	ret

0000000080004168 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004168:	457c                	lw	a5,76(a0)
    8000416a:	0ed7e963          	bltu	a5,a3,8000425c <readi+0xf4>
{
    8000416e:	7159                	addi	sp,sp,-112
    80004170:	f486                	sd	ra,104(sp)
    80004172:	f0a2                	sd	s0,96(sp)
    80004174:	eca6                	sd	s1,88(sp)
    80004176:	e8ca                	sd	s2,80(sp)
    80004178:	e4ce                	sd	s3,72(sp)
    8000417a:	e0d2                	sd	s4,64(sp)
    8000417c:	fc56                	sd	s5,56(sp)
    8000417e:	f85a                	sd	s6,48(sp)
    80004180:	f45e                	sd	s7,40(sp)
    80004182:	f062                	sd	s8,32(sp)
    80004184:	ec66                	sd	s9,24(sp)
    80004186:	e86a                	sd	s10,16(sp)
    80004188:	e46e                	sd	s11,8(sp)
    8000418a:	1880                	addi	s0,sp,112
    8000418c:	8b2a                	mv	s6,a0
    8000418e:	8bae                	mv	s7,a1
    80004190:	8a32                	mv	s4,a2
    80004192:	84b6                	mv	s1,a3
    80004194:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80004196:	9f35                	addw	a4,a4,a3
    return 0;
    80004198:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000419a:	0ad76063          	bltu	a4,a3,8000423a <readi+0xd2>
  if(off + n > ip->size)
    8000419e:	00e7f463          	bgeu	a5,a4,800041a6 <readi+0x3e>
    n = ip->size - off;
    800041a2:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800041a6:	0a0a8963          	beqz	s5,80004258 <readi+0xf0>
    800041aa:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800041ac:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800041b0:	5c7d                	li	s8,-1
    800041b2:	a82d                	j	800041ec <readi+0x84>
    800041b4:	020d1d93          	slli	s11,s10,0x20
    800041b8:	020ddd93          	srli	s11,s11,0x20
    800041bc:	05890793          	addi	a5,s2,88
    800041c0:	86ee                	mv	a3,s11
    800041c2:	963e                	add	a2,a2,a5
    800041c4:	85d2                	mv	a1,s4
    800041c6:	855e                	mv	a0,s7
    800041c8:	ffffe097          	auipc	ra,0xffffe
    800041cc:	72e080e7          	jalr	1838(ra) # 800028f6 <either_copyout>
    800041d0:	05850d63          	beq	a0,s8,8000422a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800041d4:	854a                	mv	a0,s2
    800041d6:	fffff097          	auipc	ra,0xfffff
    800041da:	5f4080e7          	jalr	1524(ra) # 800037ca <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800041de:	013d09bb          	addw	s3,s10,s3
    800041e2:	009d04bb          	addw	s1,s10,s1
    800041e6:	9a6e                	add	s4,s4,s11
    800041e8:	0559f763          	bgeu	s3,s5,80004236 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800041ec:	00a4d59b          	srliw	a1,s1,0xa
    800041f0:	855a                	mv	a0,s6
    800041f2:	00000097          	auipc	ra,0x0
    800041f6:	8a2080e7          	jalr	-1886(ra) # 80003a94 <bmap>
    800041fa:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800041fe:	cd85                	beqz	a1,80004236 <readi+0xce>
    bp = bread(ip->dev, addr);
    80004200:	000b2503          	lw	a0,0(s6)
    80004204:	fffff097          	auipc	ra,0xfffff
    80004208:	496080e7          	jalr	1174(ra) # 8000369a <bread>
    8000420c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000420e:	3ff4f613          	andi	a2,s1,1023
    80004212:	40cc87bb          	subw	a5,s9,a2
    80004216:	413a873b          	subw	a4,s5,s3
    8000421a:	8d3e                	mv	s10,a5
    8000421c:	2781                	sext.w	a5,a5
    8000421e:	0007069b          	sext.w	a3,a4
    80004222:	f8f6f9e3          	bgeu	a3,a5,800041b4 <readi+0x4c>
    80004226:	8d3a                	mv	s10,a4
    80004228:	b771                	j	800041b4 <readi+0x4c>
      brelse(bp);
    8000422a:	854a                	mv	a0,s2
    8000422c:	fffff097          	auipc	ra,0xfffff
    80004230:	59e080e7          	jalr	1438(ra) # 800037ca <brelse>
      tot = -1;
    80004234:	59fd                	li	s3,-1
  }
  return tot;
    80004236:	0009851b          	sext.w	a0,s3
}
    8000423a:	70a6                	ld	ra,104(sp)
    8000423c:	7406                	ld	s0,96(sp)
    8000423e:	64e6                	ld	s1,88(sp)
    80004240:	6946                	ld	s2,80(sp)
    80004242:	69a6                	ld	s3,72(sp)
    80004244:	6a06                	ld	s4,64(sp)
    80004246:	7ae2                	ld	s5,56(sp)
    80004248:	7b42                	ld	s6,48(sp)
    8000424a:	7ba2                	ld	s7,40(sp)
    8000424c:	7c02                	ld	s8,32(sp)
    8000424e:	6ce2                	ld	s9,24(sp)
    80004250:	6d42                	ld	s10,16(sp)
    80004252:	6da2                	ld	s11,8(sp)
    80004254:	6165                	addi	sp,sp,112
    80004256:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004258:	89d6                	mv	s3,s5
    8000425a:	bff1                	j	80004236 <readi+0xce>
    return 0;
    8000425c:	4501                	li	a0,0
}
    8000425e:	8082                	ret

0000000080004260 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004260:	457c                	lw	a5,76(a0)
    80004262:	10d7e863          	bltu	a5,a3,80004372 <writei+0x112>
{
    80004266:	7159                	addi	sp,sp,-112
    80004268:	f486                	sd	ra,104(sp)
    8000426a:	f0a2                	sd	s0,96(sp)
    8000426c:	eca6                	sd	s1,88(sp)
    8000426e:	e8ca                	sd	s2,80(sp)
    80004270:	e4ce                	sd	s3,72(sp)
    80004272:	e0d2                	sd	s4,64(sp)
    80004274:	fc56                	sd	s5,56(sp)
    80004276:	f85a                	sd	s6,48(sp)
    80004278:	f45e                	sd	s7,40(sp)
    8000427a:	f062                	sd	s8,32(sp)
    8000427c:	ec66                	sd	s9,24(sp)
    8000427e:	e86a                	sd	s10,16(sp)
    80004280:	e46e                	sd	s11,8(sp)
    80004282:	1880                	addi	s0,sp,112
    80004284:	8aaa                	mv	s5,a0
    80004286:	8bae                	mv	s7,a1
    80004288:	8a32                	mv	s4,a2
    8000428a:	8936                	mv	s2,a3
    8000428c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000428e:	00e687bb          	addw	a5,a3,a4
    80004292:	0ed7e263          	bltu	a5,a3,80004376 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004296:	00043737          	lui	a4,0x43
    8000429a:	0ef76063          	bltu	a4,a5,8000437a <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000429e:	0c0b0863          	beqz	s6,8000436e <writei+0x10e>
    800042a2:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800042a4:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800042a8:	5c7d                	li	s8,-1
    800042aa:	a091                	j	800042ee <writei+0x8e>
    800042ac:	020d1d93          	slli	s11,s10,0x20
    800042b0:	020ddd93          	srli	s11,s11,0x20
    800042b4:	05848793          	addi	a5,s1,88
    800042b8:	86ee                	mv	a3,s11
    800042ba:	8652                	mv	a2,s4
    800042bc:	85de                	mv	a1,s7
    800042be:	953e                	add	a0,a0,a5
    800042c0:	ffffe097          	auipc	ra,0xffffe
    800042c4:	68c080e7          	jalr	1676(ra) # 8000294c <either_copyin>
    800042c8:	07850263          	beq	a0,s8,8000432c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800042cc:	8526                	mv	a0,s1
    800042ce:	00000097          	auipc	ra,0x0
    800042d2:	780080e7          	jalr	1920(ra) # 80004a4e <log_write>
    brelse(bp);
    800042d6:	8526                	mv	a0,s1
    800042d8:	fffff097          	auipc	ra,0xfffff
    800042dc:	4f2080e7          	jalr	1266(ra) # 800037ca <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800042e0:	013d09bb          	addw	s3,s10,s3
    800042e4:	012d093b          	addw	s2,s10,s2
    800042e8:	9a6e                	add	s4,s4,s11
    800042ea:	0569f663          	bgeu	s3,s6,80004336 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800042ee:	00a9559b          	srliw	a1,s2,0xa
    800042f2:	8556                	mv	a0,s5
    800042f4:	fffff097          	auipc	ra,0xfffff
    800042f8:	7a0080e7          	jalr	1952(ra) # 80003a94 <bmap>
    800042fc:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80004300:	c99d                	beqz	a1,80004336 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80004302:	000aa503          	lw	a0,0(s5)
    80004306:	fffff097          	auipc	ra,0xfffff
    8000430a:	394080e7          	jalr	916(ra) # 8000369a <bread>
    8000430e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004310:	3ff97513          	andi	a0,s2,1023
    80004314:	40ac87bb          	subw	a5,s9,a0
    80004318:	413b073b          	subw	a4,s6,s3
    8000431c:	8d3e                	mv	s10,a5
    8000431e:	2781                	sext.w	a5,a5
    80004320:	0007069b          	sext.w	a3,a4
    80004324:	f8f6f4e3          	bgeu	a3,a5,800042ac <writei+0x4c>
    80004328:	8d3a                	mv	s10,a4
    8000432a:	b749                	j	800042ac <writei+0x4c>
      brelse(bp);
    8000432c:	8526                	mv	a0,s1
    8000432e:	fffff097          	auipc	ra,0xfffff
    80004332:	49c080e7          	jalr	1180(ra) # 800037ca <brelse>
  }

  if(off > ip->size)
    80004336:	04caa783          	lw	a5,76(s5)
    8000433a:	0127f463          	bgeu	a5,s2,80004342 <writei+0xe2>
    ip->size = off;
    8000433e:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004342:	8556                	mv	a0,s5
    80004344:	00000097          	auipc	ra,0x0
    80004348:	aa6080e7          	jalr	-1370(ra) # 80003dea <iupdate>

  return tot;
    8000434c:	0009851b          	sext.w	a0,s3
}
    80004350:	70a6                	ld	ra,104(sp)
    80004352:	7406                	ld	s0,96(sp)
    80004354:	64e6                	ld	s1,88(sp)
    80004356:	6946                	ld	s2,80(sp)
    80004358:	69a6                	ld	s3,72(sp)
    8000435a:	6a06                	ld	s4,64(sp)
    8000435c:	7ae2                	ld	s5,56(sp)
    8000435e:	7b42                	ld	s6,48(sp)
    80004360:	7ba2                	ld	s7,40(sp)
    80004362:	7c02                	ld	s8,32(sp)
    80004364:	6ce2                	ld	s9,24(sp)
    80004366:	6d42                	ld	s10,16(sp)
    80004368:	6da2                	ld	s11,8(sp)
    8000436a:	6165                	addi	sp,sp,112
    8000436c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000436e:	89da                	mv	s3,s6
    80004370:	bfc9                	j	80004342 <writei+0xe2>
    return -1;
    80004372:	557d                	li	a0,-1
}
    80004374:	8082                	ret
    return -1;
    80004376:	557d                	li	a0,-1
    80004378:	bfe1                	j	80004350 <writei+0xf0>
    return -1;
    8000437a:	557d                	li	a0,-1
    8000437c:	bfd1                	j	80004350 <writei+0xf0>

000000008000437e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000437e:	1141                	addi	sp,sp,-16
    80004380:	e406                	sd	ra,8(sp)
    80004382:	e022                	sd	s0,0(sp)
    80004384:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004386:	4639                	li	a2,14
    80004388:	ffffd097          	auipc	ra,0xffffd
    8000438c:	c3e080e7          	jalr	-962(ra) # 80000fc6 <strncmp>
}
    80004390:	60a2                	ld	ra,8(sp)
    80004392:	6402                	ld	s0,0(sp)
    80004394:	0141                	addi	sp,sp,16
    80004396:	8082                	ret

0000000080004398 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004398:	7139                	addi	sp,sp,-64
    8000439a:	fc06                	sd	ra,56(sp)
    8000439c:	f822                	sd	s0,48(sp)
    8000439e:	f426                	sd	s1,40(sp)
    800043a0:	f04a                	sd	s2,32(sp)
    800043a2:	ec4e                	sd	s3,24(sp)
    800043a4:	e852                	sd	s4,16(sp)
    800043a6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800043a8:	04451703          	lh	a4,68(a0)
    800043ac:	4785                	li	a5,1
    800043ae:	00f71a63          	bne	a4,a5,800043c2 <dirlookup+0x2a>
    800043b2:	892a                	mv	s2,a0
    800043b4:	89ae                	mv	s3,a1
    800043b6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800043b8:	457c                	lw	a5,76(a0)
    800043ba:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800043bc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800043be:	e79d                	bnez	a5,800043ec <dirlookup+0x54>
    800043c0:	a8a5                	j	80004438 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800043c2:	00004517          	auipc	a0,0x4
    800043c6:	29e50513          	addi	a0,a0,670 # 80008660 <syscalls+0x1b8>
    800043ca:	ffffc097          	auipc	ra,0xffffc
    800043ce:	174080e7          	jalr	372(ra) # 8000053e <panic>
      panic("dirlookup read");
    800043d2:	00004517          	auipc	a0,0x4
    800043d6:	2a650513          	addi	a0,a0,678 # 80008678 <syscalls+0x1d0>
    800043da:	ffffc097          	auipc	ra,0xffffc
    800043de:	164080e7          	jalr	356(ra) # 8000053e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800043e2:	24c1                	addiw	s1,s1,16
    800043e4:	04c92783          	lw	a5,76(s2)
    800043e8:	04f4f763          	bgeu	s1,a5,80004436 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043ec:	4741                	li	a4,16
    800043ee:	86a6                	mv	a3,s1
    800043f0:	fc040613          	addi	a2,s0,-64
    800043f4:	4581                	li	a1,0
    800043f6:	854a                	mv	a0,s2
    800043f8:	00000097          	auipc	ra,0x0
    800043fc:	d70080e7          	jalr	-656(ra) # 80004168 <readi>
    80004400:	47c1                	li	a5,16
    80004402:	fcf518e3          	bne	a0,a5,800043d2 <dirlookup+0x3a>
    if(de.inum == 0)
    80004406:	fc045783          	lhu	a5,-64(s0)
    8000440a:	dfe1                	beqz	a5,800043e2 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000440c:	fc240593          	addi	a1,s0,-62
    80004410:	854e                	mv	a0,s3
    80004412:	00000097          	auipc	ra,0x0
    80004416:	f6c080e7          	jalr	-148(ra) # 8000437e <namecmp>
    8000441a:	f561                	bnez	a0,800043e2 <dirlookup+0x4a>
      if(poff)
    8000441c:	000a0463          	beqz	s4,80004424 <dirlookup+0x8c>
        *poff = off;
    80004420:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004424:	fc045583          	lhu	a1,-64(s0)
    80004428:	00092503          	lw	a0,0(s2)
    8000442c:	fffff097          	auipc	ra,0xfffff
    80004430:	750080e7          	jalr	1872(ra) # 80003b7c <iget>
    80004434:	a011                	j	80004438 <dirlookup+0xa0>
  return 0;
    80004436:	4501                	li	a0,0
}
    80004438:	70e2                	ld	ra,56(sp)
    8000443a:	7442                	ld	s0,48(sp)
    8000443c:	74a2                	ld	s1,40(sp)
    8000443e:	7902                	ld	s2,32(sp)
    80004440:	69e2                	ld	s3,24(sp)
    80004442:	6a42                	ld	s4,16(sp)
    80004444:	6121                	addi	sp,sp,64
    80004446:	8082                	ret

0000000080004448 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004448:	711d                	addi	sp,sp,-96
    8000444a:	ec86                	sd	ra,88(sp)
    8000444c:	e8a2                	sd	s0,80(sp)
    8000444e:	e4a6                	sd	s1,72(sp)
    80004450:	e0ca                	sd	s2,64(sp)
    80004452:	fc4e                	sd	s3,56(sp)
    80004454:	f852                	sd	s4,48(sp)
    80004456:	f456                	sd	s5,40(sp)
    80004458:	f05a                	sd	s6,32(sp)
    8000445a:	ec5e                	sd	s7,24(sp)
    8000445c:	e862                	sd	s8,16(sp)
    8000445e:	e466                	sd	s9,8(sp)
    80004460:	1080                	addi	s0,sp,96
    80004462:	84aa                	mv	s1,a0
    80004464:	8aae                	mv	s5,a1
    80004466:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004468:	00054703          	lbu	a4,0(a0)
    8000446c:	02f00793          	li	a5,47
    80004470:	02f70363          	beq	a4,a5,80004496 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004474:	ffffd097          	auipc	ra,0xffffd
    80004478:	79a080e7          	jalr	1946(ra) # 80001c0e <myproc>
    8000447c:	15053503          	ld	a0,336(a0)
    80004480:	00000097          	auipc	ra,0x0
    80004484:	9f6080e7          	jalr	-1546(ra) # 80003e76 <idup>
    80004488:	89aa                	mv	s3,a0
  while(*path == '/')
    8000448a:	02f00913          	li	s2,47
  len = path - s;
    8000448e:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80004490:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004492:	4b85                	li	s7,1
    80004494:	a865                	j	8000454c <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80004496:	4585                	li	a1,1
    80004498:	4505                	li	a0,1
    8000449a:	fffff097          	auipc	ra,0xfffff
    8000449e:	6e2080e7          	jalr	1762(ra) # 80003b7c <iget>
    800044a2:	89aa                	mv	s3,a0
    800044a4:	b7dd                	j	8000448a <namex+0x42>
      iunlockput(ip);
    800044a6:	854e                	mv	a0,s3
    800044a8:	00000097          	auipc	ra,0x0
    800044ac:	c6e080e7          	jalr	-914(ra) # 80004116 <iunlockput>
      return 0;
    800044b0:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800044b2:	854e                	mv	a0,s3
    800044b4:	60e6                	ld	ra,88(sp)
    800044b6:	6446                	ld	s0,80(sp)
    800044b8:	64a6                	ld	s1,72(sp)
    800044ba:	6906                	ld	s2,64(sp)
    800044bc:	79e2                	ld	s3,56(sp)
    800044be:	7a42                	ld	s4,48(sp)
    800044c0:	7aa2                	ld	s5,40(sp)
    800044c2:	7b02                	ld	s6,32(sp)
    800044c4:	6be2                	ld	s7,24(sp)
    800044c6:	6c42                	ld	s8,16(sp)
    800044c8:	6ca2                	ld	s9,8(sp)
    800044ca:	6125                	addi	sp,sp,96
    800044cc:	8082                	ret
      iunlock(ip);
    800044ce:	854e                	mv	a0,s3
    800044d0:	00000097          	auipc	ra,0x0
    800044d4:	aa6080e7          	jalr	-1370(ra) # 80003f76 <iunlock>
      return ip;
    800044d8:	bfe9                	j	800044b2 <namex+0x6a>
      iunlockput(ip);
    800044da:	854e                	mv	a0,s3
    800044dc:	00000097          	auipc	ra,0x0
    800044e0:	c3a080e7          	jalr	-966(ra) # 80004116 <iunlockput>
      return 0;
    800044e4:	89e6                	mv	s3,s9
    800044e6:	b7f1                	j	800044b2 <namex+0x6a>
  len = path - s;
    800044e8:	40b48633          	sub	a2,s1,a1
    800044ec:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800044f0:	099c5463          	bge	s8,s9,80004578 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800044f4:	4639                	li	a2,14
    800044f6:	8552                	mv	a0,s4
    800044f8:	ffffd097          	auipc	ra,0xffffd
    800044fc:	a5a080e7          	jalr	-1446(ra) # 80000f52 <memmove>
  while(*path == '/')
    80004500:	0004c783          	lbu	a5,0(s1)
    80004504:	01279763          	bne	a5,s2,80004512 <namex+0xca>
    path++;
    80004508:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000450a:	0004c783          	lbu	a5,0(s1)
    8000450e:	ff278de3          	beq	a5,s2,80004508 <namex+0xc0>
    ilock(ip);
    80004512:	854e                	mv	a0,s3
    80004514:	00000097          	auipc	ra,0x0
    80004518:	9a0080e7          	jalr	-1632(ra) # 80003eb4 <ilock>
    if(ip->type != T_DIR){
    8000451c:	04499783          	lh	a5,68(s3)
    80004520:	f97793e3          	bne	a5,s7,800044a6 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80004524:	000a8563          	beqz	s5,8000452e <namex+0xe6>
    80004528:	0004c783          	lbu	a5,0(s1)
    8000452c:	d3cd                	beqz	a5,800044ce <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000452e:	865a                	mv	a2,s6
    80004530:	85d2                	mv	a1,s4
    80004532:	854e                	mv	a0,s3
    80004534:	00000097          	auipc	ra,0x0
    80004538:	e64080e7          	jalr	-412(ra) # 80004398 <dirlookup>
    8000453c:	8caa                	mv	s9,a0
    8000453e:	dd51                	beqz	a0,800044da <namex+0x92>
    iunlockput(ip);
    80004540:	854e                	mv	a0,s3
    80004542:	00000097          	auipc	ra,0x0
    80004546:	bd4080e7          	jalr	-1068(ra) # 80004116 <iunlockput>
    ip = next;
    8000454a:	89e6                	mv	s3,s9
  while(*path == '/')
    8000454c:	0004c783          	lbu	a5,0(s1)
    80004550:	05279763          	bne	a5,s2,8000459e <namex+0x156>
    path++;
    80004554:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004556:	0004c783          	lbu	a5,0(s1)
    8000455a:	ff278de3          	beq	a5,s2,80004554 <namex+0x10c>
  if(*path == 0)
    8000455e:	c79d                	beqz	a5,8000458c <namex+0x144>
    path++;
    80004560:	85a6                	mv	a1,s1
  len = path - s;
    80004562:	8cda                	mv	s9,s6
    80004564:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80004566:	01278963          	beq	a5,s2,80004578 <namex+0x130>
    8000456a:	dfbd                	beqz	a5,800044e8 <namex+0xa0>
    path++;
    8000456c:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000456e:	0004c783          	lbu	a5,0(s1)
    80004572:	ff279ce3          	bne	a5,s2,8000456a <namex+0x122>
    80004576:	bf8d                	j	800044e8 <namex+0xa0>
    memmove(name, s, len);
    80004578:	2601                	sext.w	a2,a2
    8000457a:	8552                	mv	a0,s4
    8000457c:	ffffd097          	auipc	ra,0xffffd
    80004580:	9d6080e7          	jalr	-1578(ra) # 80000f52 <memmove>
    name[len] = 0;
    80004584:	9cd2                	add	s9,s9,s4
    80004586:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000458a:	bf9d                	j	80004500 <namex+0xb8>
  if(nameiparent){
    8000458c:	f20a83e3          	beqz	s5,800044b2 <namex+0x6a>
    iput(ip);
    80004590:	854e                	mv	a0,s3
    80004592:	00000097          	auipc	ra,0x0
    80004596:	adc080e7          	jalr	-1316(ra) # 8000406e <iput>
    return 0;
    8000459a:	4981                	li	s3,0
    8000459c:	bf19                	j	800044b2 <namex+0x6a>
  if(*path == 0)
    8000459e:	d7fd                	beqz	a5,8000458c <namex+0x144>
  while(*path != '/' && *path != 0)
    800045a0:	0004c783          	lbu	a5,0(s1)
    800045a4:	85a6                	mv	a1,s1
    800045a6:	b7d1                	j	8000456a <namex+0x122>

00000000800045a8 <dirlink>:
{
    800045a8:	7139                	addi	sp,sp,-64
    800045aa:	fc06                	sd	ra,56(sp)
    800045ac:	f822                	sd	s0,48(sp)
    800045ae:	f426                	sd	s1,40(sp)
    800045b0:	f04a                	sd	s2,32(sp)
    800045b2:	ec4e                	sd	s3,24(sp)
    800045b4:	e852                	sd	s4,16(sp)
    800045b6:	0080                	addi	s0,sp,64
    800045b8:	892a                	mv	s2,a0
    800045ba:	8a2e                	mv	s4,a1
    800045bc:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800045be:	4601                	li	a2,0
    800045c0:	00000097          	auipc	ra,0x0
    800045c4:	dd8080e7          	jalr	-552(ra) # 80004398 <dirlookup>
    800045c8:	e93d                	bnez	a0,8000463e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800045ca:	04c92483          	lw	s1,76(s2)
    800045ce:	c49d                	beqz	s1,800045fc <dirlink+0x54>
    800045d0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800045d2:	4741                	li	a4,16
    800045d4:	86a6                	mv	a3,s1
    800045d6:	fc040613          	addi	a2,s0,-64
    800045da:	4581                	li	a1,0
    800045dc:	854a                	mv	a0,s2
    800045de:	00000097          	auipc	ra,0x0
    800045e2:	b8a080e7          	jalr	-1142(ra) # 80004168 <readi>
    800045e6:	47c1                	li	a5,16
    800045e8:	06f51163          	bne	a0,a5,8000464a <dirlink+0xa2>
    if(de.inum == 0)
    800045ec:	fc045783          	lhu	a5,-64(s0)
    800045f0:	c791                	beqz	a5,800045fc <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800045f2:	24c1                	addiw	s1,s1,16
    800045f4:	04c92783          	lw	a5,76(s2)
    800045f8:	fcf4ede3          	bltu	s1,a5,800045d2 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800045fc:	4639                	li	a2,14
    800045fe:	85d2                	mv	a1,s4
    80004600:	fc240513          	addi	a0,s0,-62
    80004604:	ffffd097          	auipc	ra,0xffffd
    80004608:	9fe080e7          	jalr	-1538(ra) # 80001002 <strncpy>
  de.inum = inum;
    8000460c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004610:	4741                	li	a4,16
    80004612:	86a6                	mv	a3,s1
    80004614:	fc040613          	addi	a2,s0,-64
    80004618:	4581                	li	a1,0
    8000461a:	854a                	mv	a0,s2
    8000461c:	00000097          	auipc	ra,0x0
    80004620:	c44080e7          	jalr	-956(ra) # 80004260 <writei>
    80004624:	1541                	addi	a0,a0,-16
    80004626:	00a03533          	snez	a0,a0
    8000462a:	40a00533          	neg	a0,a0
}
    8000462e:	70e2                	ld	ra,56(sp)
    80004630:	7442                	ld	s0,48(sp)
    80004632:	74a2                	ld	s1,40(sp)
    80004634:	7902                	ld	s2,32(sp)
    80004636:	69e2                	ld	s3,24(sp)
    80004638:	6a42                	ld	s4,16(sp)
    8000463a:	6121                	addi	sp,sp,64
    8000463c:	8082                	ret
    iput(ip);
    8000463e:	00000097          	auipc	ra,0x0
    80004642:	a30080e7          	jalr	-1488(ra) # 8000406e <iput>
    return -1;
    80004646:	557d                	li	a0,-1
    80004648:	b7dd                	j	8000462e <dirlink+0x86>
      panic("dirlink read");
    8000464a:	00004517          	auipc	a0,0x4
    8000464e:	03e50513          	addi	a0,a0,62 # 80008688 <syscalls+0x1e0>
    80004652:	ffffc097          	auipc	ra,0xffffc
    80004656:	eec080e7          	jalr	-276(ra) # 8000053e <panic>

000000008000465a <namei>:

struct inode*
namei(char *path)
{
    8000465a:	1101                	addi	sp,sp,-32
    8000465c:	ec06                	sd	ra,24(sp)
    8000465e:	e822                	sd	s0,16(sp)
    80004660:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004662:	fe040613          	addi	a2,s0,-32
    80004666:	4581                	li	a1,0
    80004668:	00000097          	auipc	ra,0x0
    8000466c:	de0080e7          	jalr	-544(ra) # 80004448 <namex>
}
    80004670:	60e2                	ld	ra,24(sp)
    80004672:	6442                	ld	s0,16(sp)
    80004674:	6105                	addi	sp,sp,32
    80004676:	8082                	ret

0000000080004678 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004678:	1141                	addi	sp,sp,-16
    8000467a:	e406                	sd	ra,8(sp)
    8000467c:	e022                	sd	s0,0(sp)
    8000467e:	0800                	addi	s0,sp,16
    80004680:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004682:	4585                	li	a1,1
    80004684:	00000097          	auipc	ra,0x0
    80004688:	dc4080e7          	jalr	-572(ra) # 80004448 <namex>
}
    8000468c:	60a2                	ld	ra,8(sp)
    8000468e:	6402                	ld	s0,0(sp)
    80004690:	0141                	addi	sp,sp,16
    80004692:	8082                	ret

0000000080004694 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004694:	1101                	addi	sp,sp,-32
    80004696:	ec06                	sd	ra,24(sp)
    80004698:	e822                	sd	s0,16(sp)
    8000469a:	e426                	sd	s1,8(sp)
    8000469c:	e04a                	sd	s2,0(sp)
    8000469e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800046a0:	0023d917          	auipc	s2,0x23d
    800046a4:	ee890913          	addi	s2,s2,-280 # 80241588 <log>
    800046a8:	01892583          	lw	a1,24(s2)
    800046ac:	02892503          	lw	a0,40(s2)
    800046b0:	fffff097          	auipc	ra,0xfffff
    800046b4:	fea080e7          	jalr	-22(ra) # 8000369a <bread>
    800046b8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800046ba:	02c92683          	lw	a3,44(s2)
    800046be:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800046c0:	02d05763          	blez	a3,800046ee <write_head+0x5a>
    800046c4:	0023d797          	auipc	a5,0x23d
    800046c8:	ef478793          	addi	a5,a5,-268 # 802415b8 <log+0x30>
    800046cc:	05c50713          	addi	a4,a0,92
    800046d0:	36fd                	addiw	a3,a3,-1
    800046d2:	1682                	slli	a3,a3,0x20
    800046d4:	9281                	srli	a3,a3,0x20
    800046d6:	068a                	slli	a3,a3,0x2
    800046d8:	0023d617          	auipc	a2,0x23d
    800046dc:	ee460613          	addi	a2,a2,-284 # 802415bc <log+0x34>
    800046e0:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800046e2:	4390                	lw	a2,0(a5)
    800046e4:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800046e6:	0791                	addi	a5,a5,4
    800046e8:	0711                	addi	a4,a4,4
    800046ea:	fed79ce3          	bne	a5,a3,800046e2 <write_head+0x4e>
  }
  bwrite(buf);
    800046ee:	8526                	mv	a0,s1
    800046f0:	fffff097          	auipc	ra,0xfffff
    800046f4:	09c080e7          	jalr	156(ra) # 8000378c <bwrite>
  brelse(buf);
    800046f8:	8526                	mv	a0,s1
    800046fa:	fffff097          	auipc	ra,0xfffff
    800046fe:	0d0080e7          	jalr	208(ra) # 800037ca <brelse>
}
    80004702:	60e2                	ld	ra,24(sp)
    80004704:	6442                	ld	s0,16(sp)
    80004706:	64a2                	ld	s1,8(sp)
    80004708:	6902                	ld	s2,0(sp)
    8000470a:	6105                	addi	sp,sp,32
    8000470c:	8082                	ret

000000008000470e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000470e:	0023d797          	auipc	a5,0x23d
    80004712:	ea67a783          	lw	a5,-346(a5) # 802415b4 <log+0x2c>
    80004716:	0af05d63          	blez	a5,800047d0 <install_trans+0xc2>
{
    8000471a:	7139                	addi	sp,sp,-64
    8000471c:	fc06                	sd	ra,56(sp)
    8000471e:	f822                	sd	s0,48(sp)
    80004720:	f426                	sd	s1,40(sp)
    80004722:	f04a                	sd	s2,32(sp)
    80004724:	ec4e                	sd	s3,24(sp)
    80004726:	e852                	sd	s4,16(sp)
    80004728:	e456                	sd	s5,8(sp)
    8000472a:	e05a                	sd	s6,0(sp)
    8000472c:	0080                	addi	s0,sp,64
    8000472e:	8b2a                	mv	s6,a0
    80004730:	0023da97          	auipc	s5,0x23d
    80004734:	e88a8a93          	addi	s5,s5,-376 # 802415b8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004738:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000473a:	0023d997          	auipc	s3,0x23d
    8000473e:	e4e98993          	addi	s3,s3,-434 # 80241588 <log>
    80004742:	a00d                	j	80004764 <install_trans+0x56>
    brelse(lbuf);
    80004744:	854a                	mv	a0,s2
    80004746:	fffff097          	auipc	ra,0xfffff
    8000474a:	084080e7          	jalr	132(ra) # 800037ca <brelse>
    brelse(dbuf);
    8000474e:	8526                	mv	a0,s1
    80004750:	fffff097          	auipc	ra,0xfffff
    80004754:	07a080e7          	jalr	122(ra) # 800037ca <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004758:	2a05                	addiw	s4,s4,1
    8000475a:	0a91                	addi	s5,s5,4
    8000475c:	02c9a783          	lw	a5,44(s3)
    80004760:	04fa5e63          	bge	s4,a5,800047bc <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004764:	0189a583          	lw	a1,24(s3)
    80004768:	014585bb          	addw	a1,a1,s4
    8000476c:	2585                	addiw	a1,a1,1
    8000476e:	0289a503          	lw	a0,40(s3)
    80004772:	fffff097          	auipc	ra,0xfffff
    80004776:	f28080e7          	jalr	-216(ra) # 8000369a <bread>
    8000477a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000477c:	000aa583          	lw	a1,0(s5)
    80004780:	0289a503          	lw	a0,40(s3)
    80004784:	fffff097          	auipc	ra,0xfffff
    80004788:	f16080e7          	jalr	-234(ra) # 8000369a <bread>
    8000478c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000478e:	40000613          	li	a2,1024
    80004792:	05890593          	addi	a1,s2,88
    80004796:	05850513          	addi	a0,a0,88
    8000479a:	ffffc097          	auipc	ra,0xffffc
    8000479e:	7b8080e7          	jalr	1976(ra) # 80000f52 <memmove>
    bwrite(dbuf);  // write dst to disk
    800047a2:	8526                	mv	a0,s1
    800047a4:	fffff097          	auipc	ra,0xfffff
    800047a8:	fe8080e7          	jalr	-24(ra) # 8000378c <bwrite>
    if(recovering == 0)
    800047ac:	f80b1ce3          	bnez	s6,80004744 <install_trans+0x36>
      bunpin(dbuf);
    800047b0:	8526                	mv	a0,s1
    800047b2:	fffff097          	auipc	ra,0xfffff
    800047b6:	0f2080e7          	jalr	242(ra) # 800038a4 <bunpin>
    800047ba:	b769                	j	80004744 <install_trans+0x36>
}
    800047bc:	70e2                	ld	ra,56(sp)
    800047be:	7442                	ld	s0,48(sp)
    800047c0:	74a2                	ld	s1,40(sp)
    800047c2:	7902                	ld	s2,32(sp)
    800047c4:	69e2                	ld	s3,24(sp)
    800047c6:	6a42                	ld	s4,16(sp)
    800047c8:	6aa2                	ld	s5,8(sp)
    800047ca:	6b02                	ld	s6,0(sp)
    800047cc:	6121                	addi	sp,sp,64
    800047ce:	8082                	ret
    800047d0:	8082                	ret

00000000800047d2 <initlog>:
{
    800047d2:	7179                	addi	sp,sp,-48
    800047d4:	f406                	sd	ra,40(sp)
    800047d6:	f022                	sd	s0,32(sp)
    800047d8:	ec26                	sd	s1,24(sp)
    800047da:	e84a                	sd	s2,16(sp)
    800047dc:	e44e                	sd	s3,8(sp)
    800047de:	1800                	addi	s0,sp,48
    800047e0:	892a                	mv	s2,a0
    800047e2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800047e4:	0023d497          	auipc	s1,0x23d
    800047e8:	da448493          	addi	s1,s1,-604 # 80241588 <log>
    800047ec:	00004597          	auipc	a1,0x4
    800047f0:	eac58593          	addi	a1,a1,-340 # 80008698 <syscalls+0x1f0>
    800047f4:	8526                	mv	a0,s1
    800047f6:	ffffc097          	auipc	ra,0xffffc
    800047fa:	574080e7          	jalr	1396(ra) # 80000d6a <initlock>
  log.start = sb->logstart;
    800047fe:	0149a583          	lw	a1,20(s3)
    80004802:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004804:	0109a783          	lw	a5,16(s3)
    80004808:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000480a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000480e:	854a                	mv	a0,s2
    80004810:	fffff097          	auipc	ra,0xfffff
    80004814:	e8a080e7          	jalr	-374(ra) # 8000369a <bread>
  log.lh.n = lh->n;
    80004818:	4d34                	lw	a3,88(a0)
    8000481a:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000481c:	02d05563          	blez	a3,80004846 <initlog+0x74>
    80004820:	05c50793          	addi	a5,a0,92
    80004824:	0023d717          	auipc	a4,0x23d
    80004828:	d9470713          	addi	a4,a4,-620 # 802415b8 <log+0x30>
    8000482c:	36fd                	addiw	a3,a3,-1
    8000482e:	1682                	slli	a3,a3,0x20
    80004830:	9281                	srli	a3,a3,0x20
    80004832:	068a                	slli	a3,a3,0x2
    80004834:	06050613          	addi	a2,a0,96
    80004838:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000483a:	4390                	lw	a2,0(a5)
    8000483c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000483e:	0791                	addi	a5,a5,4
    80004840:	0711                	addi	a4,a4,4
    80004842:	fed79ce3          	bne	a5,a3,8000483a <initlog+0x68>
  brelse(buf);
    80004846:	fffff097          	auipc	ra,0xfffff
    8000484a:	f84080e7          	jalr	-124(ra) # 800037ca <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000484e:	4505                	li	a0,1
    80004850:	00000097          	auipc	ra,0x0
    80004854:	ebe080e7          	jalr	-322(ra) # 8000470e <install_trans>
  log.lh.n = 0;
    80004858:	0023d797          	auipc	a5,0x23d
    8000485c:	d407ae23          	sw	zero,-676(a5) # 802415b4 <log+0x2c>
  write_head(); // clear the log
    80004860:	00000097          	auipc	ra,0x0
    80004864:	e34080e7          	jalr	-460(ra) # 80004694 <write_head>
}
    80004868:	70a2                	ld	ra,40(sp)
    8000486a:	7402                	ld	s0,32(sp)
    8000486c:	64e2                	ld	s1,24(sp)
    8000486e:	6942                	ld	s2,16(sp)
    80004870:	69a2                	ld	s3,8(sp)
    80004872:	6145                	addi	sp,sp,48
    80004874:	8082                	ret

0000000080004876 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004876:	1101                	addi	sp,sp,-32
    80004878:	ec06                	sd	ra,24(sp)
    8000487a:	e822                	sd	s0,16(sp)
    8000487c:	e426                	sd	s1,8(sp)
    8000487e:	e04a                	sd	s2,0(sp)
    80004880:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004882:	0023d517          	auipc	a0,0x23d
    80004886:	d0650513          	addi	a0,a0,-762 # 80241588 <log>
    8000488a:	ffffc097          	auipc	ra,0xffffc
    8000488e:	570080e7          	jalr	1392(ra) # 80000dfa <acquire>
  while(1){
    if(log.committing){
    80004892:	0023d497          	auipc	s1,0x23d
    80004896:	cf648493          	addi	s1,s1,-778 # 80241588 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000489a:	4979                	li	s2,30
    8000489c:	a039                	j	800048aa <begin_op+0x34>
      sleep(&log, &log.lock);
    8000489e:	85a6                	mv	a1,s1
    800048a0:	8526                	mv	a0,s1
    800048a2:	ffffe097          	auipc	ra,0xffffe
    800048a6:	c40080e7          	jalr	-960(ra) # 800024e2 <sleep>
    if(log.committing){
    800048aa:	50dc                	lw	a5,36(s1)
    800048ac:	fbed                	bnez	a5,8000489e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800048ae:	509c                	lw	a5,32(s1)
    800048b0:	0017871b          	addiw	a4,a5,1
    800048b4:	0007069b          	sext.w	a3,a4
    800048b8:	0027179b          	slliw	a5,a4,0x2
    800048bc:	9fb9                	addw	a5,a5,a4
    800048be:	0017979b          	slliw	a5,a5,0x1
    800048c2:	54d8                	lw	a4,44(s1)
    800048c4:	9fb9                	addw	a5,a5,a4
    800048c6:	00f95963          	bge	s2,a5,800048d8 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800048ca:	85a6                	mv	a1,s1
    800048cc:	8526                	mv	a0,s1
    800048ce:	ffffe097          	auipc	ra,0xffffe
    800048d2:	c14080e7          	jalr	-1004(ra) # 800024e2 <sleep>
    800048d6:	bfd1                	j	800048aa <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800048d8:	0023d517          	auipc	a0,0x23d
    800048dc:	cb050513          	addi	a0,a0,-848 # 80241588 <log>
    800048e0:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800048e2:	ffffc097          	auipc	ra,0xffffc
    800048e6:	5cc080e7          	jalr	1484(ra) # 80000eae <release>
      break;
    }
  }
}
    800048ea:	60e2                	ld	ra,24(sp)
    800048ec:	6442                	ld	s0,16(sp)
    800048ee:	64a2                	ld	s1,8(sp)
    800048f0:	6902                	ld	s2,0(sp)
    800048f2:	6105                	addi	sp,sp,32
    800048f4:	8082                	ret

00000000800048f6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800048f6:	7139                	addi	sp,sp,-64
    800048f8:	fc06                	sd	ra,56(sp)
    800048fa:	f822                	sd	s0,48(sp)
    800048fc:	f426                	sd	s1,40(sp)
    800048fe:	f04a                	sd	s2,32(sp)
    80004900:	ec4e                	sd	s3,24(sp)
    80004902:	e852                	sd	s4,16(sp)
    80004904:	e456                	sd	s5,8(sp)
    80004906:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004908:	0023d497          	auipc	s1,0x23d
    8000490c:	c8048493          	addi	s1,s1,-896 # 80241588 <log>
    80004910:	8526                	mv	a0,s1
    80004912:	ffffc097          	auipc	ra,0xffffc
    80004916:	4e8080e7          	jalr	1256(ra) # 80000dfa <acquire>
  log.outstanding -= 1;
    8000491a:	509c                	lw	a5,32(s1)
    8000491c:	37fd                	addiw	a5,a5,-1
    8000491e:	0007891b          	sext.w	s2,a5
    80004922:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004924:	50dc                	lw	a5,36(s1)
    80004926:	e7b9                	bnez	a5,80004974 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004928:	04091e63          	bnez	s2,80004984 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000492c:	0023d497          	auipc	s1,0x23d
    80004930:	c5c48493          	addi	s1,s1,-932 # 80241588 <log>
    80004934:	4785                	li	a5,1
    80004936:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004938:	8526                	mv	a0,s1
    8000493a:	ffffc097          	auipc	ra,0xffffc
    8000493e:	574080e7          	jalr	1396(ra) # 80000eae <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004942:	54dc                	lw	a5,44(s1)
    80004944:	06f04763          	bgtz	a5,800049b2 <end_op+0xbc>
    acquire(&log.lock);
    80004948:	0023d497          	auipc	s1,0x23d
    8000494c:	c4048493          	addi	s1,s1,-960 # 80241588 <log>
    80004950:	8526                	mv	a0,s1
    80004952:	ffffc097          	auipc	ra,0xffffc
    80004956:	4a8080e7          	jalr	1192(ra) # 80000dfa <acquire>
    log.committing = 0;
    8000495a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000495e:	8526                	mv	a0,s1
    80004960:	ffffe097          	auipc	ra,0xffffe
    80004964:	be6080e7          	jalr	-1050(ra) # 80002546 <wakeup>
    release(&log.lock);
    80004968:	8526                	mv	a0,s1
    8000496a:	ffffc097          	auipc	ra,0xffffc
    8000496e:	544080e7          	jalr	1348(ra) # 80000eae <release>
}
    80004972:	a03d                	j	800049a0 <end_op+0xaa>
    panic("log.committing");
    80004974:	00004517          	auipc	a0,0x4
    80004978:	d2c50513          	addi	a0,a0,-724 # 800086a0 <syscalls+0x1f8>
    8000497c:	ffffc097          	auipc	ra,0xffffc
    80004980:	bc2080e7          	jalr	-1086(ra) # 8000053e <panic>
    wakeup(&log);
    80004984:	0023d497          	auipc	s1,0x23d
    80004988:	c0448493          	addi	s1,s1,-1020 # 80241588 <log>
    8000498c:	8526                	mv	a0,s1
    8000498e:	ffffe097          	auipc	ra,0xffffe
    80004992:	bb8080e7          	jalr	-1096(ra) # 80002546 <wakeup>
  release(&log.lock);
    80004996:	8526                	mv	a0,s1
    80004998:	ffffc097          	auipc	ra,0xffffc
    8000499c:	516080e7          	jalr	1302(ra) # 80000eae <release>
}
    800049a0:	70e2                	ld	ra,56(sp)
    800049a2:	7442                	ld	s0,48(sp)
    800049a4:	74a2                	ld	s1,40(sp)
    800049a6:	7902                	ld	s2,32(sp)
    800049a8:	69e2                	ld	s3,24(sp)
    800049aa:	6a42                	ld	s4,16(sp)
    800049ac:	6aa2                	ld	s5,8(sp)
    800049ae:	6121                	addi	sp,sp,64
    800049b0:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800049b2:	0023da97          	auipc	s5,0x23d
    800049b6:	c06a8a93          	addi	s5,s5,-1018 # 802415b8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800049ba:	0023da17          	auipc	s4,0x23d
    800049be:	bcea0a13          	addi	s4,s4,-1074 # 80241588 <log>
    800049c2:	018a2583          	lw	a1,24(s4)
    800049c6:	012585bb          	addw	a1,a1,s2
    800049ca:	2585                	addiw	a1,a1,1
    800049cc:	028a2503          	lw	a0,40(s4)
    800049d0:	fffff097          	auipc	ra,0xfffff
    800049d4:	cca080e7          	jalr	-822(ra) # 8000369a <bread>
    800049d8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800049da:	000aa583          	lw	a1,0(s5)
    800049de:	028a2503          	lw	a0,40(s4)
    800049e2:	fffff097          	auipc	ra,0xfffff
    800049e6:	cb8080e7          	jalr	-840(ra) # 8000369a <bread>
    800049ea:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800049ec:	40000613          	li	a2,1024
    800049f0:	05850593          	addi	a1,a0,88
    800049f4:	05848513          	addi	a0,s1,88
    800049f8:	ffffc097          	auipc	ra,0xffffc
    800049fc:	55a080e7          	jalr	1370(ra) # 80000f52 <memmove>
    bwrite(to);  // write the log
    80004a00:	8526                	mv	a0,s1
    80004a02:	fffff097          	auipc	ra,0xfffff
    80004a06:	d8a080e7          	jalr	-630(ra) # 8000378c <bwrite>
    brelse(from);
    80004a0a:	854e                	mv	a0,s3
    80004a0c:	fffff097          	auipc	ra,0xfffff
    80004a10:	dbe080e7          	jalr	-578(ra) # 800037ca <brelse>
    brelse(to);
    80004a14:	8526                	mv	a0,s1
    80004a16:	fffff097          	auipc	ra,0xfffff
    80004a1a:	db4080e7          	jalr	-588(ra) # 800037ca <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004a1e:	2905                	addiw	s2,s2,1
    80004a20:	0a91                	addi	s5,s5,4
    80004a22:	02ca2783          	lw	a5,44(s4)
    80004a26:	f8f94ee3          	blt	s2,a5,800049c2 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004a2a:	00000097          	auipc	ra,0x0
    80004a2e:	c6a080e7          	jalr	-918(ra) # 80004694 <write_head>
    install_trans(0); // Now install writes to home locations
    80004a32:	4501                	li	a0,0
    80004a34:	00000097          	auipc	ra,0x0
    80004a38:	cda080e7          	jalr	-806(ra) # 8000470e <install_trans>
    log.lh.n = 0;
    80004a3c:	0023d797          	auipc	a5,0x23d
    80004a40:	b607ac23          	sw	zero,-1160(a5) # 802415b4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004a44:	00000097          	auipc	ra,0x0
    80004a48:	c50080e7          	jalr	-944(ra) # 80004694 <write_head>
    80004a4c:	bdf5                	j	80004948 <end_op+0x52>

0000000080004a4e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004a4e:	1101                	addi	sp,sp,-32
    80004a50:	ec06                	sd	ra,24(sp)
    80004a52:	e822                	sd	s0,16(sp)
    80004a54:	e426                	sd	s1,8(sp)
    80004a56:	e04a                	sd	s2,0(sp)
    80004a58:	1000                	addi	s0,sp,32
    80004a5a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004a5c:	0023d917          	auipc	s2,0x23d
    80004a60:	b2c90913          	addi	s2,s2,-1236 # 80241588 <log>
    80004a64:	854a                	mv	a0,s2
    80004a66:	ffffc097          	auipc	ra,0xffffc
    80004a6a:	394080e7          	jalr	916(ra) # 80000dfa <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004a6e:	02c92603          	lw	a2,44(s2)
    80004a72:	47f5                	li	a5,29
    80004a74:	06c7c563          	blt	a5,a2,80004ade <log_write+0x90>
    80004a78:	0023d797          	auipc	a5,0x23d
    80004a7c:	b2c7a783          	lw	a5,-1236(a5) # 802415a4 <log+0x1c>
    80004a80:	37fd                	addiw	a5,a5,-1
    80004a82:	04f65e63          	bge	a2,a5,80004ade <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004a86:	0023d797          	auipc	a5,0x23d
    80004a8a:	b227a783          	lw	a5,-1246(a5) # 802415a8 <log+0x20>
    80004a8e:	06f05063          	blez	a5,80004aee <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004a92:	4781                	li	a5,0
    80004a94:	06c05563          	blez	a2,80004afe <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004a98:	44cc                	lw	a1,12(s1)
    80004a9a:	0023d717          	auipc	a4,0x23d
    80004a9e:	b1e70713          	addi	a4,a4,-1250 # 802415b8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004aa2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004aa4:	4314                	lw	a3,0(a4)
    80004aa6:	04b68c63          	beq	a3,a1,80004afe <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004aaa:	2785                	addiw	a5,a5,1
    80004aac:	0711                	addi	a4,a4,4
    80004aae:	fef61be3          	bne	a2,a5,80004aa4 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004ab2:	0621                	addi	a2,a2,8
    80004ab4:	060a                	slli	a2,a2,0x2
    80004ab6:	0023d797          	auipc	a5,0x23d
    80004aba:	ad278793          	addi	a5,a5,-1326 # 80241588 <log>
    80004abe:	963e                	add	a2,a2,a5
    80004ac0:	44dc                	lw	a5,12(s1)
    80004ac2:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004ac4:	8526                	mv	a0,s1
    80004ac6:	fffff097          	auipc	ra,0xfffff
    80004aca:	da2080e7          	jalr	-606(ra) # 80003868 <bpin>
    log.lh.n++;
    80004ace:	0023d717          	auipc	a4,0x23d
    80004ad2:	aba70713          	addi	a4,a4,-1350 # 80241588 <log>
    80004ad6:	575c                	lw	a5,44(a4)
    80004ad8:	2785                	addiw	a5,a5,1
    80004ada:	d75c                	sw	a5,44(a4)
    80004adc:	a835                	j	80004b18 <log_write+0xca>
    panic("too big a transaction");
    80004ade:	00004517          	auipc	a0,0x4
    80004ae2:	bd250513          	addi	a0,a0,-1070 # 800086b0 <syscalls+0x208>
    80004ae6:	ffffc097          	auipc	ra,0xffffc
    80004aea:	a58080e7          	jalr	-1448(ra) # 8000053e <panic>
    panic("log_write outside of trans");
    80004aee:	00004517          	auipc	a0,0x4
    80004af2:	bda50513          	addi	a0,a0,-1062 # 800086c8 <syscalls+0x220>
    80004af6:	ffffc097          	auipc	ra,0xffffc
    80004afa:	a48080e7          	jalr	-1464(ra) # 8000053e <panic>
  log.lh.block[i] = b->blockno;
    80004afe:	00878713          	addi	a4,a5,8
    80004b02:	00271693          	slli	a3,a4,0x2
    80004b06:	0023d717          	auipc	a4,0x23d
    80004b0a:	a8270713          	addi	a4,a4,-1406 # 80241588 <log>
    80004b0e:	9736                	add	a4,a4,a3
    80004b10:	44d4                	lw	a3,12(s1)
    80004b12:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004b14:	faf608e3          	beq	a2,a5,80004ac4 <log_write+0x76>
  }
  release(&log.lock);
    80004b18:	0023d517          	auipc	a0,0x23d
    80004b1c:	a7050513          	addi	a0,a0,-1424 # 80241588 <log>
    80004b20:	ffffc097          	auipc	ra,0xffffc
    80004b24:	38e080e7          	jalr	910(ra) # 80000eae <release>
}
    80004b28:	60e2                	ld	ra,24(sp)
    80004b2a:	6442                	ld	s0,16(sp)
    80004b2c:	64a2                	ld	s1,8(sp)
    80004b2e:	6902                	ld	s2,0(sp)
    80004b30:	6105                	addi	sp,sp,32
    80004b32:	8082                	ret

0000000080004b34 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004b34:	1101                	addi	sp,sp,-32
    80004b36:	ec06                	sd	ra,24(sp)
    80004b38:	e822                	sd	s0,16(sp)
    80004b3a:	e426                	sd	s1,8(sp)
    80004b3c:	e04a                	sd	s2,0(sp)
    80004b3e:	1000                	addi	s0,sp,32
    80004b40:	84aa                	mv	s1,a0
    80004b42:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004b44:	00004597          	auipc	a1,0x4
    80004b48:	ba458593          	addi	a1,a1,-1116 # 800086e8 <syscalls+0x240>
    80004b4c:	0521                	addi	a0,a0,8
    80004b4e:	ffffc097          	auipc	ra,0xffffc
    80004b52:	21c080e7          	jalr	540(ra) # 80000d6a <initlock>
  lk->name = name;
    80004b56:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004b5a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004b5e:	0204a423          	sw	zero,40(s1)
}
    80004b62:	60e2                	ld	ra,24(sp)
    80004b64:	6442                	ld	s0,16(sp)
    80004b66:	64a2                	ld	s1,8(sp)
    80004b68:	6902                	ld	s2,0(sp)
    80004b6a:	6105                	addi	sp,sp,32
    80004b6c:	8082                	ret

0000000080004b6e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004b6e:	1101                	addi	sp,sp,-32
    80004b70:	ec06                	sd	ra,24(sp)
    80004b72:	e822                	sd	s0,16(sp)
    80004b74:	e426                	sd	s1,8(sp)
    80004b76:	e04a                	sd	s2,0(sp)
    80004b78:	1000                	addi	s0,sp,32
    80004b7a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004b7c:	00850913          	addi	s2,a0,8
    80004b80:	854a                	mv	a0,s2
    80004b82:	ffffc097          	auipc	ra,0xffffc
    80004b86:	278080e7          	jalr	632(ra) # 80000dfa <acquire>
  while (lk->locked) {
    80004b8a:	409c                	lw	a5,0(s1)
    80004b8c:	cb89                	beqz	a5,80004b9e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004b8e:	85ca                	mv	a1,s2
    80004b90:	8526                	mv	a0,s1
    80004b92:	ffffe097          	auipc	ra,0xffffe
    80004b96:	950080e7          	jalr	-1712(ra) # 800024e2 <sleep>
  while (lk->locked) {
    80004b9a:	409c                	lw	a5,0(s1)
    80004b9c:	fbed                	bnez	a5,80004b8e <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004b9e:	4785                	li	a5,1
    80004ba0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004ba2:	ffffd097          	auipc	ra,0xffffd
    80004ba6:	06c080e7          	jalr	108(ra) # 80001c0e <myproc>
    80004baa:	591c                	lw	a5,48(a0)
    80004bac:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004bae:	854a                	mv	a0,s2
    80004bb0:	ffffc097          	auipc	ra,0xffffc
    80004bb4:	2fe080e7          	jalr	766(ra) # 80000eae <release>
}
    80004bb8:	60e2                	ld	ra,24(sp)
    80004bba:	6442                	ld	s0,16(sp)
    80004bbc:	64a2                	ld	s1,8(sp)
    80004bbe:	6902                	ld	s2,0(sp)
    80004bc0:	6105                	addi	sp,sp,32
    80004bc2:	8082                	ret

0000000080004bc4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004bc4:	1101                	addi	sp,sp,-32
    80004bc6:	ec06                	sd	ra,24(sp)
    80004bc8:	e822                	sd	s0,16(sp)
    80004bca:	e426                	sd	s1,8(sp)
    80004bcc:	e04a                	sd	s2,0(sp)
    80004bce:	1000                	addi	s0,sp,32
    80004bd0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004bd2:	00850913          	addi	s2,a0,8
    80004bd6:	854a                	mv	a0,s2
    80004bd8:	ffffc097          	auipc	ra,0xffffc
    80004bdc:	222080e7          	jalr	546(ra) # 80000dfa <acquire>
  lk->locked = 0;
    80004be0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004be4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004be8:	8526                	mv	a0,s1
    80004bea:	ffffe097          	auipc	ra,0xffffe
    80004bee:	95c080e7          	jalr	-1700(ra) # 80002546 <wakeup>
  release(&lk->lk);
    80004bf2:	854a                	mv	a0,s2
    80004bf4:	ffffc097          	auipc	ra,0xffffc
    80004bf8:	2ba080e7          	jalr	698(ra) # 80000eae <release>
}
    80004bfc:	60e2                	ld	ra,24(sp)
    80004bfe:	6442                	ld	s0,16(sp)
    80004c00:	64a2                	ld	s1,8(sp)
    80004c02:	6902                	ld	s2,0(sp)
    80004c04:	6105                	addi	sp,sp,32
    80004c06:	8082                	ret

0000000080004c08 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004c08:	7179                	addi	sp,sp,-48
    80004c0a:	f406                	sd	ra,40(sp)
    80004c0c:	f022                	sd	s0,32(sp)
    80004c0e:	ec26                	sd	s1,24(sp)
    80004c10:	e84a                	sd	s2,16(sp)
    80004c12:	e44e                	sd	s3,8(sp)
    80004c14:	1800                	addi	s0,sp,48
    80004c16:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004c18:	00850913          	addi	s2,a0,8
    80004c1c:	854a                	mv	a0,s2
    80004c1e:	ffffc097          	auipc	ra,0xffffc
    80004c22:	1dc080e7          	jalr	476(ra) # 80000dfa <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004c26:	409c                	lw	a5,0(s1)
    80004c28:	ef99                	bnez	a5,80004c46 <holdingsleep+0x3e>
    80004c2a:	4481                	li	s1,0
  release(&lk->lk);
    80004c2c:	854a                	mv	a0,s2
    80004c2e:	ffffc097          	auipc	ra,0xffffc
    80004c32:	280080e7          	jalr	640(ra) # 80000eae <release>
  return r;
}
    80004c36:	8526                	mv	a0,s1
    80004c38:	70a2                	ld	ra,40(sp)
    80004c3a:	7402                	ld	s0,32(sp)
    80004c3c:	64e2                	ld	s1,24(sp)
    80004c3e:	6942                	ld	s2,16(sp)
    80004c40:	69a2                	ld	s3,8(sp)
    80004c42:	6145                	addi	sp,sp,48
    80004c44:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004c46:	0284a983          	lw	s3,40(s1)
    80004c4a:	ffffd097          	auipc	ra,0xffffd
    80004c4e:	fc4080e7          	jalr	-60(ra) # 80001c0e <myproc>
    80004c52:	5904                	lw	s1,48(a0)
    80004c54:	413484b3          	sub	s1,s1,s3
    80004c58:	0014b493          	seqz	s1,s1
    80004c5c:	bfc1                	j	80004c2c <holdingsleep+0x24>

0000000080004c5e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004c5e:	1141                	addi	sp,sp,-16
    80004c60:	e406                	sd	ra,8(sp)
    80004c62:	e022                	sd	s0,0(sp)
    80004c64:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004c66:	00004597          	auipc	a1,0x4
    80004c6a:	a9258593          	addi	a1,a1,-1390 # 800086f8 <syscalls+0x250>
    80004c6e:	0023d517          	auipc	a0,0x23d
    80004c72:	a6250513          	addi	a0,a0,-1438 # 802416d0 <ftable>
    80004c76:	ffffc097          	auipc	ra,0xffffc
    80004c7a:	0f4080e7          	jalr	244(ra) # 80000d6a <initlock>
}
    80004c7e:	60a2                	ld	ra,8(sp)
    80004c80:	6402                	ld	s0,0(sp)
    80004c82:	0141                	addi	sp,sp,16
    80004c84:	8082                	ret

0000000080004c86 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004c86:	1101                	addi	sp,sp,-32
    80004c88:	ec06                	sd	ra,24(sp)
    80004c8a:	e822                	sd	s0,16(sp)
    80004c8c:	e426                	sd	s1,8(sp)
    80004c8e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004c90:	0023d517          	auipc	a0,0x23d
    80004c94:	a4050513          	addi	a0,a0,-1472 # 802416d0 <ftable>
    80004c98:	ffffc097          	auipc	ra,0xffffc
    80004c9c:	162080e7          	jalr	354(ra) # 80000dfa <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004ca0:	0023d497          	auipc	s1,0x23d
    80004ca4:	a4848493          	addi	s1,s1,-1464 # 802416e8 <ftable+0x18>
    80004ca8:	0023e717          	auipc	a4,0x23e
    80004cac:	9e070713          	addi	a4,a4,-1568 # 80242688 <disk>
    if(f->ref == 0){
    80004cb0:	40dc                	lw	a5,4(s1)
    80004cb2:	cf99                	beqz	a5,80004cd0 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004cb4:	02848493          	addi	s1,s1,40
    80004cb8:	fee49ce3          	bne	s1,a4,80004cb0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004cbc:	0023d517          	auipc	a0,0x23d
    80004cc0:	a1450513          	addi	a0,a0,-1516 # 802416d0 <ftable>
    80004cc4:	ffffc097          	auipc	ra,0xffffc
    80004cc8:	1ea080e7          	jalr	490(ra) # 80000eae <release>
  return 0;
    80004ccc:	4481                	li	s1,0
    80004cce:	a819                	j	80004ce4 <filealloc+0x5e>
      f->ref = 1;
    80004cd0:	4785                	li	a5,1
    80004cd2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004cd4:	0023d517          	auipc	a0,0x23d
    80004cd8:	9fc50513          	addi	a0,a0,-1540 # 802416d0 <ftable>
    80004cdc:	ffffc097          	auipc	ra,0xffffc
    80004ce0:	1d2080e7          	jalr	466(ra) # 80000eae <release>
}
    80004ce4:	8526                	mv	a0,s1
    80004ce6:	60e2                	ld	ra,24(sp)
    80004ce8:	6442                	ld	s0,16(sp)
    80004cea:	64a2                	ld	s1,8(sp)
    80004cec:	6105                	addi	sp,sp,32
    80004cee:	8082                	ret

0000000080004cf0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004cf0:	1101                	addi	sp,sp,-32
    80004cf2:	ec06                	sd	ra,24(sp)
    80004cf4:	e822                	sd	s0,16(sp)
    80004cf6:	e426                	sd	s1,8(sp)
    80004cf8:	1000                	addi	s0,sp,32
    80004cfa:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004cfc:	0023d517          	auipc	a0,0x23d
    80004d00:	9d450513          	addi	a0,a0,-1580 # 802416d0 <ftable>
    80004d04:	ffffc097          	auipc	ra,0xffffc
    80004d08:	0f6080e7          	jalr	246(ra) # 80000dfa <acquire>
  if(f->ref < 1)
    80004d0c:	40dc                	lw	a5,4(s1)
    80004d0e:	02f05263          	blez	a5,80004d32 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004d12:	2785                	addiw	a5,a5,1
    80004d14:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004d16:	0023d517          	auipc	a0,0x23d
    80004d1a:	9ba50513          	addi	a0,a0,-1606 # 802416d0 <ftable>
    80004d1e:	ffffc097          	auipc	ra,0xffffc
    80004d22:	190080e7          	jalr	400(ra) # 80000eae <release>
  return f;
}
    80004d26:	8526                	mv	a0,s1
    80004d28:	60e2                	ld	ra,24(sp)
    80004d2a:	6442                	ld	s0,16(sp)
    80004d2c:	64a2                	ld	s1,8(sp)
    80004d2e:	6105                	addi	sp,sp,32
    80004d30:	8082                	ret
    panic("filedup");
    80004d32:	00004517          	auipc	a0,0x4
    80004d36:	9ce50513          	addi	a0,a0,-1586 # 80008700 <syscalls+0x258>
    80004d3a:	ffffc097          	auipc	ra,0xffffc
    80004d3e:	804080e7          	jalr	-2044(ra) # 8000053e <panic>

0000000080004d42 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004d42:	7139                	addi	sp,sp,-64
    80004d44:	fc06                	sd	ra,56(sp)
    80004d46:	f822                	sd	s0,48(sp)
    80004d48:	f426                	sd	s1,40(sp)
    80004d4a:	f04a                	sd	s2,32(sp)
    80004d4c:	ec4e                	sd	s3,24(sp)
    80004d4e:	e852                	sd	s4,16(sp)
    80004d50:	e456                	sd	s5,8(sp)
    80004d52:	0080                	addi	s0,sp,64
    80004d54:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004d56:	0023d517          	auipc	a0,0x23d
    80004d5a:	97a50513          	addi	a0,a0,-1670 # 802416d0 <ftable>
    80004d5e:	ffffc097          	auipc	ra,0xffffc
    80004d62:	09c080e7          	jalr	156(ra) # 80000dfa <acquire>
  if(f->ref < 1)
    80004d66:	40dc                	lw	a5,4(s1)
    80004d68:	06f05163          	blez	a5,80004dca <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004d6c:	37fd                	addiw	a5,a5,-1
    80004d6e:	0007871b          	sext.w	a4,a5
    80004d72:	c0dc                	sw	a5,4(s1)
    80004d74:	06e04363          	bgtz	a4,80004dda <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004d78:	0004a903          	lw	s2,0(s1)
    80004d7c:	0094ca83          	lbu	s5,9(s1)
    80004d80:	0104ba03          	ld	s4,16(s1)
    80004d84:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004d88:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004d8c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004d90:	0023d517          	auipc	a0,0x23d
    80004d94:	94050513          	addi	a0,a0,-1728 # 802416d0 <ftable>
    80004d98:	ffffc097          	auipc	ra,0xffffc
    80004d9c:	116080e7          	jalr	278(ra) # 80000eae <release>

  if(ff.type == FD_PIPE){
    80004da0:	4785                	li	a5,1
    80004da2:	04f90d63          	beq	s2,a5,80004dfc <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004da6:	3979                	addiw	s2,s2,-2
    80004da8:	4785                	li	a5,1
    80004daa:	0527e063          	bltu	a5,s2,80004dea <fileclose+0xa8>
    begin_op();
    80004dae:	00000097          	auipc	ra,0x0
    80004db2:	ac8080e7          	jalr	-1336(ra) # 80004876 <begin_op>
    iput(ff.ip);
    80004db6:	854e                	mv	a0,s3
    80004db8:	fffff097          	auipc	ra,0xfffff
    80004dbc:	2b6080e7          	jalr	694(ra) # 8000406e <iput>
    end_op();
    80004dc0:	00000097          	auipc	ra,0x0
    80004dc4:	b36080e7          	jalr	-1226(ra) # 800048f6 <end_op>
    80004dc8:	a00d                	j	80004dea <fileclose+0xa8>
    panic("fileclose");
    80004dca:	00004517          	auipc	a0,0x4
    80004dce:	93e50513          	addi	a0,a0,-1730 # 80008708 <syscalls+0x260>
    80004dd2:	ffffb097          	auipc	ra,0xffffb
    80004dd6:	76c080e7          	jalr	1900(ra) # 8000053e <panic>
    release(&ftable.lock);
    80004dda:	0023d517          	auipc	a0,0x23d
    80004dde:	8f650513          	addi	a0,a0,-1802 # 802416d0 <ftable>
    80004de2:	ffffc097          	auipc	ra,0xffffc
    80004de6:	0cc080e7          	jalr	204(ra) # 80000eae <release>
  }
}
    80004dea:	70e2                	ld	ra,56(sp)
    80004dec:	7442                	ld	s0,48(sp)
    80004dee:	74a2                	ld	s1,40(sp)
    80004df0:	7902                	ld	s2,32(sp)
    80004df2:	69e2                	ld	s3,24(sp)
    80004df4:	6a42                	ld	s4,16(sp)
    80004df6:	6aa2                	ld	s5,8(sp)
    80004df8:	6121                	addi	sp,sp,64
    80004dfa:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004dfc:	85d6                	mv	a1,s5
    80004dfe:	8552                	mv	a0,s4
    80004e00:	00000097          	auipc	ra,0x0
    80004e04:	34c080e7          	jalr	844(ra) # 8000514c <pipeclose>
    80004e08:	b7cd                	j	80004dea <fileclose+0xa8>

0000000080004e0a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004e0a:	715d                	addi	sp,sp,-80
    80004e0c:	e486                	sd	ra,72(sp)
    80004e0e:	e0a2                	sd	s0,64(sp)
    80004e10:	fc26                	sd	s1,56(sp)
    80004e12:	f84a                	sd	s2,48(sp)
    80004e14:	f44e                	sd	s3,40(sp)
    80004e16:	0880                	addi	s0,sp,80
    80004e18:	84aa                	mv	s1,a0
    80004e1a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004e1c:	ffffd097          	auipc	ra,0xffffd
    80004e20:	df2080e7          	jalr	-526(ra) # 80001c0e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004e24:	409c                	lw	a5,0(s1)
    80004e26:	37f9                	addiw	a5,a5,-2
    80004e28:	4705                	li	a4,1
    80004e2a:	04f76763          	bltu	a4,a5,80004e78 <filestat+0x6e>
    80004e2e:	892a                	mv	s2,a0
    ilock(f->ip);
    80004e30:	6c88                	ld	a0,24(s1)
    80004e32:	fffff097          	auipc	ra,0xfffff
    80004e36:	082080e7          	jalr	130(ra) # 80003eb4 <ilock>
    stati(f->ip, &st);
    80004e3a:	fb840593          	addi	a1,s0,-72
    80004e3e:	6c88                	ld	a0,24(s1)
    80004e40:	fffff097          	auipc	ra,0xfffff
    80004e44:	2fe080e7          	jalr	766(ra) # 8000413e <stati>
    iunlock(f->ip);
    80004e48:	6c88                	ld	a0,24(s1)
    80004e4a:	fffff097          	auipc	ra,0xfffff
    80004e4e:	12c080e7          	jalr	300(ra) # 80003f76 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004e52:	46e1                	li	a3,24
    80004e54:	fb840613          	addi	a2,s0,-72
    80004e58:	85ce                	mv	a1,s3
    80004e5a:	05093503          	ld	a0,80(s2)
    80004e5e:	ffffd097          	auipc	ra,0xffffd
    80004e62:	a34080e7          	jalr	-1484(ra) # 80001892 <copyout>
    80004e66:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004e6a:	60a6                	ld	ra,72(sp)
    80004e6c:	6406                	ld	s0,64(sp)
    80004e6e:	74e2                	ld	s1,56(sp)
    80004e70:	7942                	ld	s2,48(sp)
    80004e72:	79a2                	ld	s3,40(sp)
    80004e74:	6161                	addi	sp,sp,80
    80004e76:	8082                	ret
  return -1;
    80004e78:	557d                	li	a0,-1
    80004e7a:	bfc5                	j	80004e6a <filestat+0x60>

0000000080004e7c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004e7c:	7179                	addi	sp,sp,-48
    80004e7e:	f406                	sd	ra,40(sp)
    80004e80:	f022                	sd	s0,32(sp)
    80004e82:	ec26                	sd	s1,24(sp)
    80004e84:	e84a                	sd	s2,16(sp)
    80004e86:	e44e                	sd	s3,8(sp)
    80004e88:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004e8a:	00854783          	lbu	a5,8(a0)
    80004e8e:	c3d5                	beqz	a5,80004f32 <fileread+0xb6>
    80004e90:	84aa                	mv	s1,a0
    80004e92:	89ae                	mv	s3,a1
    80004e94:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004e96:	411c                	lw	a5,0(a0)
    80004e98:	4705                	li	a4,1
    80004e9a:	04e78963          	beq	a5,a4,80004eec <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004e9e:	470d                	li	a4,3
    80004ea0:	04e78d63          	beq	a5,a4,80004efa <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004ea4:	4709                	li	a4,2
    80004ea6:	06e79e63          	bne	a5,a4,80004f22 <fileread+0xa6>
    ilock(f->ip);
    80004eaa:	6d08                	ld	a0,24(a0)
    80004eac:	fffff097          	auipc	ra,0xfffff
    80004eb0:	008080e7          	jalr	8(ra) # 80003eb4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004eb4:	874a                	mv	a4,s2
    80004eb6:	5094                	lw	a3,32(s1)
    80004eb8:	864e                	mv	a2,s3
    80004eba:	4585                	li	a1,1
    80004ebc:	6c88                	ld	a0,24(s1)
    80004ebe:	fffff097          	auipc	ra,0xfffff
    80004ec2:	2aa080e7          	jalr	682(ra) # 80004168 <readi>
    80004ec6:	892a                	mv	s2,a0
    80004ec8:	00a05563          	blez	a0,80004ed2 <fileread+0x56>
      f->off += r;
    80004ecc:	509c                	lw	a5,32(s1)
    80004ece:	9fa9                	addw	a5,a5,a0
    80004ed0:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004ed2:	6c88                	ld	a0,24(s1)
    80004ed4:	fffff097          	auipc	ra,0xfffff
    80004ed8:	0a2080e7          	jalr	162(ra) # 80003f76 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004edc:	854a                	mv	a0,s2
    80004ede:	70a2                	ld	ra,40(sp)
    80004ee0:	7402                	ld	s0,32(sp)
    80004ee2:	64e2                	ld	s1,24(sp)
    80004ee4:	6942                	ld	s2,16(sp)
    80004ee6:	69a2                	ld	s3,8(sp)
    80004ee8:	6145                	addi	sp,sp,48
    80004eea:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004eec:	6908                	ld	a0,16(a0)
    80004eee:	00000097          	auipc	ra,0x0
    80004ef2:	3c6080e7          	jalr	966(ra) # 800052b4 <piperead>
    80004ef6:	892a                	mv	s2,a0
    80004ef8:	b7d5                	j	80004edc <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004efa:	02451783          	lh	a5,36(a0)
    80004efe:	03079693          	slli	a3,a5,0x30
    80004f02:	92c1                	srli	a3,a3,0x30
    80004f04:	4725                	li	a4,9
    80004f06:	02d76863          	bltu	a4,a3,80004f36 <fileread+0xba>
    80004f0a:	0792                	slli	a5,a5,0x4
    80004f0c:	0023c717          	auipc	a4,0x23c
    80004f10:	72470713          	addi	a4,a4,1828 # 80241630 <devsw>
    80004f14:	97ba                	add	a5,a5,a4
    80004f16:	639c                	ld	a5,0(a5)
    80004f18:	c38d                	beqz	a5,80004f3a <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004f1a:	4505                	li	a0,1
    80004f1c:	9782                	jalr	a5
    80004f1e:	892a                	mv	s2,a0
    80004f20:	bf75                	j	80004edc <fileread+0x60>
    panic("fileread");
    80004f22:	00003517          	auipc	a0,0x3
    80004f26:	7f650513          	addi	a0,a0,2038 # 80008718 <syscalls+0x270>
    80004f2a:	ffffb097          	auipc	ra,0xffffb
    80004f2e:	614080e7          	jalr	1556(ra) # 8000053e <panic>
    return -1;
    80004f32:	597d                	li	s2,-1
    80004f34:	b765                	j	80004edc <fileread+0x60>
      return -1;
    80004f36:	597d                	li	s2,-1
    80004f38:	b755                	j	80004edc <fileread+0x60>
    80004f3a:	597d                	li	s2,-1
    80004f3c:	b745                	j	80004edc <fileread+0x60>

0000000080004f3e <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004f3e:	715d                	addi	sp,sp,-80
    80004f40:	e486                	sd	ra,72(sp)
    80004f42:	e0a2                	sd	s0,64(sp)
    80004f44:	fc26                	sd	s1,56(sp)
    80004f46:	f84a                	sd	s2,48(sp)
    80004f48:	f44e                	sd	s3,40(sp)
    80004f4a:	f052                	sd	s4,32(sp)
    80004f4c:	ec56                	sd	s5,24(sp)
    80004f4e:	e85a                	sd	s6,16(sp)
    80004f50:	e45e                	sd	s7,8(sp)
    80004f52:	e062                	sd	s8,0(sp)
    80004f54:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004f56:	00954783          	lbu	a5,9(a0)
    80004f5a:	10078663          	beqz	a5,80005066 <filewrite+0x128>
    80004f5e:	892a                	mv	s2,a0
    80004f60:	8aae                	mv	s5,a1
    80004f62:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004f64:	411c                	lw	a5,0(a0)
    80004f66:	4705                	li	a4,1
    80004f68:	02e78263          	beq	a5,a4,80004f8c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004f6c:	470d                	li	a4,3
    80004f6e:	02e78663          	beq	a5,a4,80004f9a <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004f72:	4709                	li	a4,2
    80004f74:	0ee79163          	bne	a5,a4,80005056 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004f78:	0ac05d63          	blez	a2,80005032 <filewrite+0xf4>
    int i = 0;
    80004f7c:	4981                	li	s3,0
    80004f7e:	6b05                	lui	s6,0x1
    80004f80:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004f84:	6b85                	lui	s7,0x1
    80004f86:	c00b8b9b          	addiw	s7,s7,-1024
    80004f8a:	a861                	j	80005022 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004f8c:	6908                	ld	a0,16(a0)
    80004f8e:	00000097          	auipc	ra,0x0
    80004f92:	22e080e7          	jalr	558(ra) # 800051bc <pipewrite>
    80004f96:	8a2a                	mv	s4,a0
    80004f98:	a045                	j	80005038 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004f9a:	02451783          	lh	a5,36(a0)
    80004f9e:	03079693          	slli	a3,a5,0x30
    80004fa2:	92c1                	srli	a3,a3,0x30
    80004fa4:	4725                	li	a4,9
    80004fa6:	0cd76263          	bltu	a4,a3,8000506a <filewrite+0x12c>
    80004faa:	0792                	slli	a5,a5,0x4
    80004fac:	0023c717          	auipc	a4,0x23c
    80004fb0:	68470713          	addi	a4,a4,1668 # 80241630 <devsw>
    80004fb4:	97ba                	add	a5,a5,a4
    80004fb6:	679c                	ld	a5,8(a5)
    80004fb8:	cbdd                	beqz	a5,8000506e <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004fba:	4505                	li	a0,1
    80004fbc:	9782                	jalr	a5
    80004fbe:	8a2a                	mv	s4,a0
    80004fc0:	a8a5                	j	80005038 <filewrite+0xfa>
    80004fc2:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004fc6:	00000097          	auipc	ra,0x0
    80004fca:	8b0080e7          	jalr	-1872(ra) # 80004876 <begin_op>
      ilock(f->ip);
    80004fce:	01893503          	ld	a0,24(s2)
    80004fd2:	fffff097          	auipc	ra,0xfffff
    80004fd6:	ee2080e7          	jalr	-286(ra) # 80003eb4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004fda:	8762                	mv	a4,s8
    80004fdc:	02092683          	lw	a3,32(s2)
    80004fe0:	01598633          	add	a2,s3,s5
    80004fe4:	4585                	li	a1,1
    80004fe6:	01893503          	ld	a0,24(s2)
    80004fea:	fffff097          	auipc	ra,0xfffff
    80004fee:	276080e7          	jalr	630(ra) # 80004260 <writei>
    80004ff2:	84aa                	mv	s1,a0
    80004ff4:	00a05763          	blez	a0,80005002 <filewrite+0xc4>
        f->off += r;
    80004ff8:	02092783          	lw	a5,32(s2)
    80004ffc:	9fa9                	addw	a5,a5,a0
    80004ffe:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80005002:	01893503          	ld	a0,24(s2)
    80005006:	fffff097          	auipc	ra,0xfffff
    8000500a:	f70080e7          	jalr	-144(ra) # 80003f76 <iunlock>
      end_op();
    8000500e:	00000097          	auipc	ra,0x0
    80005012:	8e8080e7          	jalr	-1816(ra) # 800048f6 <end_op>

      if(r != n1){
    80005016:	009c1f63          	bne	s8,s1,80005034 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    8000501a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000501e:	0149db63          	bge	s3,s4,80005034 <filewrite+0xf6>
      int n1 = n - i;
    80005022:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80005026:	84be                	mv	s1,a5
    80005028:	2781                	sext.w	a5,a5
    8000502a:	f8fb5ce3          	bge	s6,a5,80004fc2 <filewrite+0x84>
    8000502e:	84de                	mv	s1,s7
    80005030:	bf49                	j	80004fc2 <filewrite+0x84>
    int i = 0;
    80005032:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80005034:	013a1f63          	bne	s4,s3,80005052 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80005038:	8552                	mv	a0,s4
    8000503a:	60a6                	ld	ra,72(sp)
    8000503c:	6406                	ld	s0,64(sp)
    8000503e:	74e2                	ld	s1,56(sp)
    80005040:	7942                	ld	s2,48(sp)
    80005042:	79a2                	ld	s3,40(sp)
    80005044:	7a02                	ld	s4,32(sp)
    80005046:	6ae2                	ld	s5,24(sp)
    80005048:	6b42                	ld	s6,16(sp)
    8000504a:	6ba2                	ld	s7,8(sp)
    8000504c:	6c02                	ld	s8,0(sp)
    8000504e:	6161                	addi	sp,sp,80
    80005050:	8082                	ret
    ret = (i == n ? n : -1);
    80005052:	5a7d                	li	s4,-1
    80005054:	b7d5                	j	80005038 <filewrite+0xfa>
    panic("filewrite");
    80005056:	00003517          	auipc	a0,0x3
    8000505a:	6d250513          	addi	a0,a0,1746 # 80008728 <syscalls+0x280>
    8000505e:	ffffb097          	auipc	ra,0xffffb
    80005062:	4e0080e7          	jalr	1248(ra) # 8000053e <panic>
    return -1;
    80005066:	5a7d                	li	s4,-1
    80005068:	bfc1                	j	80005038 <filewrite+0xfa>
      return -1;
    8000506a:	5a7d                	li	s4,-1
    8000506c:	b7f1                	j	80005038 <filewrite+0xfa>
    8000506e:	5a7d                	li	s4,-1
    80005070:	b7e1                	j	80005038 <filewrite+0xfa>

0000000080005072 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80005072:	7179                	addi	sp,sp,-48
    80005074:	f406                	sd	ra,40(sp)
    80005076:	f022                	sd	s0,32(sp)
    80005078:	ec26                	sd	s1,24(sp)
    8000507a:	e84a                	sd	s2,16(sp)
    8000507c:	e44e                	sd	s3,8(sp)
    8000507e:	e052                	sd	s4,0(sp)
    80005080:	1800                	addi	s0,sp,48
    80005082:	84aa                	mv	s1,a0
    80005084:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80005086:	0005b023          	sd	zero,0(a1)
    8000508a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000508e:	00000097          	auipc	ra,0x0
    80005092:	bf8080e7          	jalr	-1032(ra) # 80004c86 <filealloc>
    80005096:	e088                	sd	a0,0(s1)
    80005098:	c551                	beqz	a0,80005124 <pipealloc+0xb2>
    8000509a:	00000097          	auipc	ra,0x0
    8000509e:	bec080e7          	jalr	-1044(ra) # 80004c86 <filealloc>
    800050a2:	00aa3023          	sd	a0,0(s4)
    800050a6:	c92d                	beqz	a0,80005118 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800050a8:	ffffc097          	auipc	ra,0xffffc
    800050ac:	c56080e7          	jalr	-938(ra) # 80000cfe <kalloc>
    800050b0:	892a                	mv	s2,a0
    800050b2:	c125                	beqz	a0,80005112 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    800050b4:	4985                	li	s3,1
    800050b6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800050ba:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800050be:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800050c2:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800050c6:	00003597          	auipc	a1,0x3
    800050ca:	67258593          	addi	a1,a1,1650 # 80008738 <syscalls+0x290>
    800050ce:	ffffc097          	auipc	ra,0xffffc
    800050d2:	c9c080e7          	jalr	-868(ra) # 80000d6a <initlock>
  (*f0)->type = FD_PIPE;
    800050d6:	609c                	ld	a5,0(s1)
    800050d8:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800050dc:	609c                	ld	a5,0(s1)
    800050de:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800050e2:	609c                	ld	a5,0(s1)
    800050e4:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800050e8:	609c                	ld	a5,0(s1)
    800050ea:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800050ee:	000a3783          	ld	a5,0(s4)
    800050f2:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800050f6:	000a3783          	ld	a5,0(s4)
    800050fa:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800050fe:	000a3783          	ld	a5,0(s4)
    80005102:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80005106:	000a3783          	ld	a5,0(s4)
    8000510a:	0127b823          	sd	s2,16(a5)
  return 0;
    8000510e:	4501                	li	a0,0
    80005110:	a025                	j	80005138 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80005112:	6088                	ld	a0,0(s1)
    80005114:	e501                	bnez	a0,8000511c <pipealloc+0xaa>
    80005116:	a039                	j	80005124 <pipealloc+0xb2>
    80005118:	6088                	ld	a0,0(s1)
    8000511a:	c51d                	beqz	a0,80005148 <pipealloc+0xd6>
    fileclose(*f0);
    8000511c:	00000097          	auipc	ra,0x0
    80005120:	c26080e7          	jalr	-986(ra) # 80004d42 <fileclose>
  if(*f1)
    80005124:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80005128:	557d                	li	a0,-1
  if(*f1)
    8000512a:	c799                	beqz	a5,80005138 <pipealloc+0xc6>
    fileclose(*f1);
    8000512c:	853e                	mv	a0,a5
    8000512e:	00000097          	auipc	ra,0x0
    80005132:	c14080e7          	jalr	-1004(ra) # 80004d42 <fileclose>
  return -1;
    80005136:	557d                	li	a0,-1
}
    80005138:	70a2                	ld	ra,40(sp)
    8000513a:	7402                	ld	s0,32(sp)
    8000513c:	64e2                	ld	s1,24(sp)
    8000513e:	6942                	ld	s2,16(sp)
    80005140:	69a2                	ld	s3,8(sp)
    80005142:	6a02                	ld	s4,0(sp)
    80005144:	6145                	addi	sp,sp,48
    80005146:	8082                	ret
  return -1;
    80005148:	557d                	li	a0,-1
    8000514a:	b7fd                	j	80005138 <pipealloc+0xc6>

000000008000514c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000514c:	1101                	addi	sp,sp,-32
    8000514e:	ec06                	sd	ra,24(sp)
    80005150:	e822                	sd	s0,16(sp)
    80005152:	e426                	sd	s1,8(sp)
    80005154:	e04a                	sd	s2,0(sp)
    80005156:	1000                	addi	s0,sp,32
    80005158:	84aa                	mv	s1,a0
    8000515a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000515c:	ffffc097          	auipc	ra,0xffffc
    80005160:	c9e080e7          	jalr	-866(ra) # 80000dfa <acquire>
  if(writable){
    80005164:	02090d63          	beqz	s2,8000519e <pipeclose+0x52>
    pi->writeopen = 0;
    80005168:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000516c:	21848513          	addi	a0,s1,536
    80005170:	ffffd097          	auipc	ra,0xffffd
    80005174:	3d6080e7          	jalr	982(ra) # 80002546 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80005178:	2204b783          	ld	a5,544(s1)
    8000517c:	eb95                	bnez	a5,800051b0 <pipeclose+0x64>
    release(&pi->lock);
    8000517e:	8526                	mv	a0,s1
    80005180:	ffffc097          	auipc	ra,0xffffc
    80005184:	d2e080e7          	jalr	-722(ra) # 80000eae <release>
    kfree((char*)pi);
    80005188:	8526                	mv	a0,s1
    8000518a:	ffffc097          	auipc	ra,0xffffc
    8000518e:	9ec080e7          	jalr	-1556(ra) # 80000b76 <kfree>
  } else
    release(&pi->lock);
}
    80005192:	60e2                	ld	ra,24(sp)
    80005194:	6442                	ld	s0,16(sp)
    80005196:	64a2                	ld	s1,8(sp)
    80005198:	6902                	ld	s2,0(sp)
    8000519a:	6105                	addi	sp,sp,32
    8000519c:	8082                	ret
    pi->readopen = 0;
    8000519e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800051a2:	21c48513          	addi	a0,s1,540
    800051a6:	ffffd097          	auipc	ra,0xffffd
    800051aa:	3a0080e7          	jalr	928(ra) # 80002546 <wakeup>
    800051ae:	b7e9                	j	80005178 <pipeclose+0x2c>
    release(&pi->lock);
    800051b0:	8526                	mv	a0,s1
    800051b2:	ffffc097          	auipc	ra,0xffffc
    800051b6:	cfc080e7          	jalr	-772(ra) # 80000eae <release>
}
    800051ba:	bfe1                	j	80005192 <pipeclose+0x46>

00000000800051bc <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800051bc:	711d                	addi	sp,sp,-96
    800051be:	ec86                	sd	ra,88(sp)
    800051c0:	e8a2                	sd	s0,80(sp)
    800051c2:	e4a6                	sd	s1,72(sp)
    800051c4:	e0ca                	sd	s2,64(sp)
    800051c6:	fc4e                	sd	s3,56(sp)
    800051c8:	f852                	sd	s4,48(sp)
    800051ca:	f456                	sd	s5,40(sp)
    800051cc:	f05a                	sd	s6,32(sp)
    800051ce:	ec5e                	sd	s7,24(sp)
    800051d0:	e862                	sd	s8,16(sp)
    800051d2:	1080                	addi	s0,sp,96
    800051d4:	84aa                	mv	s1,a0
    800051d6:	8aae                	mv	s5,a1
    800051d8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800051da:	ffffd097          	auipc	ra,0xffffd
    800051de:	a34080e7          	jalr	-1484(ra) # 80001c0e <myproc>
    800051e2:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800051e4:	8526                	mv	a0,s1
    800051e6:	ffffc097          	auipc	ra,0xffffc
    800051ea:	c14080e7          	jalr	-1004(ra) # 80000dfa <acquire>
  while(i < n){
    800051ee:	0b405663          	blez	s4,8000529a <pipewrite+0xde>
  int i = 0;
    800051f2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800051f4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800051f6:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800051fa:	21c48b93          	addi	s7,s1,540
    800051fe:	a089                	j	80005240 <pipewrite+0x84>
      release(&pi->lock);
    80005200:	8526                	mv	a0,s1
    80005202:	ffffc097          	auipc	ra,0xffffc
    80005206:	cac080e7          	jalr	-852(ra) # 80000eae <release>
      return -1;
    8000520a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000520c:	854a                	mv	a0,s2
    8000520e:	60e6                	ld	ra,88(sp)
    80005210:	6446                	ld	s0,80(sp)
    80005212:	64a6                	ld	s1,72(sp)
    80005214:	6906                	ld	s2,64(sp)
    80005216:	79e2                	ld	s3,56(sp)
    80005218:	7a42                	ld	s4,48(sp)
    8000521a:	7aa2                	ld	s5,40(sp)
    8000521c:	7b02                	ld	s6,32(sp)
    8000521e:	6be2                	ld	s7,24(sp)
    80005220:	6c42                	ld	s8,16(sp)
    80005222:	6125                	addi	sp,sp,96
    80005224:	8082                	ret
      wakeup(&pi->nread);
    80005226:	8562                	mv	a0,s8
    80005228:	ffffd097          	auipc	ra,0xffffd
    8000522c:	31e080e7          	jalr	798(ra) # 80002546 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80005230:	85a6                	mv	a1,s1
    80005232:	855e                	mv	a0,s7
    80005234:	ffffd097          	auipc	ra,0xffffd
    80005238:	2ae080e7          	jalr	686(ra) # 800024e2 <sleep>
  while(i < n){
    8000523c:	07495063          	bge	s2,s4,8000529c <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80005240:	2204a783          	lw	a5,544(s1)
    80005244:	dfd5                	beqz	a5,80005200 <pipewrite+0x44>
    80005246:	854e                	mv	a0,s3
    80005248:	ffffd097          	auipc	ra,0xffffd
    8000524c:	54e080e7          	jalr	1358(ra) # 80002796 <killed>
    80005250:	f945                	bnez	a0,80005200 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80005252:	2184a783          	lw	a5,536(s1)
    80005256:	21c4a703          	lw	a4,540(s1)
    8000525a:	2007879b          	addiw	a5,a5,512
    8000525e:	fcf704e3          	beq	a4,a5,80005226 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005262:	4685                	li	a3,1
    80005264:	01590633          	add	a2,s2,s5
    80005268:	faf40593          	addi	a1,s0,-81
    8000526c:	0509b503          	ld	a0,80(s3)
    80005270:	ffffc097          	auipc	ra,0xffffc
    80005274:	6e6080e7          	jalr	1766(ra) # 80001956 <copyin>
    80005278:	03650263          	beq	a0,s6,8000529c <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000527c:	21c4a783          	lw	a5,540(s1)
    80005280:	0017871b          	addiw	a4,a5,1
    80005284:	20e4ae23          	sw	a4,540(s1)
    80005288:	1ff7f793          	andi	a5,a5,511
    8000528c:	97a6                	add	a5,a5,s1
    8000528e:	faf44703          	lbu	a4,-81(s0)
    80005292:	00e78c23          	sb	a4,24(a5)
      i++;
    80005296:	2905                	addiw	s2,s2,1
    80005298:	b755                	j	8000523c <pipewrite+0x80>
  int i = 0;
    8000529a:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000529c:	21848513          	addi	a0,s1,536
    800052a0:	ffffd097          	auipc	ra,0xffffd
    800052a4:	2a6080e7          	jalr	678(ra) # 80002546 <wakeup>
  release(&pi->lock);
    800052a8:	8526                	mv	a0,s1
    800052aa:	ffffc097          	auipc	ra,0xffffc
    800052ae:	c04080e7          	jalr	-1020(ra) # 80000eae <release>
  return i;
    800052b2:	bfa9                	j	8000520c <pipewrite+0x50>

00000000800052b4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800052b4:	715d                	addi	sp,sp,-80
    800052b6:	e486                	sd	ra,72(sp)
    800052b8:	e0a2                	sd	s0,64(sp)
    800052ba:	fc26                	sd	s1,56(sp)
    800052bc:	f84a                	sd	s2,48(sp)
    800052be:	f44e                	sd	s3,40(sp)
    800052c0:	f052                	sd	s4,32(sp)
    800052c2:	ec56                	sd	s5,24(sp)
    800052c4:	e85a                	sd	s6,16(sp)
    800052c6:	0880                	addi	s0,sp,80
    800052c8:	84aa                	mv	s1,a0
    800052ca:	892e                	mv	s2,a1
    800052cc:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800052ce:	ffffd097          	auipc	ra,0xffffd
    800052d2:	940080e7          	jalr	-1728(ra) # 80001c0e <myproc>
    800052d6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800052d8:	8526                	mv	a0,s1
    800052da:	ffffc097          	auipc	ra,0xffffc
    800052de:	b20080e7          	jalr	-1248(ra) # 80000dfa <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800052e2:	2184a703          	lw	a4,536(s1)
    800052e6:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800052ea:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800052ee:	02f71763          	bne	a4,a5,8000531c <piperead+0x68>
    800052f2:	2244a783          	lw	a5,548(s1)
    800052f6:	c39d                	beqz	a5,8000531c <piperead+0x68>
    if(killed(pr)){
    800052f8:	8552                	mv	a0,s4
    800052fa:	ffffd097          	auipc	ra,0xffffd
    800052fe:	49c080e7          	jalr	1180(ra) # 80002796 <killed>
    80005302:	e941                	bnez	a0,80005392 <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005304:	85a6                	mv	a1,s1
    80005306:	854e                	mv	a0,s3
    80005308:	ffffd097          	auipc	ra,0xffffd
    8000530c:	1da080e7          	jalr	474(ra) # 800024e2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005310:	2184a703          	lw	a4,536(s1)
    80005314:	21c4a783          	lw	a5,540(s1)
    80005318:	fcf70de3          	beq	a4,a5,800052f2 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000531c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000531e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005320:	05505363          	blez	s5,80005366 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80005324:	2184a783          	lw	a5,536(s1)
    80005328:	21c4a703          	lw	a4,540(s1)
    8000532c:	02f70d63          	beq	a4,a5,80005366 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005330:	0017871b          	addiw	a4,a5,1
    80005334:	20e4ac23          	sw	a4,536(s1)
    80005338:	1ff7f793          	andi	a5,a5,511
    8000533c:	97a6                	add	a5,a5,s1
    8000533e:	0187c783          	lbu	a5,24(a5)
    80005342:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005346:	4685                	li	a3,1
    80005348:	fbf40613          	addi	a2,s0,-65
    8000534c:	85ca                	mv	a1,s2
    8000534e:	050a3503          	ld	a0,80(s4)
    80005352:	ffffc097          	auipc	ra,0xffffc
    80005356:	540080e7          	jalr	1344(ra) # 80001892 <copyout>
    8000535a:	01650663          	beq	a0,s6,80005366 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000535e:	2985                	addiw	s3,s3,1
    80005360:	0905                	addi	s2,s2,1
    80005362:	fd3a91e3          	bne	s5,s3,80005324 <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005366:	21c48513          	addi	a0,s1,540
    8000536a:	ffffd097          	auipc	ra,0xffffd
    8000536e:	1dc080e7          	jalr	476(ra) # 80002546 <wakeup>
  release(&pi->lock);
    80005372:	8526                	mv	a0,s1
    80005374:	ffffc097          	auipc	ra,0xffffc
    80005378:	b3a080e7          	jalr	-1222(ra) # 80000eae <release>
  return i;
}
    8000537c:	854e                	mv	a0,s3
    8000537e:	60a6                	ld	ra,72(sp)
    80005380:	6406                	ld	s0,64(sp)
    80005382:	74e2                	ld	s1,56(sp)
    80005384:	7942                	ld	s2,48(sp)
    80005386:	79a2                	ld	s3,40(sp)
    80005388:	7a02                	ld	s4,32(sp)
    8000538a:	6ae2                	ld	s5,24(sp)
    8000538c:	6b42                	ld	s6,16(sp)
    8000538e:	6161                	addi	sp,sp,80
    80005390:	8082                	ret
      release(&pi->lock);
    80005392:	8526                	mv	a0,s1
    80005394:	ffffc097          	auipc	ra,0xffffc
    80005398:	b1a080e7          	jalr	-1254(ra) # 80000eae <release>
      return -1;
    8000539c:	59fd                	li	s3,-1
    8000539e:	bff9                	j	8000537c <piperead+0xc8>

00000000800053a0 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800053a0:	1141                	addi	sp,sp,-16
    800053a2:	e422                	sd	s0,8(sp)
    800053a4:	0800                	addi	s0,sp,16
    800053a6:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800053a8:	8905                	andi	a0,a0,1
    800053aa:	c111                	beqz	a0,800053ae <flags2perm+0xe>
      perm = PTE_X;
    800053ac:	4521                	li	a0,8
    if(flags & 0x2)
    800053ae:	8b89                	andi	a5,a5,2
    800053b0:	c399                	beqz	a5,800053b6 <flags2perm+0x16>
      perm |= PTE_W;
    800053b2:	00456513          	ori	a0,a0,4
    return perm;
}
    800053b6:	6422                	ld	s0,8(sp)
    800053b8:	0141                	addi	sp,sp,16
    800053ba:	8082                	ret

00000000800053bc <exec>:

int
exec(char *path, char **argv)
{
    800053bc:	de010113          	addi	sp,sp,-544
    800053c0:	20113c23          	sd	ra,536(sp)
    800053c4:	20813823          	sd	s0,528(sp)
    800053c8:	20913423          	sd	s1,520(sp)
    800053cc:	21213023          	sd	s2,512(sp)
    800053d0:	ffce                	sd	s3,504(sp)
    800053d2:	fbd2                	sd	s4,496(sp)
    800053d4:	f7d6                	sd	s5,488(sp)
    800053d6:	f3da                	sd	s6,480(sp)
    800053d8:	efde                	sd	s7,472(sp)
    800053da:	ebe2                	sd	s8,464(sp)
    800053dc:	e7e6                	sd	s9,456(sp)
    800053de:	e3ea                	sd	s10,448(sp)
    800053e0:	ff6e                	sd	s11,440(sp)
    800053e2:	1400                	addi	s0,sp,544
    800053e4:	892a                	mv	s2,a0
    800053e6:	dea43423          	sd	a0,-536(s0)
    800053ea:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800053ee:	ffffd097          	auipc	ra,0xffffd
    800053f2:	820080e7          	jalr	-2016(ra) # 80001c0e <myproc>
    800053f6:	84aa                	mv	s1,a0

  begin_op();
    800053f8:	fffff097          	auipc	ra,0xfffff
    800053fc:	47e080e7          	jalr	1150(ra) # 80004876 <begin_op>

  if((ip = namei(path)) == 0){
    80005400:	854a                	mv	a0,s2
    80005402:	fffff097          	auipc	ra,0xfffff
    80005406:	258080e7          	jalr	600(ra) # 8000465a <namei>
    8000540a:	c93d                	beqz	a0,80005480 <exec+0xc4>
    8000540c:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000540e:	fffff097          	auipc	ra,0xfffff
    80005412:	aa6080e7          	jalr	-1370(ra) # 80003eb4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005416:	04000713          	li	a4,64
    8000541a:	4681                	li	a3,0
    8000541c:	e5040613          	addi	a2,s0,-432
    80005420:	4581                	li	a1,0
    80005422:	8556                	mv	a0,s5
    80005424:	fffff097          	auipc	ra,0xfffff
    80005428:	d44080e7          	jalr	-700(ra) # 80004168 <readi>
    8000542c:	04000793          	li	a5,64
    80005430:	00f51a63          	bne	a0,a5,80005444 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80005434:	e5042703          	lw	a4,-432(s0)
    80005438:	464c47b7          	lui	a5,0x464c4
    8000543c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005440:	04f70663          	beq	a4,a5,8000548c <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005444:	8556                	mv	a0,s5
    80005446:	fffff097          	auipc	ra,0xfffff
    8000544a:	cd0080e7          	jalr	-816(ra) # 80004116 <iunlockput>
    end_op();
    8000544e:	fffff097          	auipc	ra,0xfffff
    80005452:	4a8080e7          	jalr	1192(ra) # 800048f6 <end_op>
  }
  return -1;
    80005456:	557d                	li	a0,-1
}
    80005458:	21813083          	ld	ra,536(sp)
    8000545c:	21013403          	ld	s0,528(sp)
    80005460:	20813483          	ld	s1,520(sp)
    80005464:	20013903          	ld	s2,512(sp)
    80005468:	79fe                	ld	s3,504(sp)
    8000546a:	7a5e                	ld	s4,496(sp)
    8000546c:	7abe                	ld	s5,488(sp)
    8000546e:	7b1e                	ld	s6,480(sp)
    80005470:	6bfe                	ld	s7,472(sp)
    80005472:	6c5e                	ld	s8,464(sp)
    80005474:	6cbe                	ld	s9,456(sp)
    80005476:	6d1e                	ld	s10,448(sp)
    80005478:	7dfa                	ld	s11,440(sp)
    8000547a:	22010113          	addi	sp,sp,544
    8000547e:	8082                	ret
    end_op();
    80005480:	fffff097          	auipc	ra,0xfffff
    80005484:	476080e7          	jalr	1142(ra) # 800048f6 <end_op>
    return -1;
    80005488:	557d                	li	a0,-1
    8000548a:	b7f9                	j	80005458 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000548c:	8526                	mv	a0,s1
    8000548e:	ffffd097          	auipc	ra,0xffffd
    80005492:	844080e7          	jalr	-1980(ra) # 80001cd2 <proc_pagetable>
    80005496:	8b2a                	mv	s6,a0
    80005498:	d555                	beqz	a0,80005444 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000549a:	e7042783          	lw	a5,-400(s0)
    8000549e:	e8845703          	lhu	a4,-376(s0)
    800054a2:	c735                	beqz	a4,8000550e <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800054a4:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800054a6:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    800054aa:	6a05                	lui	s4,0x1
    800054ac:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800054b0:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800054b4:	6d85                	lui	s11,0x1
    800054b6:	7d7d                	lui	s10,0xfffff
    800054b8:	a481                	j	800056f8 <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800054ba:	00003517          	auipc	a0,0x3
    800054be:	28650513          	addi	a0,a0,646 # 80008740 <syscalls+0x298>
    800054c2:	ffffb097          	auipc	ra,0xffffb
    800054c6:	07c080e7          	jalr	124(ra) # 8000053e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800054ca:	874a                	mv	a4,s2
    800054cc:	009c86bb          	addw	a3,s9,s1
    800054d0:	4581                	li	a1,0
    800054d2:	8556                	mv	a0,s5
    800054d4:	fffff097          	auipc	ra,0xfffff
    800054d8:	c94080e7          	jalr	-876(ra) # 80004168 <readi>
    800054dc:	2501                	sext.w	a0,a0
    800054de:	1aa91a63          	bne	s2,a0,80005692 <exec+0x2d6>
  for(i = 0; i < sz; i += PGSIZE){
    800054e2:	009d84bb          	addw	s1,s11,s1
    800054e6:	013d09bb          	addw	s3,s10,s3
    800054ea:	1f74f763          	bgeu	s1,s7,800056d8 <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    800054ee:	02049593          	slli	a1,s1,0x20
    800054f2:	9181                	srli	a1,a1,0x20
    800054f4:	95e2                	add	a1,a1,s8
    800054f6:	855a                	mv	a0,s6
    800054f8:	ffffc097          	auipc	ra,0xffffc
    800054fc:	d88080e7          	jalr	-632(ra) # 80001280 <walkaddr>
    80005500:	862a                	mv	a2,a0
    if(pa == 0)
    80005502:	dd45                	beqz	a0,800054ba <exec+0xfe>
      n = PGSIZE;
    80005504:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80005506:	fd49f2e3          	bgeu	s3,s4,800054ca <exec+0x10e>
      n = sz - i;
    8000550a:	894e                	mv	s2,s3
    8000550c:	bf7d                	j	800054ca <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000550e:	4901                	li	s2,0
  iunlockput(ip);
    80005510:	8556                	mv	a0,s5
    80005512:	fffff097          	auipc	ra,0xfffff
    80005516:	c04080e7          	jalr	-1020(ra) # 80004116 <iunlockput>
  end_op();
    8000551a:	fffff097          	auipc	ra,0xfffff
    8000551e:	3dc080e7          	jalr	988(ra) # 800048f6 <end_op>
  p = myproc();
    80005522:	ffffc097          	auipc	ra,0xffffc
    80005526:	6ec080e7          	jalr	1772(ra) # 80001c0e <myproc>
    8000552a:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    8000552c:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80005530:	6785                	lui	a5,0x1
    80005532:	17fd                	addi	a5,a5,-1
    80005534:	993e                	add	s2,s2,a5
    80005536:	77fd                	lui	a5,0xfffff
    80005538:	00f977b3          	and	a5,s2,a5
    8000553c:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005540:	4691                	li	a3,4
    80005542:	6609                	lui	a2,0x2
    80005544:	963e                	add	a2,a2,a5
    80005546:	85be                	mv	a1,a5
    80005548:	855a                	mv	a0,s6
    8000554a:	ffffc097          	auipc	ra,0xffffc
    8000554e:	0ea080e7          	jalr	234(ra) # 80001634 <uvmalloc>
    80005552:	8c2a                	mv	s8,a0
  ip = 0;
    80005554:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005556:	12050e63          	beqz	a0,80005692 <exec+0x2d6>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000555a:	75f9                	lui	a1,0xffffe
    8000555c:	95aa                	add	a1,a1,a0
    8000555e:	855a                	mv	a0,s6
    80005560:	ffffc097          	auipc	ra,0xffffc
    80005564:	300080e7          	jalr	768(ra) # 80001860 <uvmclear>
  stackbase = sp - PGSIZE;
    80005568:	7afd                	lui	s5,0xfffff
    8000556a:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000556c:	df043783          	ld	a5,-528(s0)
    80005570:	6388                	ld	a0,0(a5)
    80005572:	c925                	beqz	a0,800055e2 <exec+0x226>
    80005574:	e9040993          	addi	s3,s0,-368
    80005578:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000557c:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000557e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005580:	ffffc097          	auipc	ra,0xffffc
    80005584:	af2080e7          	jalr	-1294(ra) # 80001072 <strlen>
    80005588:	0015079b          	addiw	a5,a0,1
    8000558c:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005590:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80005594:	13596663          	bltu	s2,s5,800056c0 <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005598:	df043d83          	ld	s11,-528(s0)
    8000559c:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800055a0:	8552                	mv	a0,s4
    800055a2:	ffffc097          	auipc	ra,0xffffc
    800055a6:	ad0080e7          	jalr	-1328(ra) # 80001072 <strlen>
    800055aa:	0015069b          	addiw	a3,a0,1
    800055ae:	8652                	mv	a2,s4
    800055b0:	85ca                	mv	a1,s2
    800055b2:	855a                	mv	a0,s6
    800055b4:	ffffc097          	auipc	ra,0xffffc
    800055b8:	2de080e7          	jalr	734(ra) # 80001892 <copyout>
    800055bc:	10054663          	bltz	a0,800056c8 <exec+0x30c>
    ustack[argc] = sp;
    800055c0:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800055c4:	0485                	addi	s1,s1,1
    800055c6:	008d8793          	addi	a5,s11,8
    800055ca:	def43823          	sd	a5,-528(s0)
    800055ce:	008db503          	ld	a0,8(s11)
    800055d2:	c911                	beqz	a0,800055e6 <exec+0x22a>
    if(argc >= MAXARG)
    800055d4:	09a1                	addi	s3,s3,8
    800055d6:	fb3c95e3          	bne	s9,s3,80005580 <exec+0x1c4>
  sz = sz1;
    800055da:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800055de:	4a81                	li	s5,0
    800055e0:	a84d                	j	80005692 <exec+0x2d6>
  sp = sz;
    800055e2:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800055e4:	4481                	li	s1,0
  ustack[argc] = 0;
    800055e6:	00349793          	slli	a5,s1,0x3
    800055ea:	f9040713          	addi	a4,s0,-112
    800055ee:	97ba                	add	a5,a5,a4
    800055f0:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7fdbc738>
  sp -= (argc+1) * sizeof(uint64);
    800055f4:	00148693          	addi	a3,s1,1
    800055f8:	068e                	slli	a3,a3,0x3
    800055fa:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800055fe:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80005602:	01597663          	bgeu	s2,s5,8000560e <exec+0x252>
  sz = sz1;
    80005606:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000560a:	4a81                	li	s5,0
    8000560c:	a059                	j	80005692 <exec+0x2d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000560e:	e9040613          	addi	a2,s0,-368
    80005612:	85ca                	mv	a1,s2
    80005614:	855a                	mv	a0,s6
    80005616:	ffffc097          	auipc	ra,0xffffc
    8000561a:	27c080e7          	jalr	636(ra) # 80001892 <copyout>
    8000561e:	0a054963          	bltz	a0,800056d0 <exec+0x314>
  p->trapframe->a1 = sp;
    80005622:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80005626:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000562a:	de843783          	ld	a5,-536(s0)
    8000562e:	0007c703          	lbu	a4,0(a5)
    80005632:	cf11                	beqz	a4,8000564e <exec+0x292>
    80005634:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005636:	02f00693          	li	a3,47
    8000563a:	a039                	j	80005648 <exec+0x28c>
      last = s+1;
    8000563c:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80005640:	0785                	addi	a5,a5,1
    80005642:	fff7c703          	lbu	a4,-1(a5)
    80005646:	c701                	beqz	a4,8000564e <exec+0x292>
    if(*s == '/')
    80005648:	fed71ce3          	bne	a4,a3,80005640 <exec+0x284>
    8000564c:	bfc5                	j	8000563c <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    8000564e:	4641                	li	a2,16
    80005650:	de843583          	ld	a1,-536(s0)
    80005654:	158b8513          	addi	a0,s7,344
    80005658:	ffffc097          	auipc	ra,0xffffc
    8000565c:	9e8080e7          	jalr	-1560(ra) # 80001040 <safestrcpy>
  oldpagetable = p->pagetable;
    80005660:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80005664:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80005668:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000566c:	058bb783          	ld	a5,88(s7)
    80005670:	e6843703          	ld	a4,-408(s0)
    80005674:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005676:	058bb783          	ld	a5,88(s7)
    8000567a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000567e:	85ea                	mv	a1,s10
    80005680:	ffffc097          	auipc	ra,0xffffc
    80005684:	6ee080e7          	jalr	1774(ra) # 80001d6e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005688:	0004851b          	sext.w	a0,s1
    8000568c:	b3f1                	j	80005458 <exec+0x9c>
    8000568e:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005692:	df843583          	ld	a1,-520(s0)
    80005696:	855a                	mv	a0,s6
    80005698:	ffffc097          	auipc	ra,0xffffc
    8000569c:	6d6080e7          	jalr	1750(ra) # 80001d6e <proc_freepagetable>
  if(ip){
    800056a0:	da0a92e3          	bnez	s5,80005444 <exec+0x88>
  return -1;
    800056a4:	557d                	li	a0,-1
    800056a6:	bb4d                	j	80005458 <exec+0x9c>
    800056a8:	df243c23          	sd	s2,-520(s0)
    800056ac:	b7dd                	j	80005692 <exec+0x2d6>
    800056ae:	df243c23          	sd	s2,-520(s0)
    800056b2:	b7c5                	j	80005692 <exec+0x2d6>
    800056b4:	df243c23          	sd	s2,-520(s0)
    800056b8:	bfe9                	j	80005692 <exec+0x2d6>
    800056ba:	df243c23          	sd	s2,-520(s0)
    800056be:	bfd1                	j	80005692 <exec+0x2d6>
  sz = sz1;
    800056c0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800056c4:	4a81                	li	s5,0
    800056c6:	b7f1                	j	80005692 <exec+0x2d6>
  sz = sz1;
    800056c8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800056cc:	4a81                	li	s5,0
    800056ce:	b7d1                	j	80005692 <exec+0x2d6>
  sz = sz1;
    800056d0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800056d4:	4a81                	li	s5,0
    800056d6:	bf75                	j	80005692 <exec+0x2d6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800056d8:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800056dc:	e0843783          	ld	a5,-504(s0)
    800056e0:	0017869b          	addiw	a3,a5,1
    800056e4:	e0d43423          	sd	a3,-504(s0)
    800056e8:	e0043783          	ld	a5,-512(s0)
    800056ec:	0387879b          	addiw	a5,a5,56
    800056f0:	e8845703          	lhu	a4,-376(s0)
    800056f4:	e0e6dee3          	bge	a3,a4,80005510 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800056f8:	2781                	sext.w	a5,a5
    800056fa:	e0f43023          	sd	a5,-512(s0)
    800056fe:	03800713          	li	a4,56
    80005702:	86be                	mv	a3,a5
    80005704:	e1840613          	addi	a2,s0,-488
    80005708:	4581                	li	a1,0
    8000570a:	8556                	mv	a0,s5
    8000570c:	fffff097          	auipc	ra,0xfffff
    80005710:	a5c080e7          	jalr	-1444(ra) # 80004168 <readi>
    80005714:	03800793          	li	a5,56
    80005718:	f6f51be3          	bne	a0,a5,8000568e <exec+0x2d2>
    if(ph.type != ELF_PROG_LOAD)
    8000571c:	e1842783          	lw	a5,-488(s0)
    80005720:	4705                	li	a4,1
    80005722:	fae79de3          	bne	a5,a4,800056dc <exec+0x320>
    if(ph.memsz < ph.filesz)
    80005726:	e4043483          	ld	s1,-448(s0)
    8000572a:	e3843783          	ld	a5,-456(s0)
    8000572e:	f6f4ede3          	bltu	s1,a5,800056a8 <exec+0x2ec>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005732:	e2843783          	ld	a5,-472(s0)
    80005736:	94be                	add	s1,s1,a5
    80005738:	f6f4ebe3          	bltu	s1,a5,800056ae <exec+0x2f2>
    if(ph.vaddr % PGSIZE != 0)
    8000573c:	de043703          	ld	a4,-544(s0)
    80005740:	8ff9                	and	a5,a5,a4
    80005742:	fbad                	bnez	a5,800056b4 <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005744:	e1c42503          	lw	a0,-484(s0)
    80005748:	00000097          	auipc	ra,0x0
    8000574c:	c58080e7          	jalr	-936(ra) # 800053a0 <flags2perm>
    80005750:	86aa                	mv	a3,a0
    80005752:	8626                	mv	a2,s1
    80005754:	85ca                	mv	a1,s2
    80005756:	855a                	mv	a0,s6
    80005758:	ffffc097          	auipc	ra,0xffffc
    8000575c:	edc080e7          	jalr	-292(ra) # 80001634 <uvmalloc>
    80005760:	dea43c23          	sd	a0,-520(s0)
    80005764:	d939                	beqz	a0,800056ba <exec+0x2fe>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005766:	e2843c03          	ld	s8,-472(s0)
    8000576a:	e2042c83          	lw	s9,-480(s0)
    8000576e:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005772:	f60b83e3          	beqz	s7,800056d8 <exec+0x31c>
    80005776:	89de                	mv	s3,s7
    80005778:	4481                	li	s1,0
    8000577a:	bb95                	j	800054ee <exec+0x132>

000000008000577c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000577c:	7179                	addi	sp,sp,-48
    8000577e:	f406                	sd	ra,40(sp)
    80005780:	f022                	sd	s0,32(sp)
    80005782:	ec26                	sd	s1,24(sp)
    80005784:	e84a                	sd	s2,16(sp)
    80005786:	1800                	addi	s0,sp,48
    80005788:	892e                	mv	s2,a1
    8000578a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000578c:	fdc40593          	addi	a1,s0,-36
    80005790:	ffffe097          	auipc	ra,0xffffe
    80005794:	ae0080e7          	jalr	-1312(ra) # 80003270 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005798:	fdc42703          	lw	a4,-36(s0)
    8000579c:	47bd                	li	a5,15
    8000579e:	02e7eb63          	bltu	a5,a4,800057d4 <argfd+0x58>
    800057a2:	ffffc097          	auipc	ra,0xffffc
    800057a6:	46c080e7          	jalr	1132(ra) # 80001c0e <myproc>
    800057aa:	fdc42703          	lw	a4,-36(s0)
    800057ae:	01a70793          	addi	a5,a4,26
    800057b2:	078e                	slli	a5,a5,0x3
    800057b4:	953e                	add	a0,a0,a5
    800057b6:	611c                	ld	a5,0(a0)
    800057b8:	c385                	beqz	a5,800057d8 <argfd+0x5c>
    return -1;
  if(pfd)
    800057ba:	00090463          	beqz	s2,800057c2 <argfd+0x46>
    *pfd = fd;
    800057be:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800057c2:	4501                	li	a0,0
  if(pf)
    800057c4:	c091                	beqz	s1,800057c8 <argfd+0x4c>
    *pf = f;
    800057c6:	e09c                	sd	a5,0(s1)
}
    800057c8:	70a2                	ld	ra,40(sp)
    800057ca:	7402                	ld	s0,32(sp)
    800057cc:	64e2                	ld	s1,24(sp)
    800057ce:	6942                	ld	s2,16(sp)
    800057d0:	6145                	addi	sp,sp,48
    800057d2:	8082                	ret
    return -1;
    800057d4:	557d                	li	a0,-1
    800057d6:	bfcd                	j	800057c8 <argfd+0x4c>
    800057d8:	557d                	li	a0,-1
    800057da:	b7fd                	j	800057c8 <argfd+0x4c>

00000000800057dc <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800057dc:	1101                	addi	sp,sp,-32
    800057de:	ec06                	sd	ra,24(sp)
    800057e0:	e822                	sd	s0,16(sp)
    800057e2:	e426                	sd	s1,8(sp)
    800057e4:	1000                	addi	s0,sp,32
    800057e6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800057e8:	ffffc097          	auipc	ra,0xffffc
    800057ec:	426080e7          	jalr	1062(ra) # 80001c0e <myproc>
    800057f0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800057f2:	0d050793          	addi	a5,a0,208
    800057f6:	4501                	li	a0,0
    800057f8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800057fa:	6398                	ld	a4,0(a5)
    800057fc:	cb19                	beqz	a4,80005812 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800057fe:	2505                	addiw	a0,a0,1
    80005800:	07a1                	addi	a5,a5,8
    80005802:	fed51ce3          	bne	a0,a3,800057fa <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005806:	557d                	li	a0,-1
}
    80005808:	60e2                	ld	ra,24(sp)
    8000580a:	6442                	ld	s0,16(sp)
    8000580c:	64a2                	ld	s1,8(sp)
    8000580e:	6105                	addi	sp,sp,32
    80005810:	8082                	ret
      p->ofile[fd] = f;
    80005812:	01a50793          	addi	a5,a0,26
    80005816:	078e                	slli	a5,a5,0x3
    80005818:	963e                	add	a2,a2,a5
    8000581a:	e204                	sd	s1,0(a2)
      return fd;
    8000581c:	b7f5                	j	80005808 <fdalloc+0x2c>

000000008000581e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000581e:	715d                	addi	sp,sp,-80
    80005820:	e486                	sd	ra,72(sp)
    80005822:	e0a2                	sd	s0,64(sp)
    80005824:	fc26                	sd	s1,56(sp)
    80005826:	f84a                	sd	s2,48(sp)
    80005828:	f44e                	sd	s3,40(sp)
    8000582a:	f052                	sd	s4,32(sp)
    8000582c:	ec56                	sd	s5,24(sp)
    8000582e:	e85a                	sd	s6,16(sp)
    80005830:	0880                	addi	s0,sp,80
    80005832:	8b2e                	mv	s6,a1
    80005834:	89b2                	mv	s3,a2
    80005836:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005838:	fb040593          	addi	a1,s0,-80
    8000583c:	fffff097          	auipc	ra,0xfffff
    80005840:	e3c080e7          	jalr	-452(ra) # 80004678 <nameiparent>
    80005844:	84aa                	mv	s1,a0
    80005846:	14050f63          	beqz	a0,800059a4 <create+0x186>
    return 0;

  ilock(dp);
    8000584a:	ffffe097          	auipc	ra,0xffffe
    8000584e:	66a080e7          	jalr	1642(ra) # 80003eb4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005852:	4601                	li	a2,0
    80005854:	fb040593          	addi	a1,s0,-80
    80005858:	8526                	mv	a0,s1
    8000585a:	fffff097          	auipc	ra,0xfffff
    8000585e:	b3e080e7          	jalr	-1218(ra) # 80004398 <dirlookup>
    80005862:	8aaa                	mv	s5,a0
    80005864:	c931                	beqz	a0,800058b8 <create+0x9a>
    iunlockput(dp);
    80005866:	8526                	mv	a0,s1
    80005868:	fffff097          	auipc	ra,0xfffff
    8000586c:	8ae080e7          	jalr	-1874(ra) # 80004116 <iunlockput>
    ilock(ip);
    80005870:	8556                	mv	a0,s5
    80005872:	ffffe097          	auipc	ra,0xffffe
    80005876:	642080e7          	jalr	1602(ra) # 80003eb4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000587a:	000b059b          	sext.w	a1,s6
    8000587e:	4789                	li	a5,2
    80005880:	02f59563          	bne	a1,a5,800058aa <create+0x8c>
    80005884:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7fdbc87c>
    80005888:	37f9                	addiw	a5,a5,-2
    8000588a:	17c2                	slli	a5,a5,0x30
    8000588c:	93c1                	srli	a5,a5,0x30
    8000588e:	4705                	li	a4,1
    80005890:	00f76d63          	bltu	a4,a5,800058aa <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005894:	8556                	mv	a0,s5
    80005896:	60a6                	ld	ra,72(sp)
    80005898:	6406                	ld	s0,64(sp)
    8000589a:	74e2                	ld	s1,56(sp)
    8000589c:	7942                	ld	s2,48(sp)
    8000589e:	79a2                	ld	s3,40(sp)
    800058a0:	7a02                	ld	s4,32(sp)
    800058a2:	6ae2                	ld	s5,24(sp)
    800058a4:	6b42                	ld	s6,16(sp)
    800058a6:	6161                	addi	sp,sp,80
    800058a8:	8082                	ret
    iunlockput(ip);
    800058aa:	8556                	mv	a0,s5
    800058ac:	fffff097          	auipc	ra,0xfffff
    800058b0:	86a080e7          	jalr	-1942(ra) # 80004116 <iunlockput>
    return 0;
    800058b4:	4a81                	li	s5,0
    800058b6:	bff9                	j	80005894 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800058b8:	85da                	mv	a1,s6
    800058ba:	4088                	lw	a0,0(s1)
    800058bc:	ffffe097          	auipc	ra,0xffffe
    800058c0:	45c080e7          	jalr	1116(ra) # 80003d18 <ialloc>
    800058c4:	8a2a                	mv	s4,a0
    800058c6:	c539                	beqz	a0,80005914 <create+0xf6>
  ilock(ip);
    800058c8:	ffffe097          	auipc	ra,0xffffe
    800058cc:	5ec080e7          	jalr	1516(ra) # 80003eb4 <ilock>
  ip->major = major;
    800058d0:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800058d4:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800058d8:	4905                	li	s2,1
    800058da:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800058de:	8552                	mv	a0,s4
    800058e0:	ffffe097          	auipc	ra,0xffffe
    800058e4:	50a080e7          	jalr	1290(ra) # 80003dea <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800058e8:	000b059b          	sext.w	a1,s6
    800058ec:	03258b63          	beq	a1,s2,80005922 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    800058f0:	004a2603          	lw	a2,4(s4)
    800058f4:	fb040593          	addi	a1,s0,-80
    800058f8:	8526                	mv	a0,s1
    800058fa:	fffff097          	auipc	ra,0xfffff
    800058fe:	cae080e7          	jalr	-850(ra) # 800045a8 <dirlink>
    80005902:	06054f63          	bltz	a0,80005980 <create+0x162>
  iunlockput(dp);
    80005906:	8526                	mv	a0,s1
    80005908:	fffff097          	auipc	ra,0xfffff
    8000590c:	80e080e7          	jalr	-2034(ra) # 80004116 <iunlockput>
  return ip;
    80005910:	8ad2                	mv	s5,s4
    80005912:	b749                	j	80005894 <create+0x76>
    iunlockput(dp);
    80005914:	8526                	mv	a0,s1
    80005916:	fffff097          	auipc	ra,0xfffff
    8000591a:	800080e7          	jalr	-2048(ra) # 80004116 <iunlockput>
    return 0;
    8000591e:	8ad2                	mv	s5,s4
    80005920:	bf95                	j	80005894 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005922:	004a2603          	lw	a2,4(s4)
    80005926:	00003597          	auipc	a1,0x3
    8000592a:	e3a58593          	addi	a1,a1,-454 # 80008760 <syscalls+0x2b8>
    8000592e:	8552                	mv	a0,s4
    80005930:	fffff097          	auipc	ra,0xfffff
    80005934:	c78080e7          	jalr	-904(ra) # 800045a8 <dirlink>
    80005938:	04054463          	bltz	a0,80005980 <create+0x162>
    8000593c:	40d0                	lw	a2,4(s1)
    8000593e:	00003597          	auipc	a1,0x3
    80005942:	e2a58593          	addi	a1,a1,-470 # 80008768 <syscalls+0x2c0>
    80005946:	8552                	mv	a0,s4
    80005948:	fffff097          	auipc	ra,0xfffff
    8000594c:	c60080e7          	jalr	-928(ra) # 800045a8 <dirlink>
    80005950:	02054863          	bltz	a0,80005980 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80005954:	004a2603          	lw	a2,4(s4)
    80005958:	fb040593          	addi	a1,s0,-80
    8000595c:	8526                	mv	a0,s1
    8000595e:	fffff097          	auipc	ra,0xfffff
    80005962:	c4a080e7          	jalr	-950(ra) # 800045a8 <dirlink>
    80005966:	00054d63          	bltz	a0,80005980 <create+0x162>
    dp->nlink++;  // for ".."
    8000596a:	04a4d783          	lhu	a5,74(s1)
    8000596e:	2785                	addiw	a5,a5,1
    80005970:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005974:	8526                	mv	a0,s1
    80005976:	ffffe097          	auipc	ra,0xffffe
    8000597a:	474080e7          	jalr	1140(ra) # 80003dea <iupdate>
    8000597e:	b761                	j	80005906 <create+0xe8>
  ip->nlink = 0;
    80005980:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005984:	8552                	mv	a0,s4
    80005986:	ffffe097          	auipc	ra,0xffffe
    8000598a:	464080e7          	jalr	1124(ra) # 80003dea <iupdate>
  iunlockput(ip);
    8000598e:	8552                	mv	a0,s4
    80005990:	ffffe097          	auipc	ra,0xffffe
    80005994:	786080e7          	jalr	1926(ra) # 80004116 <iunlockput>
  iunlockput(dp);
    80005998:	8526                	mv	a0,s1
    8000599a:	ffffe097          	auipc	ra,0xffffe
    8000599e:	77c080e7          	jalr	1916(ra) # 80004116 <iunlockput>
  return 0;
    800059a2:	bdcd                	j	80005894 <create+0x76>
    return 0;
    800059a4:	8aaa                	mv	s5,a0
    800059a6:	b5fd                	j	80005894 <create+0x76>

00000000800059a8 <sys_dup>:
{
    800059a8:	7179                	addi	sp,sp,-48
    800059aa:	f406                	sd	ra,40(sp)
    800059ac:	f022                	sd	s0,32(sp)
    800059ae:	ec26                	sd	s1,24(sp)
    800059b0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800059b2:	fd840613          	addi	a2,s0,-40
    800059b6:	4581                	li	a1,0
    800059b8:	4501                	li	a0,0
    800059ba:	00000097          	auipc	ra,0x0
    800059be:	dc2080e7          	jalr	-574(ra) # 8000577c <argfd>
    return -1;
    800059c2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800059c4:	02054363          	bltz	a0,800059ea <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800059c8:	fd843503          	ld	a0,-40(s0)
    800059cc:	00000097          	auipc	ra,0x0
    800059d0:	e10080e7          	jalr	-496(ra) # 800057dc <fdalloc>
    800059d4:	84aa                	mv	s1,a0
    return -1;
    800059d6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800059d8:	00054963          	bltz	a0,800059ea <sys_dup+0x42>
  filedup(f);
    800059dc:	fd843503          	ld	a0,-40(s0)
    800059e0:	fffff097          	auipc	ra,0xfffff
    800059e4:	310080e7          	jalr	784(ra) # 80004cf0 <filedup>
  return fd;
    800059e8:	87a6                	mv	a5,s1
}
    800059ea:	853e                	mv	a0,a5
    800059ec:	70a2                	ld	ra,40(sp)
    800059ee:	7402                	ld	s0,32(sp)
    800059f0:	64e2                	ld	s1,24(sp)
    800059f2:	6145                	addi	sp,sp,48
    800059f4:	8082                	ret

00000000800059f6 <sys_getreadcount>:
{
    800059f6:	1141                	addi	sp,sp,-16
    800059f8:	e422                	sd	s0,8(sp)
    800059fa:	0800                	addi	s0,sp,16
}
    800059fc:	00003517          	auipc	a0,0x3
    80005a00:	f3852503          	lw	a0,-200(a0) # 80008934 <readCount>
    80005a04:	6422                	ld	s0,8(sp)
    80005a06:	0141                	addi	sp,sp,16
    80005a08:	8082                	ret

0000000080005a0a <sys_read>:
{
    80005a0a:	7179                	addi	sp,sp,-48
    80005a0c:	f406                	sd	ra,40(sp)
    80005a0e:	f022                	sd	s0,32(sp)
    80005a10:	1800                	addi	s0,sp,48
  readCount++;
    80005a12:	00003717          	auipc	a4,0x3
    80005a16:	f2270713          	addi	a4,a4,-222 # 80008934 <readCount>
    80005a1a:	431c                	lw	a5,0(a4)
    80005a1c:	2785                	addiw	a5,a5,1
    80005a1e:	c31c                	sw	a5,0(a4)
  argaddr(1, &p);
    80005a20:	fd840593          	addi	a1,s0,-40
    80005a24:	4505                	li	a0,1
    80005a26:	ffffe097          	auipc	ra,0xffffe
    80005a2a:	86a080e7          	jalr	-1942(ra) # 80003290 <argaddr>
  argint(2, &n);
    80005a2e:	fe440593          	addi	a1,s0,-28
    80005a32:	4509                	li	a0,2
    80005a34:	ffffe097          	auipc	ra,0xffffe
    80005a38:	83c080e7          	jalr	-1988(ra) # 80003270 <argint>
  if(argfd(0, 0, &f) < 0)
    80005a3c:	fe840613          	addi	a2,s0,-24
    80005a40:	4581                	li	a1,0
    80005a42:	4501                	li	a0,0
    80005a44:	00000097          	auipc	ra,0x0
    80005a48:	d38080e7          	jalr	-712(ra) # 8000577c <argfd>
    80005a4c:	87aa                	mv	a5,a0
    return -1;
    80005a4e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005a50:	0007cc63          	bltz	a5,80005a68 <sys_read+0x5e>
  return fileread(f, p, n);
    80005a54:	fe442603          	lw	a2,-28(s0)
    80005a58:	fd843583          	ld	a1,-40(s0)
    80005a5c:	fe843503          	ld	a0,-24(s0)
    80005a60:	fffff097          	auipc	ra,0xfffff
    80005a64:	41c080e7          	jalr	1052(ra) # 80004e7c <fileread>
}
    80005a68:	70a2                	ld	ra,40(sp)
    80005a6a:	7402                	ld	s0,32(sp)
    80005a6c:	6145                	addi	sp,sp,48
    80005a6e:	8082                	ret

0000000080005a70 <sys_write>:
{
    80005a70:	7179                	addi	sp,sp,-48
    80005a72:	f406                	sd	ra,40(sp)
    80005a74:	f022                	sd	s0,32(sp)
    80005a76:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005a78:	fd840593          	addi	a1,s0,-40
    80005a7c:	4505                	li	a0,1
    80005a7e:	ffffe097          	auipc	ra,0xffffe
    80005a82:	812080e7          	jalr	-2030(ra) # 80003290 <argaddr>
  argint(2, &n);
    80005a86:	fe440593          	addi	a1,s0,-28
    80005a8a:	4509                	li	a0,2
    80005a8c:	ffffd097          	auipc	ra,0xffffd
    80005a90:	7e4080e7          	jalr	2020(ra) # 80003270 <argint>
  if(argfd(0, 0, &f) < 0)
    80005a94:	fe840613          	addi	a2,s0,-24
    80005a98:	4581                	li	a1,0
    80005a9a:	4501                	li	a0,0
    80005a9c:	00000097          	auipc	ra,0x0
    80005aa0:	ce0080e7          	jalr	-800(ra) # 8000577c <argfd>
    80005aa4:	87aa                	mv	a5,a0
    return -1;
    80005aa6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005aa8:	0007cc63          	bltz	a5,80005ac0 <sys_write+0x50>
  return filewrite(f, p, n);
    80005aac:	fe442603          	lw	a2,-28(s0)
    80005ab0:	fd843583          	ld	a1,-40(s0)
    80005ab4:	fe843503          	ld	a0,-24(s0)
    80005ab8:	fffff097          	auipc	ra,0xfffff
    80005abc:	486080e7          	jalr	1158(ra) # 80004f3e <filewrite>
}
    80005ac0:	70a2                	ld	ra,40(sp)
    80005ac2:	7402                	ld	s0,32(sp)
    80005ac4:	6145                	addi	sp,sp,48
    80005ac6:	8082                	ret

0000000080005ac8 <sys_close>:
{
    80005ac8:	1101                	addi	sp,sp,-32
    80005aca:	ec06                	sd	ra,24(sp)
    80005acc:	e822                	sd	s0,16(sp)
    80005ace:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005ad0:	fe040613          	addi	a2,s0,-32
    80005ad4:	fec40593          	addi	a1,s0,-20
    80005ad8:	4501                	li	a0,0
    80005ada:	00000097          	auipc	ra,0x0
    80005ade:	ca2080e7          	jalr	-862(ra) # 8000577c <argfd>
    return -1;
    80005ae2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005ae4:	02054463          	bltz	a0,80005b0c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005ae8:	ffffc097          	auipc	ra,0xffffc
    80005aec:	126080e7          	jalr	294(ra) # 80001c0e <myproc>
    80005af0:	fec42783          	lw	a5,-20(s0)
    80005af4:	07e9                	addi	a5,a5,26
    80005af6:	078e                	slli	a5,a5,0x3
    80005af8:	97aa                	add	a5,a5,a0
    80005afa:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005afe:	fe043503          	ld	a0,-32(s0)
    80005b02:	fffff097          	auipc	ra,0xfffff
    80005b06:	240080e7          	jalr	576(ra) # 80004d42 <fileclose>
  return 0;
    80005b0a:	4781                	li	a5,0
}
    80005b0c:	853e                	mv	a0,a5
    80005b0e:	60e2                	ld	ra,24(sp)
    80005b10:	6442                	ld	s0,16(sp)
    80005b12:	6105                	addi	sp,sp,32
    80005b14:	8082                	ret

0000000080005b16 <sys_fstat>:
{
    80005b16:	1101                	addi	sp,sp,-32
    80005b18:	ec06                	sd	ra,24(sp)
    80005b1a:	e822                	sd	s0,16(sp)
    80005b1c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005b1e:	fe040593          	addi	a1,s0,-32
    80005b22:	4505                	li	a0,1
    80005b24:	ffffd097          	auipc	ra,0xffffd
    80005b28:	76c080e7          	jalr	1900(ra) # 80003290 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005b2c:	fe840613          	addi	a2,s0,-24
    80005b30:	4581                	li	a1,0
    80005b32:	4501                	li	a0,0
    80005b34:	00000097          	auipc	ra,0x0
    80005b38:	c48080e7          	jalr	-952(ra) # 8000577c <argfd>
    80005b3c:	87aa                	mv	a5,a0
    return -1;
    80005b3e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005b40:	0007ca63          	bltz	a5,80005b54 <sys_fstat+0x3e>
  return filestat(f, st);
    80005b44:	fe043583          	ld	a1,-32(s0)
    80005b48:	fe843503          	ld	a0,-24(s0)
    80005b4c:	fffff097          	auipc	ra,0xfffff
    80005b50:	2be080e7          	jalr	702(ra) # 80004e0a <filestat>
}
    80005b54:	60e2                	ld	ra,24(sp)
    80005b56:	6442                	ld	s0,16(sp)
    80005b58:	6105                	addi	sp,sp,32
    80005b5a:	8082                	ret

0000000080005b5c <sys_link>:
{
    80005b5c:	7169                	addi	sp,sp,-304
    80005b5e:	f606                	sd	ra,296(sp)
    80005b60:	f222                	sd	s0,288(sp)
    80005b62:	ee26                	sd	s1,280(sp)
    80005b64:	ea4a                	sd	s2,272(sp)
    80005b66:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005b68:	08000613          	li	a2,128
    80005b6c:	ed040593          	addi	a1,s0,-304
    80005b70:	4501                	li	a0,0
    80005b72:	ffffd097          	auipc	ra,0xffffd
    80005b76:	73e080e7          	jalr	1854(ra) # 800032b0 <argstr>
    return -1;
    80005b7a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005b7c:	10054e63          	bltz	a0,80005c98 <sys_link+0x13c>
    80005b80:	08000613          	li	a2,128
    80005b84:	f5040593          	addi	a1,s0,-176
    80005b88:	4505                	li	a0,1
    80005b8a:	ffffd097          	auipc	ra,0xffffd
    80005b8e:	726080e7          	jalr	1830(ra) # 800032b0 <argstr>
    return -1;
    80005b92:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005b94:	10054263          	bltz	a0,80005c98 <sys_link+0x13c>
  begin_op();
    80005b98:	fffff097          	auipc	ra,0xfffff
    80005b9c:	cde080e7          	jalr	-802(ra) # 80004876 <begin_op>
  if((ip = namei(old)) == 0){
    80005ba0:	ed040513          	addi	a0,s0,-304
    80005ba4:	fffff097          	auipc	ra,0xfffff
    80005ba8:	ab6080e7          	jalr	-1354(ra) # 8000465a <namei>
    80005bac:	84aa                	mv	s1,a0
    80005bae:	c551                	beqz	a0,80005c3a <sys_link+0xde>
  ilock(ip);
    80005bb0:	ffffe097          	auipc	ra,0xffffe
    80005bb4:	304080e7          	jalr	772(ra) # 80003eb4 <ilock>
  if(ip->type == T_DIR){
    80005bb8:	04449703          	lh	a4,68(s1)
    80005bbc:	4785                	li	a5,1
    80005bbe:	08f70463          	beq	a4,a5,80005c46 <sys_link+0xea>
  ip->nlink++;
    80005bc2:	04a4d783          	lhu	a5,74(s1)
    80005bc6:	2785                	addiw	a5,a5,1
    80005bc8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005bcc:	8526                	mv	a0,s1
    80005bce:	ffffe097          	auipc	ra,0xffffe
    80005bd2:	21c080e7          	jalr	540(ra) # 80003dea <iupdate>
  iunlock(ip);
    80005bd6:	8526                	mv	a0,s1
    80005bd8:	ffffe097          	auipc	ra,0xffffe
    80005bdc:	39e080e7          	jalr	926(ra) # 80003f76 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005be0:	fd040593          	addi	a1,s0,-48
    80005be4:	f5040513          	addi	a0,s0,-176
    80005be8:	fffff097          	auipc	ra,0xfffff
    80005bec:	a90080e7          	jalr	-1392(ra) # 80004678 <nameiparent>
    80005bf0:	892a                	mv	s2,a0
    80005bf2:	c935                	beqz	a0,80005c66 <sys_link+0x10a>
  ilock(dp);
    80005bf4:	ffffe097          	auipc	ra,0xffffe
    80005bf8:	2c0080e7          	jalr	704(ra) # 80003eb4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005bfc:	00092703          	lw	a4,0(s2)
    80005c00:	409c                	lw	a5,0(s1)
    80005c02:	04f71d63          	bne	a4,a5,80005c5c <sys_link+0x100>
    80005c06:	40d0                	lw	a2,4(s1)
    80005c08:	fd040593          	addi	a1,s0,-48
    80005c0c:	854a                	mv	a0,s2
    80005c0e:	fffff097          	auipc	ra,0xfffff
    80005c12:	99a080e7          	jalr	-1638(ra) # 800045a8 <dirlink>
    80005c16:	04054363          	bltz	a0,80005c5c <sys_link+0x100>
  iunlockput(dp);
    80005c1a:	854a                	mv	a0,s2
    80005c1c:	ffffe097          	auipc	ra,0xffffe
    80005c20:	4fa080e7          	jalr	1274(ra) # 80004116 <iunlockput>
  iput(ip);
    80005c24:	8526                	mv	a0,s1
    80005c26:	ffffe097          	auipc	ra,0xffffe
    80005c2a:	448080e7          	jalr	1096(ra) # 8000406e <iput>
  end_op();
    80005c2e:	fffff097          	auipc	ra,0xfffff
    80005c32:	cc8080e7          	jalr	-824(ra) # 800048f6 <end_op>
  return 0;
    80005c36:	4781                	li	a5,0
    80005c38:	a085                	j	80005c98 <sys_link+0x13c>
    end_op();
    80005c3a:	fffff097          	auipc	ra,0xfffff
    80005c3e:	cbc080e7          	jalr	-836(ra) # 800048f6 <end_op>
    return -1;
    80005c42:	57fd                	li	a5,-1
    80005c44:	a891                	j	80005c98 <sys_link+0x13c>
    iunlockput(ip);
    80005c46:	8526                	mv	a0,s1
    80005c48:	ffffe097          	auipc	ra,0xffffe
    80005c4c:	4ce080e7          	jalr	1230(ra) # 80004116 <iunlockput>
    end_op();
    80005c50:	fffff097          	auipc	ra,0xfffff
    80005c54:	ca6080e7          	jalr	-858(ra) # 800048f6 <end_op>
    return -1;
    80005c58:	57fd                	li	a5,-1
    80005c5a:	a83d                	j	80005c98 <sys_link+0x13c>
    iunlockput(dp);
    80005c5c:	854a                	mv	a0,s2
    80005c5e:	ffffe097          	auipc	ra,0xffffe
    80005c62:	4b8080e7          	jalr	1208(ra) # 80004116 <iunlockput>
  ilock(ip);
    80005c66:	8526                	mv	a0,s1
    80005c68:	ffffe097          	auipc	ra,0xffffe
    80005c6c:	24c080e7          	jalr	588(ra) # 80003eb4 <ilock>
  ip->nlink--;
    80005c70:	04a4d783          	lhu	a5,74(s1)
    80005c74:	37fd                	addiw	a5,a5,-1
    80005c76:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005c7a:	8526                	mv	a0,s1
    80005c7c:	ffffe097          	auipc	ra,0xffffe
    80005c80:	16e080e7          	jalr	366(ra) # 80003dea <iupdate>
  iunlockput(ip);
    80005c84:	8526                	mv	a0,s1
    80005c86:	ffffe097          	auipc	ra,0xffffe
    80005c8a:	490080e7          	jalr	1168(ra) # 80004116 <iunlockput>
  end_op();
    80005c8e:	fffff097          	auipc	ra,0xfffff
    80005c92:	c68080e7          	jalr	-920(ra) # 800048f6 <end_op>
  return -1;
    80005c96:	57fd                	li	a5,-1
}
    80005c98:	853e                	mv	a0,a5
    80005c9a:	70b2                	ld	ra,296(sp)
    80005c9c:	7412                	ld	s0,288(sp)
    80005c9e:	64f2                	ld	s1,280(sp)
    80005ca0:	6952                	ld	s2,272(sp)
    80005ca2:	6155                	addi	sp,sp,304
    80005ca4:	8082                	ret

0000000080005ca6 <sys_unlink>:
{
    80005ca6:	7151                	addi	sp,sp,-240
    80005ca8:	f586                	sd	ra,232(sp)
    80005caa:	f1a2                	sd	s0,224(sp)
    80005cac:	eda6                	sd	s1,216(sp)
    80005cae:	e9ca                	sd	s2,208(sp)
    80005cb0:	e5ce                	sd	s3,200(sp)
    80005cb2:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005cb4:	08000613          	li	a2,128
    80005cb8:	f3040593          	addi	a1,s0,-208
    80005cbc:	4501                	li	a0,0
    80005cbe:	ffffd097          	auipc	ra,0xffffd
    80005cc2:	5f2080e7          	jalr	1522(ra) # 800032b0 <argstr>
    80005cc6:	18054163          	bltz	a0,80005e48 <sys_unlink+0x1a2>
  begin_op();
    80005cca:	fffff097          	auipc	ra,0xfffff
    80005cce:	bac080e7          	jalr	-1108(ra) # 80004876 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005cd2:	fb040593          	addi	a1,s0,-80
    80005cd6:	f3040513          	addi	a0,s0,-208
    80005cda:	fffff097          	auipc	ra,0xfffff
    80005cde:	99e080e7          	jalr	-1634(ra) # 80004678 <nameiparent>
    80005ce2:	84aa                	mv	s1,a0
    80005ce4:	c979                	beqz	a0,80005dba <sys_unlink+0x114>
  ilock(dp);
    80005ce6:	ffffe097          	auipc	ra,0xffffe
    80005cea:	1ce080e7          	jalr	462(ra) # 80003eb4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005cee:	00003597          	auipc	a1,0x3
    80005cf2:	a7258593          	addi	a1,a1,-1422 # 80008760 <syscalls+0x2b8>
    80005cf6:	fb040513          	addi	a0,s0,-80
    80005cfa:	ffffe097          	auipc	ra,0xffffe
    80005cfe:	684080e7          	jalr	1668(ra) # 8000437e <namecmp>
    80005d02:	14050a63          	beqz	a0,80005e56 <sys_unlink+0x1b0>
    80005d06:	00003597          	auipc	a1,0x3
    80005d0a:	a6258593          	addi	a1,a1,-1438 # 80008768 <syscalls+0x2c0>
    80005d0e:	fb040513          	addi	a0,s0,-80
    80005d12:	ffffe097          	auipc	ra,0xffffe
    80005d16:	66c080e7          	jalr	1644(ra) # 8000437e <namecmp>
    80005d1a:	12050e63          	beqz	a0,80005e56 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005d1e:	f2c40613          	addi	a2,s0,-212
    80005d22:	fb040593          	addi	a1,s0,-80
    80005d26:	8526                	mv	a0,s1
    80005d28:	ffffe097          	auipc	ra,0xffffe
    80005d2c:	670080e7          	jalr	1648(ra) # 80004398 <dirlookup>
    80005d30:	892a                	mv	s2,a0
    80005d32:	12050263          	beqz	a0,80005e56 <sys_unlink+0x1b0>
  ilock(ip);
    80005d36:	ffffe097          	auipc	ra,0xffffe
    80005d3a:	17e080e7          	jalr	382(ra) # 80003eb4 <ilock>
  if(ip->nlink < 1)
    80005d3e:	04a91783          	lh	a5,74(s2)
    80005d42:	08f05263          	blez	a5,80005dc6 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005d46:	04491703          	lh	a4,68(s2)
    80005d4a:	4785                	li	a5,1
    80005d4c:	08f70563          	beq	a4,a5,80005dd6 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005d50:	4641                	li	a2,16
    80005d52:	4581                	li	a1,0
    80005d54:	fc040513          	addi	a0,s0,-64
    80005d58:	ffffb097          	auipc	ra,0xffffb
    80005d5c:	19e080e7          	jalr	414(ra) # 80000ef6 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005d60:	4741                	li	a4,16
    80005d62:	f2c42683          	lw	a3,-212(s0)
    80005d66:	fc040613          	addi	a2,s0,-64
    80005d6a:	4581                	li	a1,0
    80005d6c:	8526                	mv	a0,s1
    80005d6e:	ffffe097          	auipc	ra,0xffffe
    80005d72:	4f2080e7          	jalr	1266(ra) # 80004260 <writei>
    80005d76:	47c1                	li	a5,16
    80005d78:	0af51563          	bne	a0,a5,80005e22 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005d7c:	04491703          	lh	a4,68(s2)
    80005d80:	4785                	li	a5,1
    80005d82:	0af70863          	beq	a4,a5,80005e32 <sys_unlink+0x18c>
  iunlockput(dp);
    80005d86:	8526                	mv	a0,s1
    80005d88:	ffffe097          	auipc	ra,0xffffe
    80005d8c:	38e080e7          	jalr	910(ra) # 80004116 <iunlockput>
  ip->nlink--;
    80005d90:	04a95783          	lhu	a5,74(s2)
    80005d94:	37fd                	addiw	a5,a5,-1
    80005d96:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005d9a:	854a                	mv	a0,s2
    80005d9c:	ffffe097          	auipc	ra,0xffffe
    80005da0:	04e080e7          	jalr	78(ra) # 80003dea <iupdate>
  iunlockput(ip);
    80005da4:	854a                	mv	a0,s2
    80005da6:	ffffe097          	auipc	ra,0xffffe
    80005daa:	370080e7          	jalr	880(ra) # 80004116 <iunlockput>
  end_op();
    80005dae:	fffff097          	auipc	ra,0xfffff
    80005db2:	b48080e7          	jalr	-1208(ra) # 800048f6 <end_op>
  return 0;
    80005db6:	4501                	li	a0,0
    80005db8:	a84d                	j	80005e6a <sys_unlink+0x1c4>
    end_op();
    80005dba:	fffff097          	auipc	ra,0xfffff
    80005dbe:	b3c080e7          	jalr	-1220(ra) # 800048f6 <end_op>
    return -1;
    80005dc2:	557d                	li	a0,-1
    80005dc4:	a05d                	j	80005e6a <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005dc6:	00003517          	auipc	a0,0x3
    80005dca:	9aa50513          	addi	a0,a0,-1622 # 80008770 <syscalls+0x2c8>
    80005dce:	ffffa097          	auipc	ra,0xffffa
    80005dd2:	770080e7          	jalr	1904(ra) # 8000053e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005dd6:	04c92703          	lw	a4,76(s2)
    80005dda:	02000793          	li	a5,32
    80005dde:	f6e7f9e3          	bgeu	a5,a4,80005d50 <sys_unlink+0xaa>
    80005de2:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005de6:	4741                	li	a4,16
    80005de8:	86ce                	mv	a3,s3
    80005dea:	f1840613          	addi	a2,s0,-232
    80005dee:	4581                	li	a1,0
    80005df0:	854a                	mv	a0,s2
    80005df2:	ffffe097          	auipc	ra,0xffffe
    80005df6:	376080e7          	jalr	886(ra) # 80004168 <readi>
    80005dfa:	47c1                	li	a5,16
    80005dfc:	00f51b63          	bne	a0,a5,80005e12 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005e00:	f1845783          	lhu	a5,-232(s0)
    80005e04:	e7a1                	bnez	a5,80005e4c <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005e06:	29c1                	addiw	s3,s3,16
    80005e08:	04c92783          	lw	a5,76(s2)
    80005e0c:	fcf9ede3          	bltu	s3,a5,80005de6 <sys_unlink+0x140>
    80005e10:	b781                	j	80005d50 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005e12:	00003517          	auipc	a0,0x3
    80005e16:	97650513          	addi	a0,a0,-1674 # 80008788 <syscalls+0x2e0>
    80005e1a:	ffffa097          	auipc	ra,0xffffa
    80005e1e:	724080e7          	jalr	1828(ra) # 8000053e <panic>
    panic("unlink: writei");
    80005e22:	00003517          	auipc	a0,0x3
    80005e26:	97e50513          	addi	a0,a0,-1666 # 800087a0 <syscalls+0x2f8>
    80005e2a:	ffffa097          	auipc	ra,0xffffa
    80005e2e:	714080e7          	jalr	1812(ra) # 8000053e <panic>
    dp->nlink--;
    80005e32:	04a4d783          	lhu	a5,74(s1)
    80005e36:	37fd                	addiw	a5,a5,-1
    80005e38:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005e3c:	8526                	mv	a0,s1
    80005e3e:	ffffe097          	auipc	ra,0xffffe
    80005e42:	fac080e7          	jalr	-84(ra) # 80003dea <iupdate>
    80005e46:	b781                	j	80005d86 <sys_unlink+0xe0>
    return -1;
    80005e48:	557d                	li	a0,-1
    80005e4a:	a005                	j	80005e6a <sys_unlink+0x1c4>
    iunlockput(ip);
    80005e4c:	854a                	mv	a0,s2
    80005e4e:	ffffe097          	auipc	ra,0xffffe
    80005e52:	2c8080e7          	jalr	712(ra) # 80004116 <iunlockput>
  iunlockput(dp);
    80005e56:	8526                	mv	a0,s1
    80005e58:	ffffe097          	auipc	ra,0xffffe
    80005e5c:	2be080e7          	jalr	702(ra) # 80004116 <iunlockput>
  end_op();
    80005e60:	fffff097          	auipc	ra,0xfffff
    80005e64:	a96080e7          	jalr	-1386(ra) # 800048f6 <end_op>
  return -1;
    80005e68:	557d                	li	a0,-1
}
    80005e6a:	70ae                	ld	ra,232(sp)
    80005e6c:	740e                	ld	s0,224(sp)
    80005e6e:	64ee                	ld	s1,216(sp)
    80005e70:	694e                	ld	s2,208(sp)
    80005e72:	69ae                	ld	s3,200(sp)
    80005e74:	616d                	addi	sp,sp,240
    80005e76:	8082                	ret

0000000080005e78 <sys_open>:

uint64
sys_open(void)
{
    80005e78:	7131                	addi	sp,sp,-192
    80005e7a:	fd06                	sd	ra,184(sp)
    80005e7c:	f922                	sd	s0,176(sp)
    80005e7e:	f526                	sd	s1,168(sp)
    80005e80:	f14a                	sd	s2,160(sp)
    80005e82:	ed4e                	sd	s3,152(sp)
    80005e84:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005e86:	f4c40593          	addi	a1,s0,-180
    80005e8a:	4505                	li	a0,1
    80005e8c:	ffffd097          	auipc	ra,0xffffd
    80005e90:	3e4080e7          	jalr	996(ra) # 80003270 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005e94:	08000613          	li	a2,128
    80005e98:	f5040593          	addi	a1,s0,-176
    80005e9c:	4501                	li	a0,0
    80005e9e:	ffffd097          	auipc	ra,0xffffd
    80005ea2:	412080e7          	jalr	1042(ra) # 800032b0 <argstr>
    80005ea6:	87aa                	mv	a5,a0
    return -1;
    80005ea8:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005eaa:	0a07c963          	bltz	a5,80005f5c <sys_open+0xe4>

  begin_op();
    80005eae:	fffff097          	auipc	ra,0xfffff
    80005eb2:	9c8080e7          	jalr	-1592(ra) # 80004876 <begin_op>

  if(omode & O_CREATE){
    80005eb6:	f4c42783          	lw	a5,-180(s0)
    80005eba:	2007f793          	andi	a5,a5,512
    80005ebe:	cfc5                	beqz	a5,80005f76 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005ec0:	4681                	li	a3,0
    80005ec2:	4601                	li	a2,0
    80005ec4:	4589                	li	a1,2
    80005ec6:	f5040513          	addi	a0,s0,-176
    80005eca:	00000097          	auipc	ra,0x0
    80005ece:	954080e7          	jalr	-1708(ra) # 8000581e <create>
    80005ed2:	84aa                	mv	s1,a0
    if(ip == 0){
    80005ed4:	c959                	beqz	a0,80005f6a <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005ed6:	04449703          	lh	a4,68(s1)
    80005eda:	478d                	li	a5,3
    80005edc:	00f71763          	bne	a4,a5,80005eea <sys_open+0x72>
    80005ee0:	0464d703          	lhu	a4,70(s1)
    80005ee4:	47a5                	li	a5,9
    80005ee6:	0ce7ed63          	bltu	a5,a4,80005fc0 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005eea:	fffff097          	auipc	ra,0xfffff
    80005eee:	d9c080e7          	jalr	-612(ra) # 80004c86 <filealloc>
    80005ef2:	89aa                	mv	s3,a0
    80005ef4:	10050363          	beqz	a0,80005ffa <sys_open+0x182>
    80005ef8:	00000097          	auipc	ra,0x0
    80005efc:	8e4080e7          	jalr	-1820(ra) # 800057dc <fdalloc>
    80005f00:	892a                	mv	s2,a0
    80005f02:	0e054763          	bltz	a0,80005ff0 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005f06:	04449703          	lh	a4,68(s1)
    80005f0a:	478d                	li	a5,3
    80005f0c:	0cf70563          	beq	a4,a5,80005fd6 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005f10:	4789                	li	a5,2
    80005f12:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005f16:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005f1a:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005f1e:	f4c42783          	lw	a5,-180(s0)
    80005f22:	0017c713          	xori	a4,a5,1
    80005f26:	8b05                	andi	a4,a4,1
    80005f28:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005f2c:	0037f713          	andi	a4,a5,3
    80005f30:	00e03733          	snez	a4,a4
    80005f34:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005f38:	4007f793          	andi	a5,a5,1024
    80005f3c:	c791                	beqz	a5,80005f48 <sys_open+0xd0>
    80005f3e:	04449703          	lh	a4,68(s1)
    80005f42:	4789                	li	a5,2
    80005f44:	0af70063          	beq	a4,a5,80005fe4 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005f48:	8526                	mv	a0,s1
    80005f4a:	ffffe097          	auipc	ra,0xffffe
    80005f4e:	02c080e7          	jalr	44(ra) # 80003f76 <iunlock>
  end_op();
    80005f52:	fffff097          	auipc	ra,0xfffff
    80005f56:	9a4080e7          	jalr	-1628(ra) # 800048f6 <end_op>

  return fd;
    80005f5a:	854a                	mv	a0,s2
}
    80005f5c:	70ea                	ld	ra,184(sp)
    80005f5e:	744a                	ld	s0,176(sp)
    80005f60:	74aa                	ld	s1,168(sp)
    80005f62:	790a                	ld	s2,160(sp)
    80005f64:	69ea                	ld	s3,152(sp)
    80005f66:	6129                	addi	sp,sp,192
    80005f68:	8082                	ret
      end_op();
    80005f6a:	fffff097          	auipc	ra,0xfffff
    80005f6e:	98c080e7          	jalr	-1652(ra) # 800048f6 <end_op>
      return -1;
    80005f72:	557d                	li	a0,-1
    80005f74:	b7e5                	j	80005f5c <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005f76:	f5040513          	addi	a0,s0,-176
    80005f7a:	ffffe097          	auipc	ra,0xffffe
    80005f7e:	6e0080e7          	jalr	1760(ra) # 8000465a <namei>
    80005f82:	84aa                	mv	s1,a0
    80005f84:	c905                	beqz	a0,80005fb4 <sys_open+0x13c>
    ilock(ip);
    80005f86:	ffffe097          	auipc	ra,0xffffe
    80005f8a:	f2e080e7          	jalr	-210(ra) # 80003eb4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005f8e:	04449703          	lh	a4,68(s1)
    80005f92:	4785                	li	a5,1
    80005f94:	f4f711e3          	bne	a4,a5,80005ed6 <sys_open+0x5e>
    80005f98:	f4c42783          	lw	a5,-180(s0)
    80005f9c:	d7b9                	beqz	a5,80005eea <sys_open+0x72>
      iunlockput(ip);
    80005f9e:	8526                	mv	a0,s1
    80005fa0:	ffffe097          	auipc	ra,0xffffe
    80005fa4:	176080e7          	jalr	374(ra) # 80004116 <iunlockput>
      end_op();
    80005fa8:	fffff097          	auipc	ra,0xfffff
    80005fac:	94e080e7          	jalr	-1714(ra) # 800048f6 <end_op>
      return -1;
    80005fb0:	557d                	li	a0,-1
    80005fb2:	b76d                	j	80005f5c <sys_open+0xe4>
      end_op();
    80005fb4:	fffff097          	auipc	ra,0xfffff
    80005fb8:	942080e7          	jalr	-1726(ra) # 800048f6 <end_op>
      return -1;
    80005fbc:	557d                	li	a0,-1
    80005fbe:	bf79                	j	80005f5c <sys_open+0xe4>
    iunlockput(ip);
    80005fc0:	8526                	mv	a0,s1
    80005fc2:	ffffe097          	auipc	ra,0xffffe
    80005fc6:	154080e7          	jalr	340(ra) # 80004116 <iunlockput>
    end_op();
    80005fca:	fffff097          	auipc	ra,0xfffff
    80005fce:	92c080e7          	jalr	-1748(ra) # 800048f6 <end_op>
    return -1;
    80005fd2:	557d                	li	a0,-1
    80005fd4:	b761                	j	80005f5c <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005fd6:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005fda:	04649783          	lh	a5,70(s1)
    80005fde:	02f99223          	sh	a5,36(s3)
    80005fe2:	bf25                	j	80005f1a <sys_open+0xa2>
    itrunc(ip);
    80005fe4:	8526                	mv	a0,s1
    80005fe6:	ffffe097          	auipc	ra,0xffffe
    80005fea:	fdc080e7          	jalr	-36(ra) # 80003fc2 <itrunc>
    80005fee:	bfa9                	j	80005f48 <sys_open+0xd0>
      fileclose(f);
    80005ff0:	854e                	mv	a0,s3
    80005ff2:	fffff097          	auipc	ra,0xfffff
    80005ff6:	d50080e7          	jalr	-688(ra) # 80004d42 <fileclose>
    iunlockput(ip);
    80005ffa:	8526                	mv	a0,s1
    80005ffc:	ffffe097          	auipc	ra,0xffffe
    80006000:	11a080e7          	jalr	282(ra) # 80004116 <iunlockput>
    end_op();
    80006004:	fffff097          	auipc	ra,0xfffff
    80006008:	8f2080e7          	jalr	-1806(ra) # 800048f6 <end_op>
    return -1;
    8000600c:	557d                	li	a0,-1
    8000600e:	b7b9                	j	80005f5c <sys_open+0xe4>

0000000080006010 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80006010:	7175                	addi	sp,sp,-144
    80006012:	e506                	sd	ra,136(sp)
    80006014:	e122                	sd	s0,128(sp)
    80006016:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80006018:	fffff097          	auipc	ra,0xfffff
    8000601c:	85e080e7          	jalr	-1954(ra) # 80004876 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80006020:	08000613          	li	a2,128
    80006024:	f7040593          	addi	a1,s0,-144
    80006028:	4501                	li	a0,0
    8000602a:	ffffd097          	auipc	ra,0xffffd
    8000602e:	286080e7          	jalr	646(ra) # 800032b0 <argstr>
    80006032:	02054963          	bltz	a0,80006064 <sys_mkdir+0x54>
    80006036:	4681                	li	a3,0
    80006038:	4601                	li	a2,0
    8000603a:	4585                	li	a1,1
    8000603c:	f7040513          	addi	a0,s0,-144
    80006040:	fffff097          	auipc	ra,0xfffff
    80006044:	7de080e7          	jalr	2014(ra) # 8000581e <create>
    80006048:	cd11                	beqz	a0,80006064 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000604a:	ffffe097          	auipc	ra,0xffffe
    8000604e:	0cc080e7          	jalr	204(ra) # 80004116 <iunlockput>
  end_op();
    80006052:	fffff097          	auipc	ra,0xfffff
    80006056:	8a4080e7          	jalr	-1884(ra) # 800048f6 <end_op>
  return 0;
    8000605a:	4501                	li	a0,0
}
    8000605c:	60aa                	ld	ra,136(sp)
    8000605e:	640a                	ld	s0,128(sp)
    80006060:	6149                	addi	sp,sp,144
    80006062:	8082                	ret
    end_op();
    80006064:	fffff097          	auipc	ra,0xfffff
    80006068:	892080e7          	jalr	-1902(ra) # 800048f6 <end_op>
    return -1;
    8000606c:	557d                	li	a0,-1
    8000606e:	b7fd                	j	8000605c <sys_mkdir+0x4c>

0000000080006070 <sys_mknod>:

uint64
sys_mknod(void)
{
    80006070:	7135                	addi	sp,sp,-160
    80006072:	ed06                	sd	ra,152(sp)
    80006074:	e922                	sd	s0,144(sp)
    80006076:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80006078:	ffffe097          	auipc	ra,0xffffe
    8000607c:	7fe080e7          	jalr	2046(ra) # 80004876 <begin_op>
  argint(1, &major);
    80006080:	f6c40593          	addi	a1,s0,-148
    80006084:	4505                	li	a0,1
    80006086:	ffffd097          	auipc	ra,0xffffd
    8000608a:	1ea080e7          	jalr	490(ra) # 80003270 <argint>
  argint(2, &minor);
    8000608e:	f6840593          	addi	a1,s0,-152
    80006092:	4509                	li	a0,2
    80006094:	ffffd097          	auipc	ra,0xffffd
    80006098:	1dc080e7          	jalr	476(ra) # 80003270 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000609c:	08000613          	li	a2,128
    800060a0:	f7040593          	addi	a1,s0,-144
    800060a4:	4501                	li	a0,0
    800060a6:	ffffd097          	auipc	ra,0xffffd
    800060aa:	20a080e7          	jalr	522(ra) # 800032b0 <argstr>
    800060ae:	02054b63          	bltz	a0,800060e4 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800060b2:	f6841683          	lh	a3,-152(s0)
    800060b6:	f6c41603          	lh	a2,-148(s0)
    800060ba:	458d                	li	a1,3
    800060bc:	f7040513          	addi	a0,s0,-144
    800060c0:	fffff097          	auipc	ra,0xfffff
    800060c4:	75e080e7          	jalr	1886(ra) # 8000581e <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800060c8:	cd11                	beqz	a0,800060e4 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800060ca:	ffffe097          	auipc	ra,0xffffe
    800060ce:	04c080e7          	jalr	76(ra) # 80004116 <iunlockput>
  end_op();
    800060d2:	fffff097          	auipc	ra,0xfffff
    800060d6:	824080e7          	jalr	-2012(ra) # 800048f6 <end_op>
  return 0;
    800060da:	4501                	li	a0,0
}
    800060dc:	60ea                	ld	ra,152(sp)
    800060de:	644a                	ld	s0,144(sp)
    800060e0:	610d                	addi	sp,sp,160
    800060e2:	8082                	ret
    end_op();
    800060e4:	fffff097          	auipc	ra,0xfffff
    800060e8:	812080e7          	jalr	-2030(ra) # 800048f6 <end_op>
    return -1;
    800060ec:	557d                	li	a0,-1
    800060ee:	b7fd                	j	800060dc <sys_mknod+0x6c>

00000000800060f0 <sys_chdir>:

uint64
sys_chdir(void)
{
    800060f0:	7135                	addi	sp,sp,-160
    800060f2:	ed06                	sd	ra,152(sp)
    800060f4:	e922                	sd	s0,144(sp)
    800060f6:	e526                	sd	s1,136(sp)
    800060f8:	e14a                	sd	s2,128(sp)
    800060fa:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800060fc:	ffffc097          	auipc	ra,0xffffc
    80006100:	b12080e7          	jalr	-1262(ra) # 80001c0e <myproc>
    80006104:	892a                	mv	s2,a0
  
  begin_op();
    80006106:	ffffe097          	auipc	ra,0xffffe
    8000610a:	770080e7          	jalr	1904(ra) # 80004876 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000610e:	08000613          	li	a2,128
    80006112:	f6040593          	addi	a1,s0,-160
    80006116:	4501                	li	a0,0
    80006118:	ffffd097          	auipc	ra,0xffffd
    8000611c:	198080e7          	jalr	408(ra) # 800032b0 <argstr>
    80006120:	04054b63          	bltz	a0,80006176 <sys_chdir+0x86>
    80006124:	f6040513          	addi	a0,s0,-160
    80006128:	ffffe097          	auipc	ra,0xffffe
    8000612c:	532080e7          	jalr	1330(ra) # 8000465a <namei>
    80006130:	84aa                	mv	s1,a0
    80006132:	c131                	beqz	a0,80006176 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80006134:	ffffe097          	auipc	ra,0xffffe
    80006138:	d80080e7          	jalr	-640(ra) # 80003eb4 <ilock>
  if(ip->type != T_DIR){
    8000613c:	04449703          	lh	a4,68(s1)
    80006140:	4785                	li	a5,1
    80006142:	04f71063          	bne	a4,a5,80006182 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80006146:	8526                	mv	a0,s1
    80006148:	ffffe097          	auipc	ra,0xffffe
    8000614c:	e2e080e7          	jalr	-466(ra) # 80003f76 <iunlock>
  iput(p->cwd);
    80006150:	15093503          	ld	a0,336(s2)
    80006154:	ffffe097          	auipc	ra,0xffffe
    80006158:	f1a080e7          	jalr	-230(ra) # 8000406e <iput>
  end_op();
    8000615c:	ffffe097          	auipc	ra,0xffffe
    80006160:	79a080e7          	jalr	1946(ra) # 800048f6 <end_op>
  p->cwd = ip;
    80006164:	14993823          	sd	s1,336(s2)
  return 0;
    80006168:	4501                	li	a0,0
}
    8000616a:	60ea                	ld	ra,152(sp)
    8000616c:	644a                	ld	s0,144(sp)
    8000616e:	64aa                	ld	s1,136(sp)
    80006170:	690a                	ld	s2,128(sp)
    80006172:	610d                	addi	sp,sp,160
    80006174:	8082                	ret
    end_op();
    80006176:	ffffe097          	auipc	ra,0xffffe
    8000617a:	780080e7          	jalr	1920(ra) # 800048f6 <end_op>
    return -1;
    8000617e:	557d                	li	a0,-1
    80006180:	b7ed                	j	8000616a <sys_chdir+0x7a>
    iunlockput(ip);
    80006182:	8526                	mv	a0,s1
    80006184:	ffffe097          	auipc	ra,0xffffe
    80006188:	f92080e7          	jalr	-110(ra) # 80004116 <iunlockput>
    end_op();
    8000618c:	ffffe097          	auipc	ra,0xffffe
    80006190:	76a080e7          	jalr	1898(ra) # 800048f6 <end_op>
    return -1;
    80006194:	557d                	li	a0,-1
    80006196:	bfd1                	j	8000616a <sys_chdir+0x7a>

0000000080006198 <sys_exec>:

uint64
sys_exec(void)
{
    80006198:	7145                	addi	sp,sp,-464
    8000619a:	e786                	sd	ra,456(sp)
    8000619c:	e3a2                	sd	s0,448(sp)
    8000619e:	ff26                	sd	s1,440(sp)
    800061a0:	fb4a                	sd	s2,432(sp)
    800061a2:	f74e                	sd	s3,424(sp)
    800061a4:	f352                	sd	s4,416(sp)
    800061a6:	ef56                	sd	s5,408(sp)
    800061a8:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800061aa:	e3840593          	addi	a1,s0,-456
    800061ae:	4505                	li	a0,1
    800061b0:	ffffd097          	auipc	ra,0xffffd
    800061b4:	0e0080e7          	jalr	224(ra) # 80003290 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800061b8:	08000613          	li	a2,128
    800061bc:	f4040593          	addi	a1,s0,-192
    800061c0:	4501                	li	a0,0
    800061c2:	ffffd097          	auipc	ra,0xffffd
    800061c6:	0ee080e7          	jalr	238(ra) # 800032b0 <argstr>
    800061ca:	87aa                	mv	a5,a0
    return -1;
    800061cc:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800061ce:	0c07c263          	bltz	a5,80006292 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    800061d2:	10000613          	li	a2,256
    800061d6:	4581                	li	a1,0
    800061d8:	e4040513          	addi	a0,s0,-448
    800061dc:	ffffb097          	auipc	ra,0xffffb
    800061e0:	d1a080e7          	jalr	-742(ra) # 80000ef6 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800061e4:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800061e8:	89a6                	mv	s3,s1
    800061ea:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800061ec:	02000a13          	li	s4,32
    800061f0:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800061f4:	00391793          	slli	a5,s2,0x3
    800061f8:	e3040593          	addi	a1,s0,-464
    800061fc:	e3843503          	ld	a0,-456(s0)
    80006200:	953e                	add	a0,a0,a5
    80006202:	ffffd097          	auipc	ra,0xffffd
    80006206:	fd0080e7          	jalr	-48(ra) # 800031d2 <fetchaddr>
    8000620a:	02054a63          	bltz	a0,8000623e <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    8000620e:	e3043783          	ld	a5,-464(s0)
    80006212:	c3b9                	beqz	a5,80006258 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80006214:	ffffb097          	auipc	ra,0xffffb
    80006218:	aea080e7          	jalr	-1302(ra) # 80000cfe <kalloc>
    8000621c:	85aa                	mv	a1,a0
    8000621e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80006222:	cd11                	beqz	a0,8000623e <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006224:	6605                	lui	a2,0x1
    80006226:	e3043503          	ld	a0,-464(s0)
    8000622a:	ffffd097          	auipc	ra,0xffffd
    8000622e:	ffa080e7          	jalr	-6(ra) # 80003224 <fetchstr>
    80006232:	00054663          	bltz	a0,8000623e <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80006236:	0905                	addi	s2,s2,1
    80006238:	09a1                	addi	s3,s3,8
    8000623a:	fb491be3          	bne	s2,s4,800061f0 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000623e:	10048913          	addi	s2,s1,256
    80006242:	6088                	ld	a0,0(s1)
    80006244:	c531                	beqz	a0,80006290 <sys_exec+0xf8>
    kfree(argv[i]);
    80006246:	ffffb097          	auipc	ra,0xffffb
    8000624a:	930080e7          	jalr	-1744(ra) # 80000b76 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000624e:	04a1                	addi	s1,s1,8
    80006250:	ff2499e3          	bne	s1,s2,80006242 <sys_exec+0xaa>
  return -1;
    80006254:	557d                	li	a0,-1
    80006256:	a835                	j	80006292 <sys_exec+0xfa>
      argv[i] = 0;
    80006258:	0a8e                	slli	s5,s5,0x3
    8000625a:	fc040793          	addi	a5,s0,-64
    8000625e:	9abe                	add	s5,s5,a5
    80006260:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80006264:	e4040593          	addi	a1,s0,-448
    80006268:	f4040513          	addi	a0,s0,-192
    8000626c:	fffff097          	auipc	ra,0xfffff
    80006270:	150080e7          	jalr	336(ra) # 800053bc <exec>
    80006274:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006276:	10048993          	addi	s3,s1,256
    8000627a:	6088                	ld	a0,0(s1)
    8000627c:	c901                	beqz	a0,8000628c <sys_exec+0xf4>
    kfree(argv[i]);
    8000627e:	ffffb097          	auipc	ra,0xffffb
    80006282:	8f8080e7          	jalr	-1800(ra) # 80000b76 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006286:	04a1                	addi	s1,s1,8
    80006288:	ff3499e3          	bne	s1,s3,8000627a <sys_exec+0xe2>
  return ret;
    8000628c:	854a                	mv	a0,s2
    8000628e:	a011                	j	80006292 <sys_exec+0xfa>
  return -1;
    80006290:	557d                	li	a0,-1
}
    80006292:	60be                	ld	ra,456(sp)
    80006294:	641e                	ld	s0,448(sp)
    80006296:	74fa                	ld	s1,440(sp)
    80006298:	795a                	ld	s2,432(sp)
    8000629a:	79ba                	ld	s3,424(sp)
    8000629c:	7a1a                	ld	s4,416(sp)
    8000629e:	6afa                	ld	s5,408(sp)
    800062a0:	6179                	addi	sp,sp,464
    800062a2:	8082                	ret

00000000800062a4 <sys_pipe>:

uint64
sys_pipe(void)
{
    800062a4:	7139                	addi	sp,sp,-64
    800062a6:	fc06                	sd	ra,56(sp)
    800062a8:	f822                	sd	s0,48(sp)
    800062aa:	f426                	sd	s1,40(sp)
    800062ac:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800062ae:	ffffc097          	auipc	ra,0xffffc
    800062b2:	960080e7          	jalr	-1696(ra) # 80001c0e <myproc>
    800062b6:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800062b8:	fd840593          	addi	a1,s0,-40
    800062bc:	4501                	li	a0,0
    800062be:	ffffd097          	auipc	ra,0xffffd
    800062c2:	fd2080e7          	jalr	-46(ra) # 80003290 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800062c6:	fc840593          	addi	a1,s0,-56
    800062ca:	fd040513          	addi	a0,s0,-48
    800062ce:	fffff097          	auipc	ra,0xfffff
    800062d2:	da4080e7          	jalr	-604(ra) # 80005072 <pipealloc>
    return -1;
    800062d6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800062d8:	0c054463          	bltz	a0,800063a0 <sys_pipe+0xfc>
  fd0 = -1;
    800062dc:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800062e0:	fd043503          	ld	a0,-48(s0)
    800062e4:	fffff097          	auipc	ra,0xfffff
    800062e8:	4f8080e7          	jalr	1272(ra) # 800057dc <fdalloc>
    800062ec:	fca42223          	sw	a0,-60(s0)
    800062f0:	08054b63          	bltz	a0,80006386 <sys_pipe+0xe2>
    800062f4:	fc843503          	ld	a0,-56(s0)
    800062f8:	fffff097          	auipc	ra,0xfffff
    800062fc:	4e4080e7          	jalr	1252(ra) # 800057dc <fdalloc>
    80006300:	fca42023          	sw	a0,-64(s0)
    80006304:	06054863          	bltz	a0,80006374 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006308:	4691                	li	a3,4
    8000630a:	fc440613          	addi	a2,s0,-60
    8000630e:	fd843583          	ld	a1,-40(s0)
    80006312:	68a8                	ld	a0,80(s1)
    80006314:	ffffb097          	auipc	ra,0xffffb
    80006318:	57e080e7          	jalr	1406(ra) # 80001892 <copyout>
    8000631c:	02054063          	bltz	a0,8000633c <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006320:	4691                	li	a3,4
    80006322:	fc040613          	addi	a2,s0,-64
    80006326:	fd843583          	ld	a1,-40(s0)
    8000632a:	0591                	addi	a1,a1,4
    8000632c:	68a8                	ld	a0,80(s1)
    8000632e:	ffffb097          	auipc	ra,0xffffb
    80006332:	564080e7          	jalr	1380(ra) # 80001892 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006336:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006338:	06055463          	bgez	a0,800063a0 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    8000633c:	fc442783          	lw	a5,-60(s0)
    80006340:	07e9                	addi	a5,a5,26
    80006342:	078e                	slli	a5,a5,0x3
    80006344:	97a6                	add	a5,a5,s1
    80006346:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000634a:	fc042503          	lw	a0,-64(s0)
    8000634e:	0569                	addi	a0,a0,26
    80006350:	050e                	slli	a0,a0,0x3
    80006352:	94aa                	add	s1,s1,a0
    80006354:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80006358:	fd043503          	ld	a0,-48(s0)
    8000635c:	fffff097          	auipc	ra,0xfffff
    80006360:	9e6080e7          	jalr	-1562(ra) # 80004d42 <fileclose>
    fileclose(wf);
    80006364:	fc843503          	ld	a0,-56(s0)
    80006368:	fffff097          	auipc	ra,0xfffff
    8000636c:	9da080e7          	jalr	-1574(ra) # 80004d42 <fileclose>
    return -1;
    80006370:	57fd                	li	a5,-1
    80006372:	a03d                	j	800063a0 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80006374:	fc442783          	lw	a5,-60(s0)
    80006378:	0007c763          	bltz	a5,80006386 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000637c:	07e9                	addi	a5,a5,26
    8000637e:	078e                	slli	a5,a5,0x3
    80006380:	94be                	add	s1,s1,a5
    80006382:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80006386:	fd043503          	ld	a0,-48(s0)
    8000638a:	fffff097          	auipc	ra,0xfffff
    8000638e:	9b8080e7          	jalr	-1608(ra) # 80004d42 <fileclose>
    fileclose(wf);
    80006392:	fc843503          	ld	a0,-56(s0)
    80006396:	fffff097          	auipc	ra,0xfffff
    8000639a:	9ac080e7          	jalr	-1620(ra) # 80004d42 <fileclose>
    return -1;
    8000639e:	57fd                	li	a5,-1
}
    800063a0:	853e                	mv	a0,a5
    800063a2:	70e2                	ld	ra,56(sp)
    800063a4:	7442                	ld	s0,48(sp)
    800063a6:	74a2                	ld	s1,40(sp)
    800063a8:	6121                	addi	sp,sp,64
    800063aa:	8082                	ret
    800063ac:	0000                	unimp
	...

00000000800063b0 <kernelvec>:
    800063b0:	7111                	addi	sp,sp,-256
    800063b2:	e006                	sd	ra,0(sp)
    800063b4:	e40a                	sd	sp,8(sp)
    800063b6:	e80e                	sd	gp,16(sp)
    800063b8:	ec12                	sd	tp,24(sp)
    800063ba:	f016                	sd	t0,32(sp)
    800063bc:	f41a                	sd	t1,40(sp)
    800063be:	f81e                	sd	t2,48(sp)
    800063c0:	fc22                	sd	s0,56(sp)
    800063c2:	e0a6                	sd	s1,64(sp)
    800063c4:	e4aa                	sd	a0,72(sp)
    800063c6:	e8ae                	sd	a1,80(sp)
    800063c8:	ecb2                	sd	a2,88(sp)
    800063ca:	f0b6                	sd	a3,96(sp)
    800063cc:	f4ba                	sd	a4,104(sp)
    800063ce:	f8be                	sd	a5,112(sp)
    800063d0:	fcc2                	sd	a6,120(sp)
    800063d2:	e146                	sd	a7,128(sp)
    800063d4:	e54a                	sd	s2,136(sp)
    800063d6:	e94e                	sd	s3,144(sp)
    800063d8:	ed52                	sd	s4,152(sp)
    800063da:	f156                	sd	s5,160(sp)
    800063dc:	f55a                	sd	s6,168(sp)
    800063de:	f95e                	sd	s7,176(sp)
    800063e0:	fd62                	sd	s8,184(sp)
    800063e2:	e1e6                	sd	s9,192(sp)
    800063e4:	e5ea                	sd	s10,200(sp)
    800063e6:	e9ee                	sd	s11,208(sp)
    800063e8:	edf2                	sd	t3,216(sp)
    800063ea:	f1f6                	sd	t4,224(sp)
    800063ec:	f5fa                	sd	t5,232(sp)
    800063ee:	f9fe                	sd	t6,240(sp)
    800063f0:	caffc0ef          	jal	ra,8000309e <kerneltrap>
    800063f4:	6082                	ld	ra,0(sp)
    800063f6:	6122                	ld	sp,8(sp)
    800063f8:	61c2                	ld	gp,16(sp)
    800063fa:	7282                	ld	t0,32(sp)
    800063fc:	7322                	ld	t1,40(sp)
    800063fe:	73c2                	ld	t2,48(sp)
    80006400:	7462                	ld	s0,56(sp)
    80006402:	6486                	ld	s1,64(sp)
    80006404:	6526                	ld	a0,72(sp)
    80006406:	65c6                	ld	a1,80(sp)
    80006408:	6666                	ld	a2,88(sp)
    8000640a:	7686                	ld	a3,96(sp)
    8000640c:	7726                	ld	a4,104(sp)
    8000640e:	77c6                	ld	a5,112(sp)
    80006410:	7866                	ld	a6,120(sp)
    80006412:	688a                	ld	a7,128(sp)
    80006414:	692a                	ld	s2,136(sp)
    80006416:	69ca                	ld	s3,144(sp)
    80006418:	6a6a                	ld	s4,152(sp)
    8000641a:	7a8a                	ld	s5,160(sp)
    8000641c:	7b2a                	ld	s6,168(sp)
    8000641e:	7bca                	ld	s7,176(sp)
    80006420:	7c6a                	ld	s8,184(sp)
    80006422:	6c8e                	ld	s9,192(sp)
    80006424:	6d2e                	ld	s10,200(sp)
    80006426:	6dce                	ld	s11,208(sp)
    80006428:	6e6e                	ld	t3,216(sp)
    8000642a:	7e8e                	ld	t4,224(sp)
    8000642c:	7f2e                	ld	t5,232(sp)
    8000642e:	7fce                	ld	t6,240(sp)
    80006430:	6111                	addi	sp,sp,256
    80006432:	10200073          	sret
    80006436:	00000013          	nop
    8000643a:	00000013          	nop
    8000643e:	0001                	nop

0000000080006440 <timervec>:
    80006440:	34051573          	csrrw	a0,mscratch,a0
    80006444:	e10c                	sd	a1,0(a0)
    80006446:	e510                	sd	a2,8(a0)
    80006448:	e914                	sd	a3,16(a0)
    8000644a:	6d0c                	ld	a1,24(a0)
    8000644c:	7110                	ld	a2,32(a0)
    8000644e:	6194                	ld	a3,0(a1)
    80006450:	96b2                	add	a3,a3,a2
    80006452:	e194                	sd	a3,0(a1)
    80006454:	4589                	li	a1,2
    80006456:	14459073          	csrw	sip,a1
    8000645a:	6914                	ld	a3,16(a0)
    8000645c:	6510                	ld	a2,8(a0)
    8000645e:	610c                	ld	a1,0(a0)
    80006460:	34051573          	csrrw	a0,mscratch,a0
    80006464:	30200073          	mret
	...

000000008000646a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000646a:	1141                	addi	sp,sp,-16
    8000646c:	e422                	sd	s0,8(sp)
    8000646e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006470:	0c0007b7          	lui	a5,0xc000
    80006474:	4705                	li	a4,1
    80006476:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006478:	c3d8                	sw	a4,4(a5)
}
    8000647a:	6422                	ld	s0,8(sp)
    8000647c:	0141                	addi	sp,sp,16
    8000647e:	8082                	ret

0000000080006480 <plicinithart>:

void
plicinithart(void)
{
    80006480:	1141                	addi	sp,sp,-16
    80006482:	e406                	sd	ra,8(sp)
    80006484:	e022                	sd	s0,0(sp)
    80006486:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006488:	ffffb097          	auipc	ra,0xffffb
    8000648c:	75a080e7          	jalr	1882(ra) # 80001be2 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006490:	0085171b          	slliw	a4,a0,0x8
    80006494:	0c0027b7          	lui	a5,0xc002
    80006498:	97ba                	add	a5,a5,a4
    8000649a:	40200713          	li	a4,1026
    8000649e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800064a2:	00d5151b          	slliw	a0,a0,0xd
    800064a6:	0c2017b7          	lui	a5,0xc201
    800064aa:	953e                	add	a0,a0,a5
    800064ac:	00052023          	sw	zero,0(a0)
}
    800064b0:	60a2                	ld	ra,8(sp)
    800064b2:	6402                	ld	s0,0(sp)
    800064b4:	0141                	addi	sp,sp,16
    800064b6:	8082                	ret

00000000800064b8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800064b8:	1141                	addi	sp,sp,-16
    800064ba:	e406                	sd	ra,8(sp)
    800064bc:	e022                	sd	s0,0(sp)
    800064be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800064c0:	ffffb097          	auipc	ra,0xffffb
    800064c4:	722080e7          	jalr	1826(ra) # 80001be2 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800064c8:	00d5179b          	slliw	a5,a0,0xd
    800064cc:	0c201537          	lui	a0,0xc201
    800064d0:	953e                	add	a0,a0,a5
  return irq;
}
    800064d2:	4148                	lw	a0,4(a0)
    800064d4:	60a2                	ld	ra,8(sp)
    800064d6:	6402                	ld	s0,0(sp)
    800064d8:	0141                	addi	sp,sp,16
    800064da:	8082                	ret

00000000800064dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800064dc:	1101                	addi	sp,sp,-32
    800064de:	ec06                	sd	ra,24(sp)
    800064e0:	e822                	sd	s0,16(sp)
    800064e2:	e426                	sd	s1,8(sp)
    800064e4:	1000                	addi	s0,sp,32
    800064e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800064e8:	ffffb097          	auipc	ra,0xffffb
    800064ec:	6fa080e7          	jalr	1786(ra) # 80001be2 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800064f0:	00d5151b          	slliw	a0,a0,0xd
    800064f4:	0c2017b7          	lui	a5,0xc201
    800064f8:	97aa                	add	a5,a5,a0
    800064fa:	c3c4                	sw	s1,4(a5)
}
    800064fc:	60e2                	ld	ra,24(sp)
    800064fe:	6442                	ld	s0,16(sp)
    80006500:	64a2                	ld	s1,8(sp)
    80006502:	6105                	addi	sp,sp,32
    80006504:	8082                	ret

0000000080006506 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006506:	1141                	addi	sp,sp,-16
    80006508:	e406                	sd	ra,8(sp)
    8000650a:	e022                	sd	s0,0(sp)
    8000650c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000650e:	479d                	li	a5,7
    80006510:	04a7cc63          	blt	a5,a0,80006568 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006514:	0023c797          	auipc	a5,0x23c
    80006518:	17478793          	addi	a5,a5,372 # 80242688 <disk>
    8000651c:	97aa                	add	a5,a5,a0
    8000651e:	0187c783          	lbu	a5,24(a5)
    80006522:	ebb9                	bnez	a5,80006578 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006524:	00451613          	slli	a2,a0,0x4
    80006528:	0023c797          	auipc	a5,0x23c
    8000652c:	16078793          	addi	a5,a5,352 # 80242688 <disk>
    80006530:	6394                	ld	a3,0(a5)
    80006532:	96b2                	add	a3,a3,a2
    80006534:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80006538:	6398                	ld	a4,0(a5)
    8000653a:	9732                	add	a4,a4,a2
    8000653c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006540:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006544:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006548:	953e                	add	a0,a0,a5
    8000654a:	4785                	li	a5,1
    8000654c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80006550:	0023c517          	auipc	a0,0x23c
    80006554:	15050513          	addi	a0,a0,336 # 802426a0 <disk+0x18>
    80006558:	ffffc097          	auipc	ra,0xffffc
    8000655c:	fee080e7          	jalr	-18(ra) # 80002546 <wakeup>
}
    80006560:	60a2                	ld	ra,8(sp)
    80006562:	6402                	ld	s0,0(sp)
    80006564:	0141                	addi	sp,sp,16
    80006566:	8082                	ret
    panic("free_desc 1");
    80006568:	00002517          	auipc	a0,0x2
    8000656c:	24850513          	addi	a0,a0,584 # 800087b0 <syscalls+0x308>
    80006570:	ffffa097          	auipc	ra,0xffffa
    80006574:	fce080e7          	jalr	-50(ra) # 8000053e <panic>
    panic("free_desc 2");
    80006578:	00002517          	auipc	a0,0x2
    8000657c:	24850513          	addi	a0,a0,584 # 800087c0 <syscalls+0x318>
    80006580:	ffffa097          	auipc	ra,0xffffa
    80006584:	fbe080e7          	jalr	-66(ra) # 8000053e <panic>

0000000080006588 <virtio_disk_init>:
{
    80006588:	1101                	addi	sp,sp,-32
    8000658a:	ec06                	sd	ra,24(sp)
    8000658c:	e822                	sd	s0,16(sp)
    8000658e:	e426                	sd	s1,8(sp)
    80006590:	e04a                	sd	s2,0(sp)
    80006592:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006594:	00002597          	auipc	a1,0x2
    80006598:	23c58593          	addi	a1,a1,572 # 800087d0 <syscalls+0x328>
    8000659c:	0023c517          	auipc	a0,0x23c
    800065a0:	21450513          	addi	a0,a0,532 # 802427b0 <disk+0x128>
    800065a4:	ffffa097          	auipc	ra,0xffffa
    800065a8:	7c6080e7          	jalr	1990(ra) # 80000d6a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800065ac:	100017b7          	lui	a5,0x10001
    800065b0:	4398                	lw	a4,0(a5)
    800065b2:	2701                	sext.w	a4,a4
    800065b4:	747277b7          	lui	a5,0x74727
    800065b8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800065bc:	14f71c63          	bne	a4,a5,80006714 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800065c0:	100017b7          	lui	a5,0x10001
    800065c4:	43dc                	lw	a5,4(a5)
    800065c6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800065c8:	4709                	li	a4,2
    800065ca:	14e79563          	bne	a5,a4,80006714 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800065ce:	100017b7          	lui	a5,0x10001
    800065d2:	479c                	lw	a5,8(a5)
    800065d4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800065d6:	12e79f63          	bne	a5,a4,80006714 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800065da:	100017b7          	lui	a5,0x10001
    800065de:	47d8                	lw	a4,12(a5)
    800065e0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800065e2:	554d47b7          	lui	a5,0x554d4
    800065e6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800065ea:	12f71563          	bne	a4,a5,80006714 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    800065ee:	100017b7          	lui	a5,0x10001
    800065f2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800065f6:	4705                	li	a4,1
    800065f8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800065fa:	470d                	li	a4,3
    800065fc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800065fe:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006600:	c7ffe737          	lui	a4,0xc7ffe
    80006604:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47dbbf97>
    80006608:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000660a:	2701                	sext.w	a4,a4
    8000660c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000660e:	472d                	li	a4,11
    80006610:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80006612:	5bbc                	lw	a5,112(a5)
    80006614:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006618:	8ba1                	andi	a5,a5,8
    8000661a:	10078563          	beqz	a5,80006724 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000661e:	100017b7          	lui	a5,0x10001
    80006622:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006626:	43fc                	lw	a5,68(a5)
    80006628:	2781                	sext.w	a5,a5
    8000662a:	10079563          	bnez	a5,80006734 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000662e:	100017b7          	lui	a5,0x10001
    80006632:	5bdc                	lw	a5,52(a5)
    80006634:	2781                	sext.w	a5,a5
  if(max == 0)
    80006636:	10078763          	beqz	a5,80006744 <virtio_disk_init+0x1bc>
  if(max < NUM)
    8000663a:	471d                	li	a4,7
    8000663c:	10f77c63          	bgeu	a4,a5,80006754 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    80006640:	ffffa097          	auipc	ra,0xffffa
    80006644:	6be080e7          	jalr	1726(ra) # 80000cfe <kalloc>
    80006648:	0023c497          	auipc	s1,0x23c
    8000664c:	04048493          	addi	s1,s1,64 # 80242688 <disk>
    80006650:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006652:	ffffa097          	auipc	ra,0xffffa
    80006656:	6ac080e7          	jalr	1708(ra) # 80000cfe <kalloc>
    8000665a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000665c:	ffffa097          	auipc	ra,0xffffa
    80006660:	6a2080e7          	jalr	1698(ra) # 80000cfe <kalloc>
    80006664:	87aa                	mv	a5,a0
    80006666:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006668:	6088                	ld	a0,0(s1)
    8000666a:	cd6d                	beqz	a0,80006764 <virtio_disk_init+0x1dc>
    8000666c:	0023c717          	auipc	a4,0x23c
    80006670:	02473703          	ld	a4,36(a4) # 80242690 <disk+0x8>
    80006674:	cb65                	beqz	a4,80006764 <virtio_disk_init+0x1dc>
    80006676:	c7fd                	beqz	a5,80006764 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    80006678:	6605                	lui	a2,0x1
    8000667a:	4581                	li	a1,0
    8000667c:	ffffb097          	auipc	ra,0xffffb
    80006680:	87a080e7          	jalr	-1926(ra) # 80000ef6 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006684:	0023c497          	auipc	s1,0x23c
    80006688:	00448493          	addi	s1,s1,4 # 80242688 <disk>
    8000668c:	6605                	lui	a2,0x1
    8000668e:	4581                	li	a1,0
    80006690:	6488                	ld	a0,8(s1)
    80006692:	ffffb097          	auipc	ra,0xffffb
    80006696:	864080e7          	jalr	-1948(ra) # 80000ef6 <memset>
  memset(disk.used, 0, PGSIZE);
    8000669a:	6605                	lui	a2,0x1
    8000669c:	4581                	li	a1,0
    8000669e:	6888                	ld	a0,16(s1)
    800066a0:	ffffb097          	auipc	ra,0xffffb
    800066a4:	856080e7          	jalr	-1962(ra) # 80000ef6 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800066a8:	100017b7          	lui	a5,0x10001
    800066ac:	4721                	li	a4,8
    800066ae:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800066b0:	4098                	lw	a4,0(s1)
    800066b2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800066b6:	40d8                	lw	a4,4(s1)
    800066b8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800066bc:	6498                	ld	a4,8(s1)
    800066be:	0007069b          	sext.w	a3,a4
    800066c2:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800066c6:	9701                	srai	a4,a4,0x20
    800066c8:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800066cc:	6898                	ld	a4,16(s1)
    800066ce:	0007069b          	sext.w	a3,a4
    800066d2:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800066d6:	9701                	srai	a4,a4,0x20
    800066d8:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800066dc:	4705                	li	a4,1
    800066de:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800066e0:	00e48c23          	sb	a4,24(s1)
    800066e4:	00e48ca3          	sb	a4,25(s1)
    800066e8:	00e48d23          	sb	a4,26(s1)
    800066ec:	00e48da3          	sb	a4,27(s1)
    800066f0:	00e48e23          	sb	a4,28(s1)
    800066f4:	00e48ea3          	sb	a4,29(s1)
    800066f8:	00e48f23          	sb	a4,30(s1)
    800066fc:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006700:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006704:	0727a823          	sw	s2,112(a5)
}
    80006708:	60e2                	ld	ra,24(sp)
    8000670a:	6442                	ld	s0,16(sp)
    8000670c:	64a2                	ld	s1,8(sp)
    8000670e:	6902                	ld	s2,0(sp)
    80006710:	6105                	addi	sp,sp,32
    80006712:	8082                	ret
    panic("could not find virtio disk");
    80006714:	00002517          	auipc	a0,0x2
    80006718:	0cc50513          	addi	a0,a0,204 # 800087e0 <syscalls+0x338>
    8000671c:	ffffa097          	auipc	ra,0xffffa
    80006720:	e22080e7          	jalr	-478(ra) # 8000053e <panic>
    panic("virtio disk FEATURES_OK unset");
    80006724:	00002517          	auipc	a0,0x2
    80006728:	0dc50513          	addi	a0,a0,220 # 80008800 <syscalls+0x358>
    8000672c:	ffffa097          	auipc	ra,0xffffa
    80006730:	e12080e7          	jalr	-494(ra) # 8000053e <panic>
    panic("virtio disk should not be ready");
    80006734:	00002517          	auipc	a0,0x2
    80006738:	0ec50513          	addi	a0,a0,236 # 80008820 <syscalls+0x378>
    8000673c:	ffffa097          	auipc	ra,0xffffa
    80006740:	e02080e7          	jalr	-510(ra) # 8000053e <panic>
    panic("virtio disk has no queue 0");
    80006744:	00002517          	auipc	a0,0x2
    80006748:	0fc50513          	addi	a0,a0,252 # 80008840 <syscalls+0x398>
    8000674c:	ffffa097          	auipc	ra,0xffffa
    80006750:	df2080e7          	jalr	-526(ra) # 8000053e <panic>
    panic("virtio disk max queue too short");
    80006754:	00002517          	auipc	a0,0x2
    80006758:	10c50513          	addi	a0,a0,268 # 80008860 <syscalls+0x3b8>
    8000675c:	ffffa097          	auipc	ra,0xffffa
    80006760:	de2080e7          	jalr	-542(ra) # 8000053e <panic>
    panic("virtio disk kalloc");
    80006764:	00002517          	auipc	a0,0x2
    80006768:	11c50513          	addi	a0,a0,284 # 80008880 <syscalls+0x3d8>
    8000676c:	ffffa097          	auipc	ra,0xffffa
    80006770:	dd2080e7          	jalr	-558(ra) # 8000053e <panic>

0000000080006774 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006774:	7119                	addi	sp,sp,-128
    80006776:	fc86                	sd	ra,120(sp)
    80006778:	f8a2                	sd	s0,112(sp)
    8000677a:	f4a6                	sd	s1,104(sp)
    8000677c:	f0ca                	sd	s2,96(sp)
    8000677e:	ecce                	sd	s3,88(sp)
    80006780:	e8d2                	sd	s4,80(sp)
    80006782:	e4d6                	sd	s5,72(sp)
    80006784:	e0da                	sd	s6,64(sp)
    80006786:	fc5e                	sd	s7,56(sp)
    80006788:	f862                	sd	s8,48(sp)
    8000678a:	f466                	sd	s9,40(sp)
    8000678c:	f06a                	sd	s10,32(sp)
    8000678e:	ec6e                	sd	s11,24(sp)
    80006790:	0100                	addi	s0,sp,128
    80006792:	8aaa                	mv	s5,a0
    80006794:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006796:	00c52d03          	lw	s10,12(a0)
    8000679a:	001d1d1b          	slliw	s10,s10,0x1
    8000679e:	1d02                	slli	s10,s10,0x20
    800067a0:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    800067a4:	0023c517          	auipc	a0,0x23c
    800067a8:	00c50513          	addi	a0,a0,12 # 802427b0 <disk+0x128>
    800067ac:	ffffa097          	auipc	ra,0xffffa
    800067b0:	64e080e7          	jalr	1614(ra) # 80000dfa <acquire>
  for(int i = 0; i < 3; i++){
    800067b4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800067b6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800067b8:	0023cb97          	auipc	s7,0x23c
    800067bc:	ed0b8b93          	addi	s7,s7,-304 # 80242688 <disk>
  for(int i = 0; i < 3; i++){
    800067c0:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800067c2:	0023cc97          	auipc	s9,0x23c
    800067c6:	feec8c93          	addi	s9,s9,-18 # 802427b0 <disk+0x128>
    800067ca:	a08d                	j	8000682c <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800067cc:	00fb8733          	add	a4,s7,a5
    800067d0:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800067d4:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800067d6:	0207c563          	bltz	a5,80006800 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800067da:	2905                	addiw	s2,s2,1
    800067dc:	0611                	addi	a2,a2,4
    800067de:	05690c63          	beq	s2,s6,80006836 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800067e2:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800067e4:	0023c717          	auipc	a4,0x23c
    800067e8:	ea470713          	addi	a4,a4,-348 # 80242688 <disk>
    800067ec:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800067ee:	01874683          	lbu	a3,24(a4)
    800067f2:	fee9                	bnez	a3,800067cc <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800067f4:	2785                	addiw	a5,a5,1
    800067f6:	0705                	addi	a4,a4,1
    800067f8:	fe979be3          	bne	a5,s1,800067ee <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800067fc:	57fd                	li	a5,-1
    800067fe:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006800:	01205d63          	blez	s2,8000681a <virtio_disk_rw+0xa6>
    80006804:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006806:	000a2503          	lw	a0,0(s4)
    8000680a:	00000097          	auipc	ra,0x0
    8000680e:	cfc080e7          	jalr	-772(ra) # 80006506 <free_desc>
      for(int j = 0; j < i; j++)
    80006812:	2d85                	addiw	s11,s11,1
    80006814:	0a11                	addi	s4,s4,4
    80006816:	ffb918e3          	bne	s2,s11,80006806 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000681a:	85e6                	mv	a1,s9
    8000681c:	0023c517          	auipc	a0,0x23c
    80006820:	e8450513          	addi	a0,a0,-380 # 802426a0 <disk+0x18>
    80006824:	ffffc097          	auipc	ra,0xffffc
    80006828:	cbe080e7          	jalr	-834(ra) # 800024e2 <sleep>
  for(int i = 0; i < 3; i++){
    8000682c:	f8040a13          	addi	s4,s0,-128
{
    80006830:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80006832:	894e                	mv	s2,s3
    80006834:	b77d                	j	800067e2 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006836:	f8042583          	lw	a1,-128(s0)
    8000683a:	00a58793          	addi	a5,a1,10
    8000683e:	0792                	slli	a5,a5,0x4

  if(write)
    80006840:	0023c617          	auipc	a2,0x23c
    80006844:	e4860613          	addi	a2,a2,-440 # 80242688 <disk>
    80006848:	00f60733          	add	a4,a2,a5
    8000684c:	018036b3          	snez	a3,s8
    80006850:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006852:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006856:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000685a:	f6078693          	addi	a3,a5,-160
    8000685e:	6218                	ld	a4,0(a2)
    80006860:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006862:	00878513          	addi	a0,a5,8
    80006866:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006868:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000686a:	6208                	ld	a0,0(a2)
    8000686c:	96aa                	add	a3,a3,a0
    8000686e:	4741                	li	a4,16
    80006870:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006872:	4705                	li	a4,1
    80006874:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80006878:	f8442703          	lw	a4,-124(s0)
    8000687c:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006880:	0712                	slli	a4,a4,0x4
    80006882:	953a                	add	a0,a0,a4
    80006884:	058a8693          	addi	a3,s5,88
    80006888:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000688a:	6208                	ld	a0,0(a2)
    8000688c:	972a                	add	a4,a4,a0
    8000688e:	40000693          	li	a3,1024
    80006892:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006894:	001c3c13          	seqz	s8,s8
    80006898:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000689a:	001c6c13          	ori	s8,s8,1
    8000689e:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800068a2:	f8842603          	lw	a2,-120(s0)
    800068a6:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800068aa:	0023c697          	auipc	a3,0x23c
    800068ae:	dde68693          	addi	a3,a3,-546 # 80242688 <disk>
    800068b2:	00258713          	addi	a4,a1,2
    800068b6:	0712                	slli	a4,a4,0x4
    800068b8:	9736                	add	a4,a4,a3
    800068ba:	587d                	li	a6,-1
    800068bc:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800068c0:	0612                	slli	a2,a2,0x4
    800068c2:	9532                	add	a0,a0,a2
    800068c4:	f9078793          	addi	a5,a5,-112
    800068c8:	97b6                	add	a5,a5,a3
    800068ca:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    800068cc:	629c                	ld	a5,0(a3)
    800068ce:	97b2                	add	a5,a5,a2
    800068d0:	4605                	li	a2,1
    800068d2:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800068d4:	4509                	li	a0,2
    800068d6:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    800068da:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800068de:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800068e2:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800068e6:	6698                	ld	a4,8(a3)
    800068e8:	00275783          	lhu	a5,2(a4)
    800068ec:	8b9d                	andi	a5,a5,7
    800068ee:	0786                	slli	a5,a5,0x1
    800068f0:	97ba                	add	a5,a5,a4
    800068f2:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800068f6:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800068fa:	6698                	ld	a4,8(a3)
    800068fc:	00275783          	lhu	a5,2(a4)
    80006900:	2785                	addiw	a5,a5,1
    80006902:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006906:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000690a:	100017b7          	lui	a5,0x10001
    8000690e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006912:	004aa783          	lw	a5,4(s5)
    80006916:	02c79163          	bne	a5,a2,80006938 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    8000691a:	0023c917          	auipc	s2,0x23c
    8000691e:	e9690913          	addi	s2,s2,-362 # 802427b0 <disk+0x128>
  while(b->disk == 1) {
    80006922:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006924:	85ca                	mv	a1,s2
    80006926:	8556                	mv	a0,s5
    80006928:	ffffc097          	auipc	ra,0xffffc
    8000692c:	bba080e7          	jalr	-1094(ra) # 800024e2 <sleep>
  while(b->disk == 1) {
    80006930:	004aa783          	lw	a5,4(s5)
    80006934:	fe9788e3          	beq	a5,s1,80006924 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006938:	f8042903          	lw	s2,-128(s0)
    8000693c:	00290793          	addi	a5,s2,2
    80006940:	00479713          	slli	a4,a5,0x4
    80006944:	0023c797          	auipc	a5,0x23c
    80006948:	d4478793          	addi	a5,a5,-700 # 80242688 <disk>
    8000694c:	97ba                	add	a5,a5,a4
    8000694e:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006952:	0023c997          	auipc	s3,0x23c
    80006956:	d3698993          	addi	s3,s3,-714 # 80242688 <disk>
    8000695a:	00491713          	slli	a4,s2,0x4
    8000695e:	0009b783          	ld	a5,0(s3)
    80006962:	97ba                	add	a5,a5,a4
    80006964:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006968:	854a                	mv	a0,s2
    8000696a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000696e:	00000097          	auipc	ra,0x0
    80006972:	b98080e7          	jalr	-1128(ra) # 80006506 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006976:	8885                	andi	s1,s1,1
    80006978:	f0ed                	bnez	s1,8000695a <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000697a:	0023c517          	auipc	a0,0x23c
    8000697e:	e3650513          	addi	a0,a0,-458 # 802427b0 <disk+0x128>
    80006982:	ffffa097          	auipc	ra,0xffffa
    80006986:	52c080e7          	jalr	1324(ra) # 80000eae <release>
}
    8000698a:	70e6                	ld	ra,120(sp)
    8000698c:	7446                	ld	s0,112(sp)
    8000698e:	74a6                	ld	s1,104(sp)
    80006990:	7906                	ld	s2,96(sp)
    80006992:	69e6                	ld	s3,88(sp)
    80006994:	6a46                	ld	s4,80(sp)
    80006996:	6aa6                	ld	s5,72(sp)
    80006998:	6b06                	ld	s6,64(sp)
    8000699a:	7be2                	ld	s7,56(sp)
    8000699c:	7c42                	ld	s8,48(sp)
    8000699e:	7ca2                	ld	s9,40(sp)
    800069a0:	7d02                	ld	s10,32(sp)
    800069a2:	6de2                	ld	s11,24(sp)
    800069a4:	6109                	addi	sp,sp,128
    800069a6:	8082                	ret

00000000800069a8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800069a8:	1101                	addi	sp,sp,-32
    800069aa:	ec06                	sd	ra,24(sp)
    800069ac:	e822                	sd	s0,16(sp)
    800069ae:	e426                	sd	s1,8(sp)
    800069b0:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800069b2:	0023c497          	auipc	s1,0x23c
    800069b6:	cd648493          	addi	s1,s1,-810 # 80242688 <disk>
    800069ba:	0023c517          	auipc	a0,0x23c
    800069be:	df650513          	addi	a0,a0,-522 # 802427b0 <disk+0x128>
    800069c2:	ffffa097          	auipc	ra,0xffffa
    800069c6:	438080e7          	jalr	1080(ra) # 80000dfa <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800069ca:	10001737          	lui	a4,0x10001
    800069ce:	533c                	lw	a5,96(a4)
    800069d0:	8b8d                	andi	a5,a5,3
    800069d2:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800069d4:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800069d8:	689c                	ld	a5,16(s1)
    800069da:	0204d703          	lhu	a4,32(s1)
    800069de:	0027d783          	lhu	a5,2(a5)
    800069e2:	04f70863          	beq	a4,a5,80006a32 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800069e6:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800069ea:	6898                	ld	a4,16(s1)
    800069ec:	0204d783          	lhu	a5,32(s1)
    800069f0:	8b9d                	andi	a5,a5,7
    800069f2:	078e                	slli	a5,a5,0x3
    800069f4:	97ba                	add	a5,a5,a4
    800069f6:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800069f8:	00278713          	addi	a4,a5,2
    800069fc:	0712                	slli	a4,a4,0x4
    800069fe:	9726                	add	a4,a4,s1
    80006a00:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006a04:	e721                	bnez	a4,80006a4c <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006a06:	0789                	addi	a5,a5,2
    80006a08:	0792                	slli	a5,a5,0x4
    80006a0a:	97a6                	add	a5,a5,s1
    80006a0c:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006a0e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006a12:	ffffc097          	auipc	ra,0xffffc
    80006a16:	b34080e7          	jalr	-1228(ra) # 80002546 <wakeup>

    disk.used_idx += 1;
    80006a1a:	0204d783          	lhu	a5,32(s1)
    80006a1e:	2785                	addiw	a5,a5,1
    80006a20:	17c2                	slli	a5,a5,0x30
    80006a22:	93c1                	srli	a5,a5,0x30
    80006a24:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006a28:	6898                	ld	a4,16(s1)
    80006a2a:	00275703          	lhu	a4,2(a4)
    80006a2e:	faf71ce3          	bne	a4,a5,800069e6 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80006a32:	0023c517          	auipc	a0,0x23c
    80006a36:	d7e50513          	addi	a0,a0,-642 # 802427b0 <disk+0x128>
    80006a3a:	ffffa097          	auipc	ra,0xffffa
    80006a3e:	474080e7          	jalr	1140(ra) # 80000eae <release>
}
    80006a42:	60e2                	ld	ra,24(sp)
    80006a44:	6442                	ld	s0,16(sp)
    80006a46:	64a2                	ld	s1,8(sp)
    80006a48:	6105                	addi	sp,sp,32
    80006a4a:	8082                	ret
      panic("virtio_disk_intr status");
    80006a4c:	00002517          	auipc	a0,0x2
    80006a50:	e4c50513          	addi	a0,a0,-436 # 80008898 <syscalls+0x3f0>
    80006a54:	ffffa097          	auipc	ra,0xffffa
    80006a58:	aea080e7          	jalr	-1302(ra) # 8000053e <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
