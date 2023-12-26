
user/_cowtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <simpletest>:
// allocate more than half of physical memory,
// then fork. this will fail in the default
// kernel, which does not support copy-on-write.
void
simpletest()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = (phys_size / 3) * 2;

  printf("simple: ");
   e:	00001517          	auipc	a0,0x1
  12:	c8250513          	addi	a0,a0,-894 # c90 <malloc+0xee>
  16:	00001097          	auipc	ra,0x1
  1a:	ace080e7          	jalr	-1330(ra) # ae4 <printf>
  
  char *p = sbrk(sz);
  1e:	05555537          	lui	a0,0x5555
  22:	55450513          	addi	a0,a0,1364 # 5555554 <base+0x5550544>
  26:	00000097          	auipc	ra,0x0
  2a:	7be080e7          	jalr	1982(ra) # 7e4 <sbrk>
  if(p == (char*)0xffffffffffffffffL){
  2e:	57fd                	li	a5,-1
  30:	06f50563          	beq	a0,a5,9a <simpletest+0x9a>
  34:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  for(char *q = p; q < p + sz; q += 4096){
  36:	05556937          	lui	s2,0x5556
  3a:	992a                	add	s2,s2,a0
  3c:	6985                	lui	s3,0x1
    *(int*)q = getpid();
  3e:	00000097          	auipc	ra,0x0
  42:	79e080e7          	jalr	1950(ra) # 7dc <getpid>
  46:	c088                	sw	a0,0(s1)
  for(char *q = p; q < p + sz; q += 4096){
  48:	94ce                	add	s1,s1,s3
  4a:	fe991ae3          	bne	s2,s1,3e <simpletest+0x3e>
  }

  int pid = fork();
  4e:	00000097          	auipc	ra,0x0
  52:	706080e7          	jalr	1798(ra) # 754 <fork>
  if(pid < 0){
  56:	06054363          	bltz	a0,bc <simpletest+0xbc>
    printf("fork() failed\n");
    exit(-1);
  }

  if(pid == 0)
  5a:	cd35                	beqz	a0,d6 <simpletest+0xd6>
    exit(0);

  wait(0);
  5c:	4501                	li	a0,0
  5e:	00000097          	auipc	ra,0x0
  62:	706080e7          	jalr	1798(ra) # 764 <wait>

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
  66:	faaab537          	lui	a0,0xfaaab
  6a:	aac50513          	addi	a0,a0,-1364 # fffffffffaaaaaac <base+0xfffffffffaaa5a9c>
  6e:	00000097          	auipc	ra,0x0
  72:	776080e7          	jalr	1910(ra) # 7e4 <sbrk>
  76:	57fd                	li	a5,-1
  78:	06f50363          	beq	a0,a5,de <simpletest+0xde>
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
  7c:	00001517          	auipc	a0,0x1
  80:	c6450513          	addi	a0,a0,-924 # ce0 <malloc+0x13e>
  84:	00001097          	auipc	ra,0x1
  88:	a60080e7          	jalr	-1440(ra) # ae4 <printf>
}
  8c:	70a2                	ld	ra,40(sp)
  8e:	7402                	ld	s0,32(sp)
  90:	64e2                	ld	s1,24(sp)
  92:	6942                	ld	s2,16(sp)
  94:	69a2                	ld	s3,8(sp)
  96:	6145                	addi	sp,sp,48
  98:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
  9a:	055555b7          	lui	a1,0x5555
  9e:	55458593          	addi	a1,a1,1364 # 5555554 <base+0x5550544>
  a2:	00001517          	auipc	a0,0x1
  a6:	bfe50513          	addi	a0,a0,-1026 # ca0 <malloc+0xfe>
  aa:	00001097          	auipc	ra,0x1
  ae:	a3a080e7          	jalr	-1478(ra) # ae4 <printf>
    exit(-1);
  b2:	557d                	li	a0,-1
  b4:	00000097          	auipc	ra,0x0
  b8:	6a8080e7          	jalr	1704(ra) # 75c <exit>
    printf("fork() failed\n");
  bc:	00001517          	auipc	a0,0x1
  c0:	bfc50513          	addi	a0,a0,-1028 # cb8 <malloc+0x116>
  c4:	00001097          	auipc	ra,0x1
  c8:	a20080e7          	jalr	-1504(ra) # ae4 <printf>
    exit(-1);
  cc:	557d                	li	a0,-1
  ce:	00000097          	auipc	ra,0x0
  d2:	68e080e7          	jalr	1678(ra) # 75c <exit>
    exit(0);
  d6:	00000097          	auipc	ra,0x0
  da:	686080e7          	jalr	1670(ra) # 75c <exit>
    printf("sbrk(-%d) failed\n", sz);
  de:	055555b7          	lui	a1,0x5555
  e2:	55458593          	addi	a1,a1,1364 # 5555554 <base+0x5550544>
  e6:	00001517          	auipc	a0,0x1
  ea:	be250513          	addi	a0,a0,-1054 # cc8 <malloc+0x126>
  ee:	00001097          	auipc	ra,0x1
  f2:	9f6080e7          	jalr	-1546(ra) # ae4 <printf>
    exit(-1);
  f6:	557d                	li	a0,-1
  f8:	00000097          	auipc	ra,0x0
  fc:	664080e7          	jalr	1636(ra) # 75c <exit>

0000000000000100 <threetest>:
// this causes more than half of physical memory
// to be allocated, so it also checks whether
// copied pages are freed.
void
threetest()
{
 100:	7179                	addi	sp,sp,-48
 102:	f406                	sd	ra,40(sp)
 104:	f022                	sd	s0,32(sp)
 106:	ec26                	sd	s1,24(sp)
 108:	e84a                	sd	s2,16(sp)
 10a:	e44e                	sd	s3,8(sp)
 10c:	e052                	sd	s4,0(sp)
 10e:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = phys_size / 4;
  int pid1, pid2;

  printf("three: ");
 110:	00001517          	auipc	a0,0x1
 114:	bd850513          	addi	a0,a0,-1064 # ce8 <malloc+0x146>
 118:	00001097          	auipc	ra,0x1
 11c:	9cc080e7          	jalr	-1588(ra) # ae4 <printf>
  
  char *p = sbrk(sz);
 120:	02000537          	lui	a0,0x2000
 124:	00000097          	auipc	ra,0x0
 128:	6c0080e7          	jalr	1728(ra) # 7e4 <sbrk>
  if(p == (char*)0xffffffffffffffffL){
 12c:	57fd                	li	a5,-1
 12e:	08f50763          	beq	a0,a5,1bc <threetest+0xbc>
 132:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  pid1 = fork();
 134:	00000097          	auipc	ra,0x0
 138:	620080e7          	jalr	1568(ra) # 754 <fork>
  if(pid1 < 0){
 13c:	08054f63          	bltz	a0,1da <threetest+0xda>
    printf("fork failed\n");
    exit(-1);
  }
  if(pid1 == 0){
 140:	c955                	beqz	a0,1f4 <threetest+0xf4>
      *(int*)q = 9999;
    }
    exit(0);
  }

  for(char *q = p; q < p + sz; q += 4096){
 142:	020009b7          	lui	s3,0x2000
 146:	99a6                	add	s3,s3,s1
 148:	8926                	mv	s2,s1
 14a:	6a05                	lui	s4,0x1
    *(int*)q = getpid();
 14c:	00000097          	auipc	ra,0x0
 150:	690080e7          	jalr	1680(ra) # 7dc <getpid>
 154:	00a92023          	sw	a0,0(s2) # 5556000 <base+0x5550ff0>
  for(char *q = p; q < p + sz; q += 4096){
 158:	9952                	add	s2,s2,s4
 15a:	ff3919e3          	bne	s2,s3,14c <threetest+0x4c>
  }

  wait(0);
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	604080e7          	jalr	1540(ra) # 764 <wait>

  sleep(1);
 168:	4505                	li	a0,1
 16a:	00000097          	auipc	ra,0x0
 16e:	682080e7          	jalr	1666(ra) # 7ec <sleep>

  for(char *q = p; q < p + sz; q += 4096){
 172:	6a05                	lui	s4,0x1
    if(*(int*)q != getpid()){
 174:	0004a903          	lw	s2,0(s1)
 178:	00000097          	auipc	ra,0x0
 17c:	664080e7          	jalr	1636(ra) # 7dc <getpid>
 180:	10a91a63          	bne	s2,a0,294 <threetest+0x194>
  for(char *q = p; q < p + sz; q += 4096){
 184:	94d2                	add	s1,s1,s4
 186:	ff3497e3          	bne	s1,s3,174 <threetest+0x74>
      printf("wrong content\n");
      exit(-1);
    }
  }

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
 18a:	fe000537          	lui	a0,0xfe000
 18e:	00000097          	auipc	ra,0x0
 192:	656080e7          	jalr	1622(ra) # 7e4 <sbrk>
 196:	57fd                	li	a5,-1
 198:	10f50b63          	beq	a0,a5,2ae <threetest+0x1ae>
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
 19c:	00001517          	auipc	a0,0x1
 1a0:	b4450513          	addi	a0,a0,-1212 # ce0 <malloc+0x13e>
 1a4:	00001097          	auipc	ra,0x1
 1a8:	940080e7          	jalr	-1728(ra) # ae4 <printf>
}
 1ac:	70a2                	ld	ra,40(sp)
 1ae:	7402                	ld	s0,32(sp)
 1b0:	64e2                	ld	s1,24(sp)
 1b2:	6942                	ld	s2,16(sp)
 1b4:	69a2                	ld	s3,8(sp)
 1b6:	6a02                	ld	s4,0(sp)
 1b8:	6145                	addi	sp,sp,48
 1ba:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
 1bc:	020005b7          	lui	a1,0x2000
 1c0:	00001517          	auipc	a0,0x1
 1c4:	ae050513          	addi	a0,a0,-1312 # ca0 <malloc+0xfe>
 1c8:	00001097          	auipc	ra,0x1
 1cc:	91c080e7          	jalr	-1764(ra) # ae4 <printf>
    exit(-1);
 1d0:	557d                	li	a0,-1
 1d2:	00000097          	auipc	ra,0x0
 1d6:	58a080e7          	jalr	1418(ra) # 75c <exit>
    printf("fork failed\n");
 1da:	00001517          	auipc	a0,0x1
 1de:	b1650513          	addi	a0,a0,-1258 # cf0 <malloc+0x14e>
 1e2:	00001097          	auipc	ra,0x1
 1e6:	902080e7          	jalr	-1790(ra) # ae4 <printf>
    exit(-1);
 1ea:	557d                	li	a0,-1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	570080e7          	jalr	1392(ra) # 75c <exit>
    pid2 = fork();
 1f4:	00000097          	auipc	ra,0x0
 1f8:	560080e7          	jalr	1376(ra) # 754 <fork>
    if(pid2 < 0){
 1fc:	04054263          	bltz	a0,240 <threetest+0x140>
    if(pid2 == 0){
 200:	ed29                	bnez	a0,25a <threetest+0x15a>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 202:	0199a9b7          	lui	s3,0x199a
 206:	99a6                	add	s3,s3,s1
 208:	8926                	mv	s2,s1
 20a:	6a05                	lui	s4,0x1
        *(int*)q = getpid();
 20c:	00000097          	auipc	ra,0x0
 210:	5d0080e7          	jalr	1488(ra) # 7dc <getpid>
 214:	00a92023          	sw	a0,0(s2)
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 218:	9952                	add	s2,s2,s4
 21a:	ff2999e3          	bne	s3,s2,20c <threetest+0x10c>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 21e:	6a05                	lui	s4,0x1
        if(*(int*)q != getpid()){
 220:	0004a903          	lw	s2,0(s1)
 224:	00000097          	auipc	ra,0x0
 228:	5b8080e7          	jalr	1464(ra) # 7dc <getpid>
 22c:	04a91763          	bne	s2,a0,27a <threetest+0x17a>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 230:	94d2                	add	s1,s1,s4
 232:	fe9997e3          	bne	s3,s1,220 <threetest+0x120>
      exit(-1);
 236:	557d                	li	a0,-1
 238:	00000097          	auipc	ra,0x0
 23c:	524080e7          	jalr	1316(ra) # 75c <exit>
      printf("fork failed");
 240:	00001517          	auipc	a0,0x1
 244:	ac050513          	addi	a0,a0,-1344 # d00 <malloc+0x15e>
 248:	00001097          	auipc	ra,0x1
 24c:	89c080e7          	jalr	-1892(ra) # ae4 <printf>
      exit(-1);
 250:	557d                	li	a0,-1
 252:	00000097          	auipc	ra,0x0
 256:	50a080e7          	jalr	1290(ra) # 75c <exit>
    for(char *q = p; q < p + (sz/2); q += 4096){
 25a:	01000737          	lui	a4,0x1000
 25e:	9726                	add	a4,a4,s1
      *(int*)q = 9999;
 260:	6789                	lui	a5,0x2
 262:	70f78793          	addi	a5,a5,1807 # 270f <buf+0x6ff>
    for(char *q = p; q < p + (sz/2); q += 4096){
 266:	6685                	lui	a3,0x1
      *(int*)q = 9999;
 268:	c09c                	sw	a5,0(s1)
    for(char *q = p; q < p + (sz/2); q += 4096){
 26a:	94b6                	add	s1,s1,a3
 26c:	fee49ee3          	bne	s1,a4,268 <threetest+0x168>
    exit(0);
 270:	4501                	li	a0,0
 272:	00000097          	auipc	ra,0x0
 276:	4ea080e7          	jalr	1258(ra) # 75c <exit>
          printf("wrong content\n");
 27a:	00001517          	auipc	a0,0x1
 27e:	a9650513          	addi	a0,a0,-1386 # d10 <malloc+0x16e>
 282:	00001097          	auipc	ra,0x1
 286:	862080e7          	jalr	-1950(ra) # ae4 <printf>
          exit(-1);
 28a:	557d                	li	a0,-1
 28c:	00000097          	auipc	ra,0x0
 290:	4d0080e7          	jalr	1232(ra) # 75c <exit>
      printf("wrong content\n");
 294:	00001517          	auipc	a0,0x1
 298:	a7c50513          	addi	a0,a0,-1412 # d10 <malloc+0x16e>
 29c:	00001097          	auipc	ra,0x1
 2a0:	848080e7          	jalr	-1976(ra) # ae4 <printf>
      exit(-1);
 2a4:	557d                	li	a0,-1
 2a6:	00000097          	auipc	ra,0x0
 2aa:	4b6080e7          	jalr	1206(ra) # 75c <exit>
    printf("sbrk(-%d) failed\n", sz);
 2ae:	020005b7          	lui	a1,0x2000
 2b2:	00001517          	auipc	a0,0x1
 2b6:	a1650513          	addi	a0,a0,-1514 # cc8 <malloc+0x126>
 2ba:	00001097          	auipc	ra,0x1
 2be:	82a080e7          	jalr	-2006(ra) # ae4 <printf>
    exit(-1);
 2c2:	557d                	li	a0,-1
 2c4:	00000097          	auipc	ra,0x0
 2c8:	498080e7          	jalr	1176(ra) # 75c <exit>

00000000000002cc <filetest>:
char junk3[4096];

// test whether copyout() simulates COW faults.
void
filetest()
{
 2cc:	7179                	addi	sp,sp,-48
 2ce:	f406                	sd	ra,40(sp)
 2d0:	f022                	sd	s0,32(sp)
 2d2:	ec26                	sd	s1,24(sp)
 2d4:	e84a                	sd	s2,16(sp)
 2d6:	1800                	addi	s0,sp,48
  printf("file: ");
 2d8:	00001517          	auipc	a0,0x1
 2dc:	a4850513          	addi	a0,a0,-1464 # d20 <malloc+0x17e>
 2e0:	00001097          	auipc	ra,0x1
 2e4:	804080e7          	jalr	-2044(ra) # ae4 <printf>
  
  buf[0] = 99;
 2e8:	06300793          	li	a5,99
 2ec:	00002717          	auipc	a4,0x2
 2f0:	d2f70223          	sb	a5,-732(a4) # 2010 <buf>

  for(int i = 0; i < 4; i++){
 2f4:	fc042c23          	sw	zero,-40(s0)
    if(pipe(fds) != 0){
 2f8:	00001497          	auipc	s1,0x1
 2fc:	d0848493          	addi	s1,s1,-760 # 1000 <fds>
  for(int i = 0; i < 4; i++){
 300:	490d                	li	s2,3
    if(pipe(fds) != 0){
 302:	8526                	mv	a0,s1
 304:	00000097          	auipc	ra,0x0
 308:	468080e7          	jalr	1128(ra) # 76c <pipe>
 30c:	e149                	bnez	a0,38e <filetest+0xc2>
      printf("pipe() failed\n");
      exit(-1);
    }
    int pid = fork();
 30e:	00000097          	auipc	ra,0x0
 312:	446080e7          	jalr	1094(ra) # 754 <fork>
    if(pid < 0){
 316:	08054963          	bltz	a0,3a8 <filetest+0xdc>
      printf("fork failed\n");
      exit(-1);
    }
    if(pid == 0){
 31a:	c545                	beqz	a0,3c2 <filetest+0xf6>
        printf("error: read the wrong value\n");
        exit(1);
      }
      exit(0);
    }
    if(write(fds[1], &i, sizeof(i)) != sizeof(i)){
 31c:	4611                	li	a2,4
 31e:	fd840593          	addi	a1,s0,-40
 322:	40c8                	lw	a0,4(s1)
 324:	00000097          	auipc	ra,0x0
 328:	458080e7          	jalr	1112(ra) # 77c <write>
 32c:	4791                	li	a5,4
 32e:	10f51b63          	bne	a0,a5,444 <filetest+0x178>
  for(int i = 0; i < 4; i++){
 332:	fd842783          	lw	a5,-40(s0)
 336:	2785                	addiw	a5,a5,1
 338:	0007871b          	sext.w	a4,a5
 33c:	fcf42c23          	sw	a5,-40(s0)
 340:	fce951e3          	bge	s2,a4,302 <filetest+0x36>
      printf("error: write failed\n");
      exit(-1);
    }
  }

  int xstatus = 0;
 344:	fc042e23          	sw	zero,-36(s0)
 348:	4491                	li	s1,4
  for(int i = 0; i < 4; i++) {
    wait(&xstatus);
 34a:	fdc40513          	addi	a0,s0,-36
 34e:	00000097          	auipc	ra,0x0
 352:	416080e7          	jalr	1046(ra) # 764 <wait>
    if(xstatus != 0) {
 356:	fdc42783          	lw	a5,-36(s0)
 35a:	10079263          	bnez	a5,45e <filetest+0x192>
  for(int i = 0; i < 4; i++) {
 35e:	34fd                	addiw	s1,s1,-1
 360:	f4ed                	bnez	s1,34a <filetest+0x7e>
      exit(1);
    }
  }

  if(buf[0] != 99){
 362:	00002717          	auipc	a4,0x2
 366:	cae74703          	lbu	a4,-850(a4) # 2010 <buf>
 36a:	06300793          	li	a5,99
 36e:	0ef71d63          	bne	a4,a5,468 <filetest+0x19c>
    printf("error: child overwrote parent\n");
    exit(1);
  }

  printf("ok\n");
 372:	00001517          	auipc	a0,0x1
 376:	96e50513          	addi	a0,a0,-1682 # ce0 <malloc+0x13e>
 37a:	00000097          	auipc	ra,0x0
 37e:	76a080e7          	jalr	1898(ra) # ae4 <printf>
}
 382:	70a2                	ld	ra,40(sp)
 384:	7402                	ld	s0,32(sp)
 386:	64e2                	ld	s1,24(sp)
 388:	6942                	ld	s2,16(sp)
 38a:	6145                	addi	sp,sp,48
 38c:	8082                	ret
      printf("pipe() failed\n");
 38e:	00001517          	auipc	a0,0x1
 392:	99a50513          	addi	a0,a0,-1638 # d28 <malloc+0x186>
 396:	00000097          	auipc	ra,0x0
 39a:	74e080e7          	jalr	1870(ra) # ae4 <printf>
      exit(-1);
 39e:	557d                	li	a0,-1
 3a0:	00000097          	auipc	ra,0x0
 3a4:	3bc080e7          	jalr	956(ra) # 75c <exit>
      printf("fork failed\n");
 3a8:	00001517          	auipc	a0,0x1
 3ac:	94850513          	addi	a0,a0,-1720 # cf0 <malloc+0x14e>
 3b0:	00000097          	auipc	ra,0x0
 3b4:	734080e7          	jalr	1844(ra) # ae4 <printf>
      exit(-1);
 3b8:	557d                	li	a0,-1
 3ba:	00000097          	auipc	ra,0x0
 3be:	3a2080e7          	jalr	930(ra) # 75c <exit>
      sleep(1);
 3c2:	4505                	li	a0,1
 3c4:	00000097          	auipc	ra,0x0
 3c8:	428080e7          	jalr	1064(ra) # 7ec <sleep>
      if(read(fds[0], buf, sizeof(i)) != sizeof(i)){
 3cc:	4611                	li	a2,4
 3ce:	00002597          	auipc	a1,0x2
 3d2:	c4258593          	addi	a1,a1,-958 # 2010 <buf>
 3d6:	00001517          	auipc	a0,0x1
 3da:	c2a52503          	lw	a0,-982(a0) # 1000 <fds>
 3de:	00000097          	auipc	ra,0x0
 3e2:	396080e7          	jalr	918(ra) # 774 <read>
 3e6:	4791                	li	a5,4
 3e8:	02f51c63          	bne	a0,a5,420 <filetest+0x154>
      sleep(1);
 3ec:	4505                	li	a0,1
 3ee:	00000097          	auipc	ra,0x0
 3f2:	3fe080e7          	jalr	1022(ra) # 7ec <sleep>
      if(j != i){
 3f6:	fd842703          	lw	a4,-40(s0)
 3fa:	00002797          	auipc	a5,0x2
 3fe:	c167a783          	lw	a5,-1002(a5) # 2010 <buf>
 402:	02f70c63          	beq	a4,a5,43a <filetest+0x16e>
        printf("error: read the wrong value\n");
 406:	00001517          	auipc	a0,0x1
 40a:	94a50513          	addi	a0,a0,-1718 # d50 <malloc+0x1ae>
 40e:	00000097          	auipc	ra,0x0
 412:	6d6080e7          	jalr	1750(ra) # ae4 <printf>
        exit(1);
 416:	4505                	li	a0,1
 418:	00000097          	auipc	ra,0x0
 41c:	344080e7          	jalr	836(ra) # 75c <exit>
        printf("error: read failed\n");
 420:	00001517          	auipc	a0,0x1
 424:	91850513          	addi	a0,a0,-1768 # d38 <malloc+0x196>
 428:	00000097          	auipc	ra,0x0
 42c:	6bc080e7          	jalr	1724(ra) # ae4 <printf>
        exit(1);
 430:	4505                	li	a0,1
 432:	00000097          	auipc	ra,0x0
 436:	32a080e7          	jalr	810(ra) # 75c <exit>
      exit(0);
 43a:	4501                	li	a0,0
 43c:	00000097          	auipc	ra,0x0
 440:	320080e7          	jalr	800(ra) # 75c <exit>
      printf("error: write failed\n");
 444:	00001517          	auipc	a0,0x1
 448:	92c50513          	addi	a0,a0,-1748 # d70 <malloc+0x1ce>
 44c:	00000097          	auipc	ra,0x0
 450:	698080e7          	jalr	1688(ra) # ae4 <printf>
      exit(-1);
 454:	557d                	li	a0,-1
 456:	00000097          	auipc	ra,0x0
 45a:	306080e7          	jalr	774(ra) # 75c <exit>
      exit(1);
 45e:	4505                	li	a0,1
 460:	00000097          	auipc	ra,0x0
 464:	2fc080e7          	jalr	764(ra) # 75c <exit>
    printf("error: child overwrote parent\n");
 468:	00001517          	auipc	a0,0x1
 46c:	92050513          	addi	a0,a0,-1760 # d88 <malloc+0x1e6>
 470:	00000097          	auipc	ra,0x0
 474:	674080e7          	jalr	1652(ra) # ae4 <printf>
    exit(1);
 478:	4505                	li	a0,1
 47a:	00000097          	auipc	ra,0x0
 47e:	2e2080e7          	jalr	738(ra) # 75c <exit>

0000000000000482 <main>:

int
main(int argc, char *argv[])
{
 482:	1141                	addi	sp,sp,-16
 484:	e406                	sd	ra,8(sp)
 486:	e022                	sd	s0,0(sp)
 488:	0800                	addi	s0,sp,16
  simpletest();
 48a:	00000097          	auipc	ra,0x0
 48e:	b76080e7          	jalr	-1162(ra) # 0 <simpletest>

  // check that the first simpletest() freed the physical memory.
  simpletest();
 492:	00000097          	auipc	ra,0x0
 496:	b6e080e7          	jalr	-1170(ra) # 0 <simpletest>

  threetest();
 49a:	00000097          	auipc	ra,0x0
 49e:	c66080e7          	jalr	-922(ra) # 100 <threetest>
  threetest();
 4a2:	00000097          	auipc	ra,0x0
 4a6:	c5e080e7          	jalr	-930(ra) # 100 <threetest>
  threetest();
 4aa:	00000097          	auipc	ra,0x0
 4ae:	c56080e7          	jalr	-938(ra) # 100 <threetest>

  filetest();
 4b2:	00000097          	auipc	ra,0x0
 4b6:	e1a080e7          	jalr	-486(ra) # 2cc <filetest>

  printf("ALL COW TESTS PASSED\n");
 4ba:	00001517          	auipc	a0,0x1
 4be:	8ee50513          	addi	a0,a0,-1810 # da8 <malloc+0x206>
 4c2:	00000097          	auipc	ra,0x0
 4c6:	622080e7          	jalr	1570(ra) # ae4 <printf>

  exit(0);
 4ca:	4501                	li	a0,0
 4cc:	00000097          	auipc	ra,0x0
 4d0:	290080e7          	jalr	656(ra) # 75c <exit>

00000000000004d4 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 4d4:	1141                	addi	sp,sp,-16
 4d6:	e406                	sd	ra,8(sp)
 4d8:	e022                	sd	s0,0(sp)
 4da:	0800                	addi	s0,sp,16
  extern int main();
  main();
 4dc:	00000097          	auipc	ra,0x0
 4e0:	fa6080e7          	jalr	-90(ra) # 482 <main>
  exit(0);
 4e4:	4501                	li	a0,0
 4e6:	00000097          	auipc	ra,0x0
 4ea:	276080e7          	jalr	630(ra) # 75c <exit>

00000000000004ee <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 4ee:	1141                	addi	sp,sp,-16
 4f0:	e422                	sd	s0,8(sp)
 4f2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4f4:	87aa                	mv	a5,a0
 4f6:	0585                	addi	a1,a1,1
 4f8:	0785                	addi	a5,a5,1
 4fa:	fff5c703          	lbu	a4,-1(a1)
 4fe:	fee78fa3          	sb	a4,-1(a5)
 502:	fb75                	bnez	a4,4f6 <strcpy+0x8>
    ;
  return os;
}
 504:	6422                	ld	s0,8(sp)
 506:	0141                	addi	sp,sp,16
 508:	8082                	ret

000000000000050a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 50a:	1141                	addi	sp,sp,-16
 50c:	e422                	sd	s0,8(sp)
 50e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 510:	00054783          	lbu	a5,0(a0)
 514:	cb91                	beqz	a5,528 <strcmp+0x1e>
 516:	0005c703          	lbu	a4,0(a1)
 51a:	00f71763          	bne	a4,a5,528 <strcmp+0x1e>
    p++, q++;
 51e:	0505                	addi	a0,a0,1
 520:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 522:	00054783          	lbu	a5,0(a0)
 526:	fbe5                	bnez	a5,516 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 528:	0005c503          	lbu	a0,0(a1)
}
 52c:	40a7853b          	subw	a0,a5,a0
 530:	6422                	ld	s0,8(sp)
 532:	0141                	addi	sp,sp,16
 534:	8082                	ret

0000000000000536 <strlen>:

uint
strlen(const char *s)
{
 536:	1141                	addi	sp,sp,-16
 538:	e422                	sd	s0,8(sp)
 53a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 53c:	00054783          	lbu	a5,0(a0)
 540:	cf91                	beqz	a5,55c <strlen+0x26>
 542:	0505                	addi	a0,a0,1
 544:	87aa                	mv	a5,a0
 546:	4685                	li	a3,1
 548:	9e89                	subw	a3,a3,a0
 54a:	00f6853b          	addw	a0,a3,a5
 54e:	0785                	addi	a5,a5,1
 550:	fff7c703          	lbu	a4,-1(a5)
 554:	fb7d                	bnez	a4,54a <strlen+0x14>
    ;
  return n;
}
 556:	6422                	ld	s0,8(sp)
 558:	0141                	addi	sp,sp,16
 55a:	8082                	ret
  for(n = 0; s[n]; n++)
 55c:	4501                	li	a0,0
 55e:	bfe5                	j	556 <strlen+0x20>

0000000000000560 <memset>:

void*
memset(void *dst, int c, uint n)
{
 560:	1141                	addi	sp,sp,-16
 562:	e422                	sd	s0,8(sp)
 564:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 566:	ca19                	beqz	a2,57c <memset+0x1c>
 568:	87aa                	mv	a5,a0
 56a:	1602                	slli	a2,a2,0x20
 56c:	9201                	srli	a2,a2,0x20
 56e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 572:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 576:	0785                	addi	a5,a5,1
 578:	fee79de3          	bne	a5,a4,572 <memset+0x12>
  }
  return dst;
}
 57c:	6422                	ld	s0,8(sp)
 57e:	0141                	addi	sp,sp,16
 580:	8082                	ret

0000000000000582 <strchr>:

char*
strchr(const char *s, char c)
{
 582:	1141                	addi	sp,sp,-16
 584:	e422                	sd	s0,8(sp)
 586:	0800                	addi	s0,sp,16
  for(; *s; s++)
 588:	00054783          	lbu	a5,0(a0)
 58c:	cb99                	beqz	a5,5a2 <strchr+0x20>
    if(*s == c)
 58e:	00f58763          	beq	a1,a5,59c <strchr+0x1a>
  for(; *s; s++)
 592:	0505                	addi	a0,a0,1
 594:	00054783          	lbu	a5,0(a0)
 598:	fbfd                	bnez	a5,58e <strchr+0xc>
      return (char*)s;
  return 0;
 59a:	4501                	li	a0,0
}
 59c:	6422                	ld	s0,8(sp)
 59e:	0141                	addi	sp,sp,16
 5a0:	8082                	ret
  return 0;
 5a2:	4501                	li	a0,0
 5a4:	bfe5                	j	59c <strchr+0x1a>

00000000000005a6 <gets>:

char*
gets(char *buf, int max)
{
 5a6:	711d                	addi	sp,sp,-96
 5a8:	ec86                	sd	ra,88(sp)
 5aa:	e8a2                	sd	s0,80(sp)
 5ac:	e4a6                	sd	s1,72(sp)
 5ae:	e0ca                	sd	s2,64(sp)
 5b0:	fc4e                	sd	s3,56(sp)
 5b2:	f852                	sd	s4,48(sp)
 5b4:	f456                	sd	s5,40(sp)
 5b6:	f05a                	sd	s6,32(sp)
 5b8:	ec5e                	sd	s7,24(sp)
 5ba:	1080                	addi	s0,sp,96
 5bc:	8baa                	mv	s7,a0
 5be:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5c0:	892a                	mv	s2,a0
 5c2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 5c4:	4aa9                	li	s5,10
 5c6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 5c8:	89a6                	mv	s3,s1
 5ca:	2485                	addiw	s1,s1,1
 5cc:	0344d863          	bge	s1,s4,5fc <gets+0x56>
    cc = read(0, &c, 1);
 5d0:	4605                	li	a2,1
 5d2:	faf40593          	addi	a1,s0,-81
 5d6:	4501                	li	a0,0
 5d8:	00000097          	auipc	ra,0x0
 5dc:	19c080e7          	jalr	412(ra) # 774 <read>
    if(cc < 1)
 5e0:	00a05e63          	blez	a0,5fc <gets+0x56>
    buf[i++] = c;
 5e4:	faf44783          	lbu	a5,-81(s0)
 5e8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5ec:	01578763          	beq	a5,s5,5fa <gets+0x54>
 5f0:	0905                	addi	s2,s2,1
 5f2:	fd679be3          	bne	a5,s6,5c8 <gets+0x22>
  for(i=0; i+1 < max; ){
 5f6:	89a6                	mv	s3,s1
 5f8:	a011                	j	5fc <gets+0x56>
 5fa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5fc:	99de                	add	s3,s3,s7
 5fe:	00098023          	sb	zero,0(s3) # 199a000 <base+0x1994ff0>
  return buf;
}
 602:	855e                	mv	a0,s7
 604:	60e6                	ld	ra,88(sp)
 606:	6446                	ld	s0,80(sp)
 608:	64a6                	ld	s1,72(sp)
 60a:	6906                	ld	s2,64(sp)
 60c:	79e2                	ld	s3,56(sp)
 60e:	7a42                	ld	s4,48(sp)
 610:	7aa2                	ld	s5,40(sp)
 612:	7b02                	ld	s6,32(sp)
 614:	6be2                	ld	s7,24(sp)
 616:	6125                	addi	sp,sp,96
 618:	8082                	ret

000000000000061a <stat>:

int
stat(const char *n, struct stat *st)
{
 61a:	1101                	addi	sp,sp,-32
 61c:	ec06                	sd	ra,24(sp)
 61e:	e822                	sd	s0,16(sp)
 620:	e426                	sd	s1,8(sp)
 622:	e04a                	sd	s2,0(sp)
 624:	1000                	addi	s0,sp,32
 626:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 628:	4581                	li	a1,0
 62a:	00000097          	auipc	ra,0x0
 62e:	172080e7          	jalr	370(ra) # 79c <open>
  if(fd < 0)
 632:	02054563          	bltz	a0,65c <stat+0x42>
 636:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 638:	85ca                	mv	a1,s2
 63a:	00000097          	auipc	ra,0x0
 63e:	17a080e7          	jalr	378(ra) # 7b4 <fstat>
 642:	892a                	mv	s2,a0
  close(fd);
 644:	8526                	mv	a0,s1
 646:	00000097          	auipc	ra,0x0
 64a:	13e080e7          	jalr	318(ra) # 784 <close>
  return r;
}
 64e:	854a                	mv	a0,s2
 650:	60e2                	ld	ra,24(sp)
 652:	6442                	ld	s0,16(sp)
 654:	64a2                	ld	s1,8(sp)
 656:	6902                	ld	s2,0(sp)
 658:	6105                	addi	sp,sp,32
 65a:	8082                	ret
    return -1;
 65c:	597d                	li	s2,-1
 65e:	bfc5                	j	64e <stat+0x34>

0000000000000660 <atoi>:

int
atoi(const char *s)
{
 660:	1141                	addi	sp,sp,-16
 662:	e422                	sd	s0,8(sp)
 664:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 666:	00054603          	lbu	a2,0(a0)
 66a:	fd06079b          	addiw	a5,a2,-48
 66e:	0ff7f793          	andi	a5,a5,255
 672:	4725                	li	a4,9
 674:	02f76963          	bltu	a4,a5,6a6 <atoi+0x46>
 678:	86aa                	mv	a3,a0
  n = 0;
 67a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 67c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 67e:	0685                	addi	a3,a3,1
 680:	0025179b          	slliw	a5,a0,0x2
 684:	9fa9                	addw	a5,a5,a0
 686:	0017979b          	slliw	a5,a5,0x1
 68a:	9fb1                	addw	a5,a5,a2
 68c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 690:	0006c603          	lbu	a2,0(a3) # 1000 <fds>
 694:	fd06071b          	addiw	a4,a2,-48
 698:	0ff77713          	andi	a4,a4,255
 69c:	fee5f1e3          	bgeu	a1,a4,67e <atoi+0x1e>
  return n;
}
 6a0:	6422                	ld	s0,8(sp)
 6a2:	0141                	addi	sp,sp,16
 6a4:	8082                	ret
  n = 0;
 6a6:	4501                	li	a0,0
 6a8:	bfe5                	j	6a0 <atoi+0x40>

00000000000006aa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6aa:	1141                	addi	sp,sp,-16
 6ac:	e422                	sd	s0,8(sp)
 6ae:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6b0:	02b57463          	bgeu	a0,a1,6d8 <memmove+0x2e>
    while(n-- > 0)
 6b4:	00c05f63          	blez	a2,6d2 <memmove+0x28>
 6b8:	1602                	slli	a2,a2,0x20
 6ba:	9201                	srli	a2,a2,0x20
 6bc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6c0:	872a                	mv	a4,a0
      *dst++ = *src++;
 6c2:	0585                	addi	a1,a1,1
 6c4:	0705                	addi	a4,a4,1
 6c6:	fff5c683          	lbu	a3,-1(a1)
 6ca:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 6ce:	fee79ae3          	bne	a5,a4,6c2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 6d2:	6422                	ld	s0,8(sp)
 6d4:	0141                	addi	sp,sp,16
 6d6:	8082                	ret
    dst += n;
 6d8:	00c50733          	add	a4,a0,a2
    src += n;
 6dc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 6de:	fec05ae3          	blez	a2,6d2 <memmove+0x28>
 6e2:	fff6079b          	addiw	a5,a2,-1
 6e6:	1782                	slli	a5,a5,0x20
 6e8:	9381                	srli	a5,a5,0x20
 6ea:	fff7c793          	not	a5,a5
 6ee:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 6f0:	15fd                	addi	a1,a1,-1
 6f2:	177d                	addi	a4,a4,-1
 6f4:	0005c683          	lbu	a3,0(a1)
 6f8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 6fc:	fee79ae3          	bne	a5,a4,6f0 <memmove+0x46>
 700:	bfc9                	j	6d2 <memmove+0x28>

0000000000000702 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 702:	1141                	addi	sp,sp,-16
 704:	e422                	sd	s0,8(sp)
 706:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 708:	ca05                	beqz	a2,738 <memcmp+0x36>
 70a:	fff6069b          	addiw	a3,a2,-1
 70e:	1682                	slli	a3,a3,0x20
 710:	9281                	srli	a3,a3,0x20
 712:	0685                	addi	a3,a3,1
 714:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 716:	00054783          	lbu	a5,0(a0)
 71a:	0005c703          	lbu	a4,0(a1)
 71e:	00e79863          	bne	a5,a4,72e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 722:	0505                	addi	a0,a0,1
    p2++;
 724:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 726:	fed518e3          	bne	a0,a3,716 <memcmp+0x14>
  }
  return 0;
 72a:	4501                	li	a0,0
 72c:	a019                	j	732 <memcmp+0x30>
      return *p1 - *p2;
 72e:	40e7853b          	subw	a0,a5,a4
}
 732:	6422                	ld	s0,8(sp)
 734:	0141                	addi	sp,sp,16
 736:	8082                	ret
  return 0;
 738:	4501                	li	a0,0
 73a:	bfe5                	j	732 <memcmp+0x30>

000000000000073c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 73c:	1141                	addi	sp,sp,-16
 73e:	e406                	sd	ra,8(sp)
 740:	e022                	sd	s0,0(sp)
 742:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 744:	00000097          	auipc	ra,0x0
 748:	f66080e7          	jalr	-154(ra) # 6aa <memmove>
}
 74c:	60a2                	ld	ra,8(sp)
 74e:	6402                	ld	s0,0(sp)
 750:	0141                	addi	sp,sp,16
 752:	8082                	ret

0000000000000754 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 754:	4885                	li	a7,1
 ecall
 756:	00000073          	ecall
 ret
 75a:	8082                	ret

000000000000075c <exit>:
.global exit
exit:
 li a7, SYS_exit
 75c:	4889                	li	a7,2
 ecall
 75e:	00000073          	ecall
 ret
 762:	8082                	ret

0000000000000764 <wait>:
.global wait
wait:
 li a7, SYS_wait
 764:	488d                	li	a7,3
 ecall
 766:	00000073          	ecall
 ret
 76a:	8082                	ret

000000000000076c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 76c:	4891                	li	a7,4
 ecall
 76e:	00000073          	ecall
 ret
 772:	8082                	ret

0000000000000774 <read>:
.global read
read:
 li a7, SYS_read
 774:	4895                	li	a7,5
 ecall
 776:	00000073          	ecall
 ret
 77a:	8082                	ret

000000000000077c <write>:
.global write
write:
 li a7, SYS_write
 77c:	48c1                	li	a7,16
 ecall
 77e:	00000073          	ecall
 ret
 782:	8082                	ret

0000000000000784 <close>:
.global close
close:
 li a7, SYS_close
 784:	48d5                	li	a7,21
 ecall
 786:	00000073          	ecall
 ret
 78a:	8082                	ret

000000000000078c <kill>:
.global kill
kill:
 li a7, SYS_kill
 78c:	4899                	li	a7,6
 ecall
 78e:	00000073          	ecall
 ret
 792:	8082                	ret

0000000000000794 <exec>:
.global exec
exec:
 li a7, SYS_exec
 794:	489d                	li	a7,7
 ecall
 796:	00000073          	ecall
 ret
 79a:	8082                	ret

000000000000079c <open>:
.global open
open:
 li a7, SYS_open
 79c:	48bd                	li	a7,15
 ecall
 79e:	00000073          	ecall
 ret
 7a2:	8082                	ret

00000000000007a4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7a4:	48c5                	li	a7,17
 ecall
 7a6:	00000073          	ecall
 ret
 7aa:	8082                	ret

00000000000007ac <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7ac:	48c9                	li	a7,18
 ecall
 7ae:	00000073          	ecall
 ret
 7b2:	8082                	ret

00000000000007b4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7b4:	48a1                	li	a7,8
 ecall
 7b6:	00000073          	ecall
 ret
 7ba:	8082                	ret

00000000000007bc <link>:
.global link
link:
 li a7, SYS_link
 7bc:	48cd                	li	a7,19
 ecall
 7be:	00000073          	ecall
 ret
 7c2:	8082                	ret

00000000000007c4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7c4:	48d1                	li	a7,20
 ecall
 7c6:	00000073          	ecall
 ret
 7ca:	8082                	ret

00000000000007cc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 7cc:	48a5                	li	a7,9
 ecall
 7ce:	00000073          	ecall
 ret
 7d2:	8082                	ret

00000000000007d4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 7d4:	48a9                	li	a7,10
 ecall
 7d6:	00000073          	ecall
 ret
 7da:	8082                	ret

00000000000007dc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7dc:	48ad                	li	a7,11
 ecall
 7de:	00000073          	ecall
 ret
 7e2:	8082                	ret

00000000000007e4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 7e4:	48b1                	li	a7,12
 ecall
 7e6:	00000073          	ecall
 ret
 7ea:	8082                	ret

00000000000007ec <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 7ec:	48b5                	li	a7,13
 ecall
 7ee:	00000073          	ecall
 ret
 7f2:	8082                	ret

00000000000007f4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 7f4:	48b9                	li	a7,14
 ecall
 7f6:	00000073          	ecall
 ret
 7fa:	8082                	ret

00000000000007fc <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 7fc:	48d9                	li	a7,22
 ecall
 7fe:	00000073          	ecall
 ret
 802:	8082                	ret

0000000000000804 <getreadcount>:
.global getreadcount
getreadcount:
 li a7, SYS_getreadcount
 804:	48dd                	li	a7,23
 ecall
 806:	00000073          	ecall
 ret
 80a:	8082                	ret

000000000000080c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 80c:	1101                	addi	sp,sp,-32
 80e:	ec06                	sd	ra,24(sp)
 810:	e822                	sd	s0,16(sp)
 812:	1000                	addi	s0,sp,32
 814:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 818:	4605                	li	a2,1
 81a:	fef40593          	addi	a1,s0,-17
 81e:	00000097          	auipc	ra,0x0
 822:	f5e080e7          	jalr	-162(ra) # 77c <write>
}
 826:	60e2                	ld	ra,24(sp)
 828:	6442                	ld	s0,16(sp)
 82a:	6105                	addi	sp,sp,32
 82c:	8082                	ret

000000000000082e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 82e:	7139                	addi	sp,sp,-64
 830:	fc06                	sd	ra,56(sp)
 832:	f822                	sd	s0,48(sp)
 834:	f426                	sd	s1,40(sp)
 836:	f04a                	sd	s2,32(sp)
 838:	ec4e                	sd	s3,24(sp)
 83a:	0080                	addi	s0,sp,64
 83c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 83e:	c299                	beqz	a3,844 <printint+0x16>
 840:	0805c863          	bltz	a1,8d0 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 844:	2581                	sext.w	a1,a1
  neg = 0;
 846:	4881                	li	a7,0
 848:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 84c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 84e:	2601                	sext.w	a2,a2
 850:	00000517          	auipc	a0,0x0
 854:	57850513          	addi	a0,a0,1400 # dc8 <digits>
 858:	883a                	mv	a6,a4
 85a:	2705                	addiw	a4,a4,1
 85c:	02c5f7bb          	remuw	a5,a1,a2
 860:	1782                	slli	a5,a5,0x20
 862:	9381                	srli	a5,a5,0x20
 864:	97aa                	add	a5,a5,a0
 866:	0007c783          	lbu	a5,0(a5)
 86a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 86e:	0005879b          	sext.w	a5,a1
 872:	02c5d5bb          	divuw	a1,a1,a2
 876:	0685                	addi	a3,a3,1
 878:	fec7f0e3          	bgeu	a5,a2,858 <printint+0x2a>
  if(neg)
 87c:	00088b63          	beqz	a7,892 <printint+0x64>
    buf[i++] = '-';
 880:	fd040793          	addi	a5,s0,-48
 884:	973e                	add	a4,a4,a5
 886:	02d00793          	li	a5,45
 88a:	fef70823          	sb	a5,-16(a4)
 88e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 892:	02e05863          	blez	a4,8c2 <printint+0x94>
 896:	fc040793          	addi	a5,s0,-64
 89a:	00e78933          	add	s2,a5,a4
 89e:	fff78993          	addi	s3,a5,-1
 8a2:	99ba                	add	s3,s3,a4
 8a4:	377d                	addiw	a4,a4,-1
 8a6:	1702                	slli	a4,a4,0x20
 8a8:	9301                	srli	a4,a4,0x20
 8aa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 8ae:	fff94583          	lbu	a1,-1(s2)
 8b2:	8526                	mv	a0,s1
 8b4:	00000097          	auipc	ra,0x0
 8b8:	f58080e7          	jalr	-168(ra) # 80c <putc>
  while(--i >= 0)
 8bc:	197d                	addi	s2,s2,-1
 8be:	ff3918e3          	bne	s2,s3,8ae <printint+0x80>
}
 8c2:	70e2                	ld	ra,56(sp)
 8c4:	7442                	ld	s0,48(sp)
 8c6:	74a2                	ld	s1,40(sp)
 8c8:	7902                	ld	s2,32(sp)
 8ca:	69e2                	ld	s3,24(sp)
 8cc:	6121                	addi	sp,sp,64
 8ce:	8082                	ret
    x = -xx;
 8d0:	40b005bb          	negw	a1,a1
    neg = 1;
 8d4:	4885                	li	a7,1
    x = -xx;
 8d6:	bf8d                	j	848 <printint+0x1a>

00000000000008d8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8d8:	7119                	addi	sp,sp,-128
 8da:	fc86                	sd	ra,120(sp)
 8dc:	f8a2                	sd	s0,112(sp)
 8de:	f4a6                	sd	s1,104(sp)
 8e0:	f0ca                	sd	s2,96(sp)
 8e2:	ecce                	sd	s3,88(sp)
 8e4:	e8d2                	sd	s4,80(sp)
 8e6:	e4d6                	sd	s5,72(sp)
 8e8:	e0da                	sd	s6,64(sp)
 8ea:	fc5e                	sd	s7,56(sp)
 8ec:	f862                	sd	s8,48(sp)
 8ee:	f466                	sd	s9,40(sp)
 8f0:	f06a                	sd	s10,32(sp)
 8f2:	ec6e                	sd	s11,24(sp)
 8f4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8f6:	0005c903          	lbu	s2,0(a1)
 8fa:	18090f63          	beqz	s2,a98 <vprintf+0x1c0>
 8fe:	8aaa                	mv	s5,a0
 900:	8b32                	mv	s6,a2
 902:	00158493          	addi	s1,a1,1
  state = 0;
 906:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 908:	02500a13          	li	s4,37
      if(c == 'd'){
 90c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 910:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 914:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 918:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 91c:	00000b97          	auipc	s7,0x0
 920:	4acb8b93          	addi	s7,s7,1196 # dc8 <digits>
 924:	a839                	j	942 <vprintf+0x6a>
        putc(fd, c);
 926:	85ca                	mv	a1,s2
 928:	8556                	mv	a0,s5
 92a:	00000097          	auipc	ra,0x0
 92e:	ee2080e7          	jalr	-286(ra) # 80c <putc>
 932:	a019                	j	938 <vprintf+0x60>
    } else if(state == '%'){
 934:	01498f63          	beq	s3,s4,952 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 938:	0485                	addi	s1,s1,1
 93a:	fff4c903          	lbu	s2,-1(s1)
 93e:	14090d63          	beqz	s2,a98 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 942:	0009079b          	sext.w	a5,s2
    if(state == 0){
 946:	fe0997e3          	bnez	s3,934 <vprintf+0x5c>
      if(c == '%'){
 94a:	fd479ee3          	bne	a5,s4,926 <vprintf+0x4e>
        state = '%';
 94e:	89be                	mv	s3,a5
 950:	b7e5                	j	938 <vprintf+0x60>
      if(c == 'd'){
 952:	05878063          	beq	a5,s8,992 <vprintf+0xba>
      } else if(c == 'l') {
 956:	05978c63          	beq	a5,s9,9ae <vprintf+0xd6>
      } else if(c == 'x') {
 95a:	07a78863          	beq	a5,s10,9ca <vprintf+0xf2>
      } else if(c == 'p') {
 95e:	09b78463          	beq	a5,s11,9e6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 962:	07300713          	li	a4,115
 966:	0ce78663          	beq	a5,a4,a32 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 96a:	06300713          	li	a4,99
 96e:	0ee78e63          	beq	a5,a4,a6a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 972:	11478863          	beq	a5,s4,a82 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 976:	85d2                	mv	a1,s4
 978:	8556                	mv	a0,s5
 97a:	00000097          	auipc	ra,0x0
 97e:	e92080e7          	jalr	-366(ra) # 80c <putc>
        putc(fd, c);
 982:	85ca                	mv	a1,s2
 984:	8556                	mv	a0,s5
 986:	00000097          	auipc	ra,0x0
 98a:	e86080e7          	jalr	-378(ra) # 80c <putc>
      }
      state = 0;
 98e:	4981                	li	s3,0
 990:	b765                	j	938 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 992:	008b0913          	addi	s2,s6,8
 996:	4685                	li	a3,1
 998:	4629                	li	a2,10
 99a:	000b2583          	lw	a1,0(s6)
 99e:	8556                	mv	a0,s5
 9a0:	00000097          	auipc	ra,0x0
 9a4:	e8e080e7          	jalr	-370(ra) # 82e <printint>
 9a8:	8b4a                	mv	s6,s2
      state = 0;
 9aa:	4981                	li	s3,0
 9ac:	b771                	j	938 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9ae:	008b0913          	addi	s2,s6,8
 9b2:	4681                	li	a3,0
 9b4:	4629                	li	a2,10
 9b6:	000b2583          	lw	a1,0(s6)
 9ba:	8556                	mv	a0,s5
 9bc:	00000097          	auipc	ra,0x0
 9c0:	e72080e7          	jalr	-398(ra) # 82e <printint>
 9c4:	8b4a                	mv	s6,s2
      state = 0;
 9c6:	4981                	li	s3,0
 9c8:	bf85                	j	938 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 9ca:	008b0913          	addi	s2,s6,8
 9ce:	4681                	li	a3,0
 9d0:	4641                	li	a2,16
 9d2:	000b2583          	lw	a1,0(s6)
 9d6:	8556                	mv	a0,s5
 9d8:	00000097          	auipc	ra,0x0
 9dc:	e56080e7          	jalr	-426(ra) # 82e <printint>
 9e0:	8b4a                	mv	s6,s2
      state = 0;
 9e2:	4981                	li	s3,0
 9e4:	bf91                	j	938 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 9e6:	008b0793          	addi	a5,s6,8
 9ea:	f8f43423          	sd	a5,-120(s0)
 9ee:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 9f2:	03000593          	li	a1,48
 9f6:	8556                	mv	a0,s5
 9f8:	00000097          	auipc	ra,0x0
 9fc:	e14080e7          	jalr	-492(ra) # 80c <putc>
  putc(fd, 'x');
 a00:	85ea                	mv	a1,s10
 a02:	8556                	mv	a0,s5
 a04:	00000097          	auipc	ra,0x0
 a08:	e08080e7          	jalr	-504(ra) # 80c <putc>
 a0c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a0e:	03c9d793          	srli	a5,s3,0x3c
 a12:	97de                	add	a5,a5,s7
 a14:	0007c583          	lbu	a1,0(a5)
 a18:	8556                	mv	a0,s5
 a1a:	00000097          	auipc	ra,0x0
 a1e:	df2080e7          	jalr	-526(ra) # 80c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a22:	0992                	slli	s3,s3,0x4
 a24:	397d                	addiw	s2,s2,-1
 a26:	fe0914e3          	bnez	s2,a0e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 a2a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 a2e:	4981                	li	s3,0
 a30:	b721                	j	938 <vprintf+0x60>
        s = va_arg(ap, char*);
 a32:	008b0993          	addi	s3,s6,8
 a36:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 a3a:	02090163          	beqz	s2,a5c <vprintf+0x184>
        while(*s != 0){
 a3e:	00094583          	lbu	a1,0(s2)
 a42:	c9a1                	beqz	a1,a92 <vprintf+0x1ba>
          putc(fd, *s);
 a44:	8556                	mv	a0,s5
 a46:	00000097          	auipc	ra,0x0
 a4a:	dc6080e7          	jalr	-570(ra) # 80c <putc>
          s++;
 a4e:	0905                	addi	s2,s2,1
        while(*s != 0){
 a50:	00094583          	lbu	a1,0(s2)
 a54:	f9e5                	bnez	a1,a44 <vprintf+0x16c>
        s = va_arg(ap, char*);
 a56:	8b4e                	mv	s6,s3
      state = 0;
 a58:	4981                	li	s3,0
 a5a:	bdf9                	j	938 <vprintf+0x60>
          s = "(null)";
 a5c:	00000917          	auipc	s2,0x0
 a60:	36490913          	addi	s2,s2,868 # dc0 <malloc+0x21e>
        while(*s != 0){
 a64:	02800593          	li	a1,40
 a68:	bff1                	j	a44 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 a6a:	008b0913          	addi	s2,s6,8
 a6e:	000b4583          	lbu	a1,0(s6)
 a72:	8556                	mv	a0,s5
 a74:	00000097          	auipc	ra,0x0
 a78:	d98080e7          	jalr	-616(ra) # 80c <putc>
 a7c:	8b4a                	mv	s6,s2
      state = 0;
 a7e:	4981                	li	s3,0
 a80:	bd65                	j	938 <vprintf+0x60>
        putc(fd, c);
 a82:	85d2                	mv	a1,s4
 a84:	8556                	mv	a0,s5
 a86:	00000097          	auipc	ra,0x0
 a8a:	d86080e7          	jalr	-634(ra) # 80c <putc>
      state = 0;
 a8e:	4981                	li	s3,0
 a90:	b565                	j	938 <vprintf+0x60>
        s = va_arg(ap, char*);
 a92:	8b4e                	mv	s6,s3
      state = 0;
 a94:	4981                	li	s3,0
 a96:	b54d                	j	938 <vprintf+0x60>
    }
  }
}
 a98:	70e6                	ld	ra,120(sp)
 a9a:	7446                	ld	s0,112(sp)
 a9c:	74a6                	ld	s1,104(sp)
 a9e:	7906                	ld	s2,96(sp)
 aa0:	69e6                	ld	s3,88(sp)
 aa2:	6a46                	ld	s4,80(sp)
 aa4:	6aa6                	ld	s5,72(sp)
 aa6:	6b06                	ld	s6,64(sp)
 aa8:	7be2                	ld	s7,56(sp)
 aaa:	7c42                	ld	s8,48(sp)
 aac:	7ca2                	ld	s9,40(sp)
 aae:	7d02                	ld	s10,32(sp)
 ab0:	6de2                	ld	s11,24(sp)
 ab2:	6109                	addi	sp,sp,128
 ab4:	8082                	ret

0000000000000ab6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 ab6:	715d                	addi	sp,sp,-80
 ab8:	ec06                	sd	ra,24(sp)
 aba:	e822                	sd	s0,16(sp)
 abc:	1000                	addi	s0,sp,32
 abe:	e010                	sd	a2,0(s0)
 ac0:	e414                	sd	a3,8(s0)
 ac2:	e818                	sd	a4,16(s0)
 ac4:	ec1c                	sd	a5,24(s0)
 ac6:	03043023          	sd	a6,32(s0)
 aca:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 ace:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 ad2:	8622                	mv	a2,s0
 ad4:	00000097          	auipc	ra,0x0
 ad8:	e04080e7          	jalr	-508(ra) # 8d8 <vprintf>
}
 adc:	60e2                	ld	ra,24(sp)
 ade:	6442                	ld	s0,16(sp)
 ae0:	6161                	addi	sp,sp,80
 ae2:	8082                	ret

0000000000000ae4 <printf>:

void
printf(const char *fmt, ...)
{
 ae4:	711d                	addi	sp,sp,-96
 ae6:	ec06                	sd	ra,24(sp)
 ae8:	e822                	sd	s0,16(sp)
 aea:	1000                	addi	s0,sp,32
 aec:	e40c                	sd	a1,8(s0)
 aee:	e810                	sd	a2,16(s0)
 af0:	ec14                	sd	a3,24(s0)
 af2:	f018                	sd	a4,32(s0)
 af4:	f41c                	sd	a5,40(s0)
 af6:	03043823          	sd	a6,48(s0)
 afa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 afe:	00840613          	addi	a2,s0,8
 b02:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b06:	85aa                	mv	a1,a0
 b08:	4505                	li	a0,1
 b0a:	00000097          	auipc	ra,0x0
 b0e:	dce080e7          	jalr	-562(ra) # 8d8 <vprintf>
}
 b12:	60e2                	ld	ra,24(sp)
 b14:	6442                	ld	s0,16(sp)
 b16:	6125                	addi	sp,sp,96
 b18:	8082                	ret

0000000000000b1a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b1a:	1141                	addi	sp,sp,-16
 b1c:	e422                	sd	s0,8(sp)
 b1e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b20:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b24:	00000797          	auipc	a5,0x0
 b28:	4e47b783          	ld	a5,1252(a5) # 1008 <freep>
 b2c:	a805                	j	b5c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b2e:	4618                	lw	a4,8(a2)
 b30:	9db9                	addw	a1,a1,a4
 b32:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b36:	6398                	ld	a4,0(a5)
 b38:	6318                	ld	a4,0(a4)
 b3a:	fee53823          	sd	a4,-16(a0)
 b3e:	a091                	j	b82 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b40:	ff852703          	lw	a4,-8(a0)
 b44:	9e39                	addw	a2,a2,a4
 b46:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 b48:	ff053703          	ld	a4,-16(a0)
 b4c:	e398                	sd	a4,0(a5)
 b4e:	a099                	j	b94 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b50:	6398                	ld	a4,0(a5)
 b52:	00e7e463          	bltu	a5,a4,b5a <free+0x40>
 b56:	00e6ea63          	bltu	a3,a4,b6a <free+0x50>
{
 b5a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b5c:	fed7fae3          	bgeu	a5,a3,b50 <free+0x36>
 b60:	6398                	ld	a4,0(a5)
 b62:	00e6e463          	bltu	a3,a4,b6a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b66:	fee7eae3          	bltu	a5,a4,b5a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 b6a:	ff852583          	lw	a1,-8(a0)
 b6e:	6390                	ld	a2,0(a5)
 b70:	02059713          	slli	a4,a1,0x20
 b74:	9301                	srli	a4,a4,0x20
 b76:	0712                	slli	a4,a4,0x4
 b78:	9736                	add	a4,a4,a3
 b7a:	fae60ae3          	beq	a2,a4,b2e <free+0x14>
    bp->s.ptr = p->s.ptr;
 b7e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b82:	4790                	lw	a2,8(a5)
 b84:	02061713          	slli	a4,a2,0x20
 b88:	9301                	srli	a4,a4,0x20
 b8a:	0712                	slli	a4,a4,0x4
 b8c:	973e                	add	a4,a4,a5
 b8e:	fae689e3          	beq	a3,a4,b40 <free+0x26>
  } else
    p->s.ptr = bp;
 b92:	e394                	sd	a3,0(a5)
  freep = p;
 b94:	00000717          	auipc	a4,0x0
 b98:	46f73a23          	sd	a5,1140(a4) # 1008 <freep>
}
 b9c:	6422                	ld	s0,8(sp)
 b9e:	0141                	addi	sp,sp,16
 ba0:	8082                	ret

0000000000000ba2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ba2:	7139                	addi	sp,sp,-64
 ba4:	fc06                	sd	ra,56(sp)
 ba6:	f822                	sd	s0,48(sp)
 ba8:	f426                	sd	s1,40(sp)
 baa:	f04a                	sd	s2,32(sp)
 bac:	ec4e                	sd	s3,24(sp)
 bae:	e852                	sd	s4,16(sp)
 bb0:	e456                	sd	s5,8(sp)
 bb2:	e05a                	sd	s6,0(sp)
 bb4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bb6:	02051493          	slli	s1,a0,0x20
 bba:	9081                	srli	s1,s1,0x20
 bbc:	04bd                	addi	s1,s1,15
 bbe:	8091                	srli	s1,s1,0x4
 bc0:	0014899b          	addiw	s3,s1,1
 bc4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 bc6:	00000517          	auipc	a0,0x0
 bca:	44253503          	ld	a0,1090(a0) # 1008 <freep>
 bce:	c515                	beqz	a0,bfa <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bd0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bd2:	4798                	lw	a4,8(a5)
 bd4:	02977f63          	bgeu	a4,s1,c12 <malloc+0x70>
 bd8:	8a4e                	mv	s4,s3
 bda:	0009871b          	sext.w	a4,s3
 bde:	6685                	lui	a3,0x1
 be0:	00d77363          	bgeu	a4,a3,be6 <malloc+0x44>
 be4:	6a05                	lui	s4,0x1
 be6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 bea:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bee:	00000917          	auipc	s2,0x0
 bf2:	41a90913          	addi	s2,s2,1050 # 1008 <freep>
  if(p == (char*)-1)
 bf6:	5afd                	li	s5,-1
 bf8:	a88d                	j	c6a <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 bfa:	00004797          	auipc	a5,0x4
 bfe:	41678793          	addi	a5,a5,1046 # 5010 <base>
 c02:	00000717          	auipc	a4,0x0
 c06:	40f73323          	sd	a5,1030(a4) # 1008 <freep>
 c0a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c0c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c10:	b7e1                	j	bd8 <malloc+0x36>
      if(p->s.size == nunits)
 c12:	02e48b63          	beq	s1,a4,c48 <malloc+0xa6>
        p->s.size -= nunits;
 c16:	4137073b          	subw	a4,a4,s3
 c1a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c1c:	1702                	slli	a4,a4,0x20
 c1e:	9301                	srli	a4,a4,0x20
 c20:	0712                	slli	a4,a4,0x4
 c22:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c24:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c28:	00000717          	auipc	a4,0x0
 c2c:	3ea73023          	sd	a0,992(a4) # 1008 <freep>
      return (void*)(p + 1);
 c30:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 c34:	70e2                	ld	ra,56(sp)
 c36:	7442                	ld	s0,48(sp)
 c38:	74a2                	ld	s1,40(sp)
 c3a:	7902                	ld	s2,32(sp)
 c3c:	69e2                	ld	s3,24(sp)
 c3e:	6a42                	ld	s4,16(sp)
 c40:	6aa2                	ld	s5,8(sp)
 c42:	6b02                	ld	s6,0(sp)
 c44:	6121                	addi	sp,sp,64
 c46:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 c48:	6398                	ld	a4,0(a5)
 c4a:	e118                	sd	a4,0(a0)
 c4c:	bff1                	j	c28 <malloc+0x86>
  hp->s.size = nu;
 c4e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c52:	0541                	addi	a0,a0,16
 c54:	00000097          	auipc	ra,0x0
 c58:	ec6080e7          	jalr	-314(ra) # b1a <free>
  return freep;
 c5c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c60:	d971                	beqz	a0,c34 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c62:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c64:	4798                	lw	a4,8(a5)
 c66:	fa9776e3          	bgeu	a4,s1,c12 <malloc+0x70>
    if(p == freep)
 c6a:	00093703          	ld	a4,0(s2)
 c6e:	853e                	mv	a0,a5
 c70:	fef719e3          	bne	a4,a5,c62 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 c74:	8552                	mv	a0,s4
 c76:	00000097          	auipc	ra,0x0
 c7a:	b6e080e7          	jalr	-1170(ra) # 7e4 <sbrk>
  if(p == (char*)-1)
 c7e:	fd5518e3          	bne	a0,s5,c4e <malloc+0xac>
        return 0;
 c82:	4501                	li	a0,0
 c84:	bf45                	j	c34 <malloc+0x92>
