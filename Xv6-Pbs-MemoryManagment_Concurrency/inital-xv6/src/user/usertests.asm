
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	bf6080e7          	jalr	-1034(ra) # 5c06 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	be4080e7          	jalr	-1052(ra) # 5c06 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	0d250513          	addi	a0,a0,210 # 6110 <malloc+0x104>
      46:	00006097          	auipc	ra,0x6
      4a:	f08080e7          	jalr	-248(ra) # 5f4e <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	b76080e7          	jalr	-1162(ra) # 5bc6 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000a797          	auipc	a5,0xa
      5c:	4f078793          	addi	a5,a5,1264 # a548 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	bf868693          	addi	a3,a3,-1032 # cc58 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	0b050513          	addi	a0,a0,176 # 6130 <malloc+0x124>
      88:	00006097          	auipc	ra,0x6
      8c:	ec6080e7          	jalr	-314(ra) # 5f4e <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	b34080e7          	jalr	-1228(ra) # 5bc6 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	0a050513          	addi	a0,a0,160 # 6148 <malloc+0x13c>
      b0:	00006097          	auipc	ra,0x6
      b4:	b56080e7          	jalr	-1194(ra) # 5c06 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	b32080e7          	jalr	-1230(ra) # 5bee <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	0a250513          	addi	a0,a0,162 # 6168 <malloc+0x15c>
      ce:	00006097          	auipc	ra,0x6
      d2:	b38080e7          	jalr	-1224(ra) # 5c06 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	06a50513          	addi	a0,a0,106 # 6150 <malloc+0x144>
      ee:	00006097          	auipc	ra,0x6
      f2:	e60080e7          	jalr	-416(ra) # 5f4e <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	ace080e7          	jalr	-1330(ra) # 5bc6 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	07650513          	addi	a0,a0,118 # 6178 <malloc+0x16c>
     10a:	00006097          	auipc	ra,0x6
     10e:	e44080e7          	jalr	-444(ra) # 5f4e <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	ab2080e7          	jalr	-1358(ra) # 5bc6 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	07450513          	addi	a0,a0,116 # 61a0 <malloc+0x194>
     134:	00006097          	auipc	ra,0x6
     138:	ae2080e7          	jalr	-1310(ra) # 5c16 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	06050513          	addi	a0,a0,96 # 61a0 <malloc+0x194>
     148:	00006097          	auipc	ra,0x6
     14c:	abe080e7          	jalr	-1346(ra) # 5c06 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	05c58593          	addi	a1,a1,92 # 61b0 <malloc+0x1a4>
     15c:	00006097          	auipc	ra,0x6
     160:	a8a080e7          	jalr	-1398(ra) # 5be6 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	03850513          	addi	a0,a0,56 # 61a0 <malloc+0x194>
     170:	00006097          	auipc	ra,0x6
     174:	a96080e7          	jalr	-1386(ra) # 5c06 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	03c58593          	addi	a1,a1,60 # 61b8 <malloc+0x1ac>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	a60080e7          	jalr	-1440(ra) # 5be6 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	00c50513          	addi	a0,a0,12 # 61a0 <malloc+0x194>
     19c:	00006097          	auipc	ra,0x6
     1a0:	a7a080e7          	jalr	-1414(ra) # 5c16 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	a48080e7          	jalr	-1464(ra) # 5bee <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	a3e080e7          	jalr	-1474(ra) # 5bee <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	ff650513          	addi	a0,a0,-10 # 61c0 <malloc+0x1b4>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	d7c080e7          	jalr	-644(ra) # 5f4e <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	9ea080e7          	jalr	-1558(ra) # 5bc6 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	9f6080e7          	jalr	-1546(ra) # 5c06 <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	9d6080e7          	jalr	-1578(ra) # 5bee <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	andi	s1,s1,255
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	9d0080e7          	jalr	-1584(ra) # 5c16 <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	andi	s1,s1,255
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	f6c50513          	addi	a0,a0,-148 # 61e8 <malloc+0x1dc>
     284:	00006097          	auipc	ra,0x6
     288:	992080e7          	jalr	-1646(ra) # 5c16 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	f58a8a93          	addi	s5,s5,-168 # 61e8 <malloc+0x1dc>
      int cc = write(fd, buf, sz);
     298:	0000da17          	auipc	s4,0xd
     29c:	9c0a0a13          	addi	s4,s4,-1600 # cc58 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <diskfull+0x173>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	95a080e7          	jalr	-1702(ra) # 5c06 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	928080e7          	jalr	-1752(ra) # 5be6 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49463          	bne	s1,a0,330 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	914080e7          	jalr	-1772(ra) # 5be6 <write>
      if(cc != sz){
     2da:	04951963          	bne	a0,s1,32c <bigwrite+0xc8>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	90e080e7          	jalr	-1778(ra) # 5bee <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	92c080e7          	jalr	-1748(ra) # 5c16 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	ee650513          	addi	a0,a0,-282 # 61f8 <malloc+0x1ec>
     31a:	00006097          	auipc	ra,0x6
     31e:	c34080e7          	jalr	-972(ra) # 5f4e <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	8a2080e7          	jalr	-1886(ra) # 5bc6 <exit>
     32c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     32e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     330:	86ce                	mv	a3,s3
     332:	8626                	mv	a2,s1
     334:	85de                	mv	a1,s7
     336:	00006517          	auipc	a0,0x6
     33a:	ee250513          	addi	a0,a0,-286 # 6218 <malloc+0x20c>
     33e:	00006097          	auipc	ra,0x6
     342:	c10080e7          	jalr	-1008(ra) # 5f4e <printf>
        exit(1);
     346:	4505                	li	a0,1
     348:	00006097          	auipc	ra,0x6
     34c:	87e080e7          	jalr	-1922(ra) # 5bc6 <exit>

0000000000000350 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     350:	7179                	addi	sp,sp,-48
     352:	f406                	sd	ra,40(sp)
     354:	f022                	sd	s0,32(sp)
     356:	ec26                	sd	s1,24(sp)
     358:	e84a                	sd	s2,16(sp)
     35a:	e44e                	sd	s3,8(sp)
     35c:	e052                	sd	s4,0(sp)
     35e:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     360:	00006517          	auipc	a0,0x6
     364:	ed050513          	addi	a0,a0,-304 # 6230 <malloc+0x224>
     368:	00006097          	auipc	ra,0x6
     36c:	8ae080e7          	jalr	-1874(ra) # 5c16 <unlink>
     370:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     374:	00006997          	auipc	s3,0x6
     378:	ebc98993          	addi	s3,s3,-324 # 6230 <malloc+0x224>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     37c:	5a7d                	li	s4,-1
     37e:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     382:	20100593          	li	a1,513
     386:	854e                	mv	a0,s3
     388:	00006097          	auipc	ra,0x6
     38c:	87e080e7          	jalr	-1922(ra) # 5c06 <open>
     390:	84aa                	mv	s1,a0
    if(fd < 0){
     392:	06054b63          	bltz	a0,408 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
     396:	4605                	li	a2,1
     398:	85d2                	mv	a1,s4
     39a:	00006097          	auipc	ra,0x6
     39e:	84c080e7          	jalr	-1972(ra) # 5be6 <write>
    close(fd);
     3a2:	8526                	mv	a0,s1
     3a4:	00006097          	auipc	ra,0x6
     3a8:	84a080e7          	jalr	-1974(ra) # 5bee <close>
    unlink("junk");
     3ac:	854e                	mv	a0,s3
     3ae:	00006097          	auipc	ra,0x6
     3b2:	868080e7          	jalr	-1944(ra) # 5c16 <unlink>
  for(int i = 0; i < assumed_free; i++){
     3b6:	397d                	addiw	s2,s2,-1
     3b8:	fc0915e3          	bnez	s2,382 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3bc:	20100593          	li	a1,513
     3c0:	00006517          	auipc	a0,0x6
     3c4:	e7050513          	addi	a0,a0,-400 # 6230 <malloc+0x224>
     3c8:	00006097          	auipc	ra,0x6
     3cc:	83e080e7          	jalr	-1986(ra) # 5c06 <open>
     3d0:	84aa                	mv	s1,a0
  if(fd < 0){
     3d2:	04054863          	bltz	a0,422 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     3d6:	4605                	li	a2,1
     3d8:	00006597          	auipc	a1,0x6
     3dc:	de058593          	addi	a1,a1,-544 # 61b8 <malloc+0x1ac>
     3e0:	00006097          	auipc	ra,0x6
     3e4:	806080e7          	jalr	-2042(ra) # 5be6 <write>
     3e8:	4785                	li	a5,1
     3ea:	04f50963          	beq	a0,a5,43c <badwrite+0xec>
    printf("write failed\n");
     3ee:	00006517          	auipc	a0,0x6
     3f2:	e6250513          	addi	a0,a0,-414 # 6250 <malloc+0x244>
     3f6:	00006097          	auipc	ra,0x6
     3fa:	b58080e7          	jalr	-1192(ra) # 5f4e <printf>
    exit(1);
     3fe:	4505                	li	a0,1
     400:	00005097          	auipc	ra,0x5
     404:	7c6080e7          	jalr	1990(ra) # 5bc6 <exit>
      printf("open junk failed\n");
     408:	00006517          	auipc	a0,0x6
     40c:	e3050513          	addi	a0,a0,-464 # 6238 <malloc+0x22c>
     410:	00006097          	auipc	ra,0x6
     414:	b3e080e7          	jalr	-1218(ra) # 5f4e <printf>
      exit(1);
     418:	4505                	li	a0,1
     41a:	00005097          	auipc	ra,0x5
     41e:	7ac080e7          	jalr	1964(ra) # 5bc6 <exit>
    printf("open junk failed\n");
     422:	00006517          	auipc	a0,0x6
     426:	e1650513          	addi	a0,a0,-490 # 6238 <malloc+0x22c>
     42a:	00006097          	auipc	ra,0x6
     42e:	b24080e7          	jalr	-1244(ra) # 5f4e <printf>
    exit(1);
     432:	4505                	li	a0,1
     434:	00005097          	auipc	ra,0x5
     438:	792080e7          	jalr	1938(ra) # 5bc6 <exit>
  }
  close(fd);
     43c:	8526                	mv	a0,s1
     43e:	00005097          	auipc	ra,0x5
     442:	7b0080e7          	jalr	1968(ra) # 5bee <close>
  unlink("junk");
     446:	00006517          	auipc	a0,0x6
     44a:	dea50513          	addi	a0,a0,-534 # 6230 <malloc+0x224>
     44e:	00005097          	auipc	ra,0x5
     452:	7c8080e7          	jalr	1992(ra) # 5c16 <unlink>

  exit(0);
     456:	4501                	li	a0,0
     458:	00005097          	auipc	ra,0x5
     45c:	76e080e7          	jalr	1902(ra) # 5bc6 <exit>

0000000000000460 <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     460:	715d                	addi	sp,sp,-80
     462:	e486                	sd	ra,72(sp)
     464:	e0a2                	sd	s0,64(sp)
     466:	fc26                	sd	s1,56(sp)
     468:	f84a                	sd	s2,48(sp)
     46a:	f44e                	sd	s3,40(sp)
     46c:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     46e:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     470:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     474:	40000993          	li	s3,1024
    name[0] = 'z';
     478:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     47c:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     480:	41f4d79b          	sraiw	a5,s1,0x1f
     484:	01b7d71b          	srliw	a4,a5,0x1b
     488:	009707bb          	addw	a5,a4,s1
     48c:	4057d69b          	sraiw	a3,a5,0x5
     490:	0306869b          	addiw	a3,a3,48
     494:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     498:	8bfd                	andi	a5,a5,31
     49a:	9f99                	subw	a5,a5,a4
     49c:	0307879b          	addiw	a5,a5,48
     4a0:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4a4:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4a8:	fb040513          	addi	a0,s0,-80
     4ac:	00005097          	auipc	ra,0x5
     4b0:	76a080e7          	jalr	1898(ra) # 5c16 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4b4:	60200593          	li	a1,1538
     4b8:	fb040513          	addi	a0,s0,-80
     4bc:	00005097          	auipc	ra,0x5
     4c0:	74a080e7          	jalr	1866(ra) # 5c06 <open>
    if(fd < 0){
     4c4:	00054963          	bltz	a0,4d6 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4c8:	00005097          	auipc	ra,0x5
     4cc:	726080e7          	jalr	1830(ra) # 5bee <close>
  for(int i = 0; i < nzz; i++){
     4d0:	2485                	addiw	s1,s1,1
     4d2:	fb3493e3          	bne	s1,s3,478 <outofinodes+0x18>
     4d6:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     4d8:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4dc:	40000993          	li	s3,1024
    name[0] = 'z';
     4e0:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4e4:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4e8:	41f4d79b          	sraiw	a5,s1,0x1f
     4ec:	01b7d71b          	srliw	a4,a5,0x1b
     4f0:	009707bb          	addw	a5,a4,s1
     4f4:	4057d69b          	sraiw	a3,a5,0x5
     4f8:	0306869b          	addiw	a3,a3,48
     4fc:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     500:	8bfd                	andi	a5,a5,31
     502:	9f99                	subw	a5,a5,a4
     504:	0307879b          	addiw	a5,a5,48
     508:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     50c:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     510:	fb040513          	addi	a0,s0,-80
     514:	00005097          	auipc	ra,0x5
     518:	702080e7          	jalr	1794(ra) # 5c16 <unlink>
  for(int i = 0; i < nzz; i++){
     51c:	2485                	addiw	s1,s1,1
     51e:	fd3491e3          	bne	s1,s3,4e0 <outofinodes+0x80>
  }
}
     522:	60a6                	ld	ra,72(sp)
     524:	6406                	ld	s0,64(sp)
     526:	74e2                	ld	s1,56(sp)
     528:	7942                	ld	s2,48(sp)
     52a:	79a2                	ld	s3,40(sp)
     52c:	6161                	addi	sp,sp,80
     52e:	8082                	ret

0000000000000530 <copyin>:
{
     530:	715d                	addi	sp,sp,-80
     532:	e486                	sd	ra,72(sp)
     534:	e0a2                	sd	s0,64(sp)
     536:	fc26                	sd	s1,56(sp)
     538:	f84a                	sd	s2,48(sp)
     53a:	f44e                	sd	s3,40(sp)
     53c:	f052                	sd	s4,32(sp)
     53e:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     540:	4785                	li	a5,1
     542:	07fe                	slli	a5,a5,0x1f
     544:	fcf43023          	sd	a5,-64(s0)
     548:	57fd                	li	a5,-1
     54a:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     54e:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     552:	00006a17          	auipc	s4,0x6
     556:	d0ea0a13          	addi	s4,s4,-754 # 6260 <malloc+0x254>
    uint64 addr = addrs[ai];
     55a:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     55e:	20100593          	li	a1,513
     562:	8552                	mv	a0,s4
     564:	00005097          	auipc	ra,0x5
     568:	6a2080e7          	jalr	1698(ra) # 5c06 <open>
     56c:	84aa                	mv	s1,a0
    if(fd < 0){
     56e:	08054863          	bltz	a0,5fe <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     572:	6609                	lui	a2,0x2
     574:	85ce                	mv	a1,s3
     576:	00005097          	auipc	ra,0x5
     57a:	670080e7          	jalr	1648(ra) # 5be6 <write>
    if(n >= 0){
     57e:	08055d63          	bgez	a0,618 <copyin+0xe8>
    close(fd);
     582:	8526                	mv	a0,s1
     584:	00005097          	auipc	ra,0x5
     588:	66a080e7          	jalr	1642(ra) # 5bee <close>
    unlink("copyin1");
     58c:	8552                	mv	a0,s4
     58e:	00005097          	auipc	ra,0x5
     592:	688080e7          	jalr	1672(ra) # 5c16 <unlink>
    n = write(1, (char*)addr, 8192);
     596:	6609                	lui	a2,0x2
     598:	85ce                	mv	a1,s3
     59a:	4505                	li	a0,1
     59c:	00005097          	auipc	ra,0x5
     5a0:	64a080e7          	jalr	1610(ra) # 5be6 <write>
    if(n > 0){
     5a4:	08a04963          	bgtz	a0,636 <copyin+0x106>
    if(pipe(fds) < 0){
     5a8:	fb840513          	addi	a0,s0,-72
     5ac:	00005097          	auipc	ra,0x5
     5b0:	62a080e7          	jalr	1578(ra) # 5bd6 <pipe>
     5b4:	0a054063          	bltz	a0,654 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     5b8:	6609                	lui	a2,0x2
     5ba:	85ce                	mv	a1,s3
     5bc:	fbc42503          	lw	a0,-68(s0)
     5c0:	00005097          	auipc	ra,0x5
     5c4:	626080e7          	jalr	1574(ra) # 5be6 <write>
    if(n > 0){
     5c8:	0aa04363          	bgtz	a0,66e <copyin+0x13e>
    close(fds[0]);
     5cc:	fb842503          	lw	a0,-72(s0)
     5d0:	00005097          	auipc	ra,0x5
     5d4:	61e080e7          	jalr	1566(ra) # 5bee <close>
    close(fds[1]);
     5d8:	fbc42503          	lw	a0,-68(s0)
     5dc:	00005097          	auipc	ra,0x5
     5e0:	612080e7          	jalr	1554(ra) # 5bee <close>
  for(int ai = 0; ai < 2; ai++){
     5e4:	0921                	addi	s2,s2,8
     5e6:	fd040793          	addi	a5,s0,-48
     5ea:	f6f918e3          	bne	s2,a5,55a <copyin+0x2a>
}
     5ee:	60a6                	ld	ra,72(sp)
     5f0:	6406                	ld	s0,64(sp)
     5f2:	74e2                	ld	s1,56(sp)
     5f4:	7942                	ld	s2,48(sp)
     5f6:	79a2                	ld	s3,40(sp)
     5f8:	7a02                	ld	s4,32(sp)
     5fa:	6161                	addi	sp,sp,80
     5fc:	8082                	ret
      printf("open(copyin1) failed\n");
     5fe:	00006517          	auipc	a0,0x6
     602:	c6a50513          	addi	a0,a0,-918 # 6268 <malloc+0x25c>
     606:	00006097          	auipc	ra,0x6
     60a:	948080e7          	jalr	-1720(ra) # 5f4e <printf>
      exit(1);
     60e:	4505                	li	a0,1
     610:	00005097          	auipc	ra,0x5
     614:	5b6080e7          	jalr	1462(ra) # 5bc6 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     618:	862a                	mv	a2,a0
     61a:	85ce                	mv	a1,s3
     61c:	00006517          	auipc	a0,0x6
     620:	c6450513          	addi	a0,a0,-924 # 6280 <malloc+0x274>
     624:	00006097          	auipc	ra,0x6
     628:	92a080e7          	jalr	-1750(ra) # 5f4e <printf>
      exit(1);
     62c:	4505                	li	a0,1
     62e:	00005097          	auipc	ra,0x5
     632:	598080e7          	jalr	1432(ra) # 5bc6 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     636:	862a                	mv	a2,a0
     638:	85ce                	mv	a1,s3
     63a:	00006517          	auipc	a0,0x6
     63e:	c7650513          	addi	a0,a0,-906 # 62b0 <malloc+0x2a4>
     642:	00006097          	auipc	ra,0x6
     646:	90c080e7          	jalr	-1780(ra) # 5f4e <printf>
      exit(1);
     64a:	4505                	li	a0,1
     64c:	00005097          	auipc	ra,0x5
     650:	57a080e7          	jalr	1402(ra) # 5bc6 <exit>
      printf("pipe() failed\n");
     654:	00006517          	auipc	a0,0x6
     658:	c8c50513          	addi	a0,a0,-884 # 62e0 <malloc+0x2d4>
     65c:	00006097          	auipc	ra,0x6
     660:	8f2080e7          	jalr	-1806(ra) # 5f4e <printf>
      exit(1);
     664:	4505                	li	a0,1
     666:	00005097          	auipc	ra,0x5
     66a:	560080e7          	jalr	1376(ra) # 5bc6 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66e:	862a                	mv	a2,a0
     670:	85ce                	mv	a1,s3
     672:	00006517          	auipc	a0,0x6
     676:	c7e50513          	addi	a0,a0,-898 # 62f0 <malloc+0x2e4>
     67a:	00006097          	auipc	ra,0x6
     67e:	8d4080e7          	jalr	-1836(ra) # 5f4e <printf>
      exit(1);
     682:	4505                	li	a0,1
     684:	00005097          	auipc	ra,0x5
     688:	542080e7          	jalr	1346(ra) # 5bc6 <exit>

000000000000068c <copyout>:
{
     68c:	711d                	addi	sp,sp,-96
     68e:	ec86                	sd	ra,88(sp)
     690:	e8a2                	sd	s0,80(sp)
     692:	e4a6                	sd	s1,72(sp)
     694:	e0ca                	sd	s2,64(sp)
     696:	fc4e                	sd	s3,56(sp)
     698:	f852                	sd	s4,48(sp)
     69a:	f456                	sd	s5,40(sp)
     69c:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     69e:	4785                	li	a5,1
     6a0:	07fe                	slli	a5,a5,0x1f
     6a2:	faf43823          	sd	a5,-80(s0)
     6a6:	57fd                	li	a5,-1
     6a8:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     6ac:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     6b0:	00006a17          	auipc	s4,0x6
     6b4:	c70a0a13          	addi	s4,s4,-912 # 6320 <malloc+0x314>
    n = write(fds[1], "x", 1);
     6b8:	00006a97          	auipc	s5,0x6
     6bc:	b00a8a93          	addi	s5,s5,-1280 # 61b8 <malloc+0x1ac>
    uint64 addr = addrs[ai];
     6c0:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     6c4:	4581                	li	a1,0
     6c6:	8552                	mv	a0,s4
     6c8:	00005097          	auipc	ra,0x5
     6cc:	53e080e7          	jalr	1342(ra) # 5c06 <open>
     6d0:	84aa                	mv	s1,a0
    if(fd < 0){
     6d2:	08054663          	bltz	a0,75e <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     6d6:	6609                	lui	a2,0x2
     6d8:	85ce                	mv	a1,s3
     6da:	00005097          	auipc	ra,0x5
     6de:	504080e7          	jalr	1284(ra) # 5bde <read>
    if(n > 0){
     6e2:	08a04b63          	bgtz	a0,778 <copyout+0xec>
    close(fd);
     6e6:	8526                	mv	a0,s1
     6e8:	00005097          	auipc	ra,0x5
     6ec:	506080e7          	jalr	1286(ra) # 5bee <close>
    if(pipe(fds) < 0){
     6f0:	fa840513          	addi	a0,s0,-88
     6f4:	00005097          	auipc	ra,0x5
     6f8:	4e2080e7          	jalr	1250(ra) # 5bd6 <pipe>
     6fc:	08054d63          	bltz	a0,796 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     700:	4605                	li	a2,1
     702:	85d6                	mv	a1,s5
     704:	fac42503          	lw	a0,-84(s0)
     708:	00005097          	auipc	ra,0x5
     70c:	4de080e7          	jalr	1246(ra) # 5be6 <write>
    if(n != 1){
     710:	4785                	li	a5,1
     712:	08f51f63          	bne	a0,a5,7b0 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     716:	6609                	lui	a2,0x2
     718:	85ce                	mv	a1,s3
     71a:	fa842503          	lw	a0,-88(s0)
     71e:	00005097          	auipc	ra,0x5
     722:	4c0080e7          	jalr	1216(ra) # 5bde <read>
    if(n > 0){
     726:	0aa04263          	bgtz	a0,7ca <copyout+0x13e>
    close(fds[0]);
     72a:	fa842503          	lw	a0,-88(s0)
     72e:	00005097          	auipc	ra,0x5
     732:	4c0080e7          	jalr	1216(ra) # 5bee <close>
    close(fds[1]);
     736:	fac42503          	lw	a0,-84(s0)
     73a:	00005097          	auipc	ra,0x5
     73e:	4b4080e7          	jalr	1204(ra) # 5bee <close>
  for(int ai = 0; ai < 2; ai++){
     742:	0921                	addi	s2,s2,8
     744:	fc040793          	addi	a5,s0,-64
     748:	f6f91ce3          	bne	s2,a5,6c0 <copyout+0x34>
}
     74c:	60e6                	ld	ra,88(sp)
     74e:	6446                	ld	s0,80(sp)
     750:	64a6                	ld	s1,72(sp)
     752:	6906                	ld	s2,64(sp)
     754:	79e2                	ld	s3,56(sp)
     756:	7a42                	ld	s4,48(sp)
     758:	7aa2                	ld	s5,40(sp)
     75a:	6125                	addi	sp,sp,96
     75c:	8082                	ret
      printf("open(README) failed\n");
     75e:	00006517          	auipc	a0,0x6
     762:	bca50513          	addi	a0,a0,-1078 # 6328 <malloc+0x31c>
     766:	00005097          	auipc	ra,0x5
     76a:	7e8080e7          	jalr	2024(ra) # 5f4e <printf>
      exit(1);
     76e:	4505                	li	a0,1
     770:	00005097          	auipc	ra,0x5
     774:	456080e7          	jalr	1110(ra) # 5bc6 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     778:	862a                	mv	a2,a0
     77a:	85ce                	mv	a1,s3
     77c:	00006517          	auipc	a0,0x6
     780:	bc450513          	addi	a0,a0,-1084 # 6340 <malloc+0x334>
     784:	00005097          	auipc	ra,0x5
     788:	7ca080e7          	jalr	1994(ra) # 5f4e <printf>
      exit(1);
     78c:	4505                	li	a0,1
     78e:	00005097          	auipc	ra,0x5
     792:	438080e7          	jalr	1080(ra) # 5bc6 <exit>
      printf("pipe() failed\n");
     796:	00006517          	auipc	a0,0x6
     79a:	b4a50513          	addi	a0,a0,-1206 # 62e0 <malloc+0x2d4>
     79e:	00005097          	auipc	ra,0x5
     7a2:	7b0080e7          	jalr	1968(ra) # 5f4e <printf>
      exit(1);
     7a6:	4505                	li	a0,1
     7a8:	00005097          	auipc	ra,0x5
     7ac:	41e080e7          	jalr	1054(ra) # 5bc6 <exit>
      printf("pipe write failed\n");
     7b0:	00006517          	auipc	a0,0x6
     7b4:	bc050513          	addi	a0,a0,-1088 # 6370 <malloc+0x364>
     7b8:	00005097          	auipc	ra,0x5
     7bc:	796080e7          	jalr	1942(ra) # 5f4e <printf>
      exit(1);
     7c0:	4505                	li	a0,1
     7c2:	00005097          	auipc	ra,0x5
     7c6:	404080e7          	jalr	1028(ra) # 5bc6 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7ca:	862a                	mv	a2,a0
     7cc:	85ce                	mv	a1,s3
     7ce:	00006517          	auipc	a0,0x6
     7d2:	bba50513          	addi	a0,a0,-1094 # 6388 <malloc+0x37c>
     7d6:	00005097          	auipc	ra,0x5
     7da:	778080e7          	jalr	1912(ra) # 5f4e <printf>
      exit(1);
     7de:	4505                	li	a0,1
     7e0:	00005097          	auipc	ra,0x5
     7e4:	3e6080e7          	jalr	998(ra) # 5bc6 <exit>

00000000000007e8 <truncate1>:
{
     7e8:	711d                	addi	sp,sp,-96
     7ea:	ec86                	sd	ra,88(sp)
     7ec:	e8a2                	sd	s0,80(sp)
     7ee:	e4a6                	sd	s1,72(sp)
     7f0:	e0ca                	sd	s2,64(sp)
     7f2:	fc4e                	sd	s3,56(sp)
     7f4:	f852                	sd	s4,48(sp)
     7f6:	f456                	sd	s5,40(sp)
     7f8:	1080                	addi	s0,sp,96
     7fa:	8aaa                	mv	s5,a0
  unlink("truncfile");
     7fc:	00006517          	auipc	a0,0x6
     800:	9a450513          	addi	a0,a0,-1628 # 61a0 <malloc+0x194>
     804:	00005097          	auipc	ra,0x5
     808:	412080e7          	jalr	1042(ra) # 5c16 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     80c:	60100593          	li	a1,1537
     810:	00006517          	auipc	a0,0x6
     814:	99050513          	addi	a0,a0,-1648 # 61a0 <malloc+0x194>
     818:	00005097          	auipc	ra,0x5
     81c:	3ee080e7          	jalr	1006(ra) # 5c06 <open>
     820:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     822:	4611                	li	a2,4
     824:	00006597          	auipc	a1,0x6
     828:	98c58593          	addi	a1,a1,-1652 # 61b0 <malloc+0x1a4>
     82c:	00005097          	auipc	ra,0x5
     830:	3ba080e7          	jalr	954(ra) # 5be6 <write>
  close(fd1);
     834:	8526                	mv	a0,s1
     836:	00005097          	auipc	ra,0x5
     83a:	3b8080e7          	jalr	952(ra) # 5bee <close>
  int fd2 = open("truncfile", O_RDONLY);
     83e:	4581                	li	a1,0
     840:	00006517          	auipc	a0,0x6
     844:	96050513          	addi	a0,a0,-1696 # 61a0 <malloc+0x194>
     848:	00005097          	auipc	ra,0x5
     84c:	3be080e7          	jalr	958(ra) # 5c06 <open>
     850:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     852:	02000613          	li	a2,32
     856:	fa040593          	addi	a1,s0,-96
     85a:	00005097          	auipc	ra,0x5
     85e:	384080e7          	jalr	900(ra) # 5bde <read>
  if(n != 4){
     862:	4791                	li	a5,4
     864:	0cf51e63          	bne	a0,a5,940 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     868:	40100593          	li	a1,1025
     86c:	00006517          	auipc	a0,0x6
     870:	93450513          	addi	a0,a0,-1740 # 61a0 <malloc+0x194>
     874:	00005097          	auipc	ra,0x5
     878:	392080e7          	jalr	914(ra) # 5c06 <open>
     87c:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     87e:	4581                	li	a1,0
     880:	00006517          	auipc	a0,0x6
     884:	92050513          	addi	a0,a0,-1760 # 61a0 <malloc+0x194>
     888:	00005097          	auipc	ra,0x5
     88c:	37e080e7          	jalr	894(ra) # 5c06 <open>
     890:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     892:	02000613          	li	a2,32
     896:	fa040593          	addi	a1,s0,-96
     89a:	00005097          	auipc	ra,0x5
     89e:	344080e7          	jalr	836(ra) # 5bde <read>
     8a2:	8a2a                	mv	s4,a0
  if(n != 0){
     8a4:	ed4d                	bnez	a0,95e <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8a6:	02000613          	li	a2,32
     8aa:	fa040593          	addi	a1,s0,-96
     8ae:	8526                	mv	a0,s1
     8b0:	00005097          	auipc	ra,0x5
     8b4:	32e080e7          	jalr	814(ra) # 5bde <read>
     8b8:	8a2a                	mv	s4,a0
  if(n != 0){
     8ba:	e971                	bnez	a0,98e <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8bc:	4619                	li	a2,6
     8be:	00006597          	auipc	a1,0x6
     8c2:	b5a58593          	addi	a1,a1,-1190 # 6418 <malloc+0x40c>
     8c6:	854e                	mv	a0,s3
     8c8:	00005097          	auipc	ra,0x5
     8cc:	31e080e7          	jalr	798(ra) # 5be6 <write>
  n = read(fd3, buf, sizeof(buf));
     8d0:	02000613          	li	a2,32
     8d4:	fa040593          	addi	a1,s0,-96
     8d8:	854a                	mv	a0,s2
     8da:	00005097          	auipc	ra,0x5
     8de:	304080e7          	jalr	772(ra) # 5bde <read>
  if(n != 6){
     8e2:	4799                	li	a5,6
     8e4:	0cf51d63          	bne	a0,a5,9be <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8e8:	02000613          	li	a2,32
     8ec:	fa040593          	addi	a1,s0,-96
     8f0:	8526                	mv	a0,s1
     8f2:	00005097          	auipc	ra,0x5
     8f6:	2ec080e7          	jalr	748(ra) # 5bde <read>
  if(n != 2){
     8fa:	4789                	li	a5,2
     8fc:	0ef51063          	bne	a0,a5,9dc <truncate1+0x1f4>
  unlink("truncfile");
     900:	00006517          	auipc	a0,0x6
     904:	8a050513          	addi	a0,a0,-1888 # 61a0 <malloc+0x194>
     908:	00005097          	auipc	ra,0x5
     90c:	30e080e7          	jalr	782(ra) # 5c16 <unlink>
  close(fd1);
     910:	854e                	mv	a0,s3
     912:	00005097          	auipc	ra,0x5
     916:	2dc080e7          	jalr	732(ra) # 5bee <close>
  close(fd2);
     91a:	8526                	mv	a0,s1
     91c:	00005097          	auipc	ra,0x5
     920:	2d2080e7          	jalr	722(ra) # 5bee <close>
  close(fd3);
     924:	854a                	mv	a0,s2
     926:	00005097          	auipc	ra,0x5
     92a:	2c8080e7          	jalr	712(ra) # 5bee <close>
}
     92e:	60e6                	ld	ra,88(sp)
     930:	6446                	ld	s0,80(sp)
     932:	64a6                	ld	s1,72(sp)
     934:	6906                	ld	s2,64(sp)
     936:	79e2                	ld	s3,56(sp)
     938:	7a42                	ld	s4,48(sp)
     93a:	7aa2                	ld	s5,40(sp)
     93c:	6125                	addi	sp,sp,96
     93e:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     940:	862a                	mv	a2,a0
     942:	85d6                	mv	a1,s5
     944:	00006517          	auipc	a0,0x6
     948:	a7450513          	addi	a0,a0,-1420 # 63b8 <malloc+0x3ac>
     94c:	00005097          	auipc	ra,0x5
     950:	602080e7          	jalr	1538(ra) # 5f4e <printf>
    exit(1);
     954:	4505                	li	a0,1
     956:	00005097          	auipc	ra,0x5
     95a:	270080e7          	jalr	624(ra) # 5bc6 <exit>
    printf("aaa fd3=%d\n", fd3);
     95e:	85ca                	mv	a1,s2
     960:	00006517          	auipc	a0,0x6
     964:	a7850513          	addi	a0,a0,-1416 # 63d8 <malloc+0x3cc>
     968:	00005097          	auipc	ra,0x5
     96c:	5e6080e7          	jalr	1510(ra) # 5f4e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     970:	8652                	mv	a2,s4
     972:	85d6                	mv	a1,s5
     974:	00006517          	auipc	a0,0x6
     978:	a7450513          	addi	a0,a0,-1420 # 63e8 <malloc+0x3dc>
     97c:	00005097          	auipc	ra,0x5
     980:	5d2080e7          	jalr	1490(ra) # 5f4e <printf>
    exit(1);
     984:	4505                	li	a0,1
     986:	00005097          	auipc	ra,0x5
     98a:	240080e7          	jalr	576(ra) # 5bc6 <exit>
    printf("bbb fd2=%d\n", fd2);
     98e:	85a6                	mv	a1,s1
     990:	00006517          	auipc	a0,0x6
     994:	a7850513          	addi	a0,a0,-1416 # 6408 <malloc+0x3fc>
     998:	00005097          	auipc	ra,0x5
     99c:	5b6080e7          	jalr	1462(ra) # 5f4e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     9a0:	8652                	mv	a2,s4
     9a2:	85d6                	mv	a1,s5
     9a4:	00006517          	auipc	a0,0x6
     9a8:	a4450513          	addi	a0,a0,-1468 # 63e8 <malloc+0x3dc>
     9ac:	00005097          	auipc	ra,0x5
     9b0:	5a2080e7          	jalr	1442(ra) # 5f4e <printf>
    exit(1);
     9b4:	4505                	li	a0,1
     9b6:	00005097          	auipc	ra,0x5
     9ba:	210080e7          	jalr	528(ra) # 5bc6 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9be:	862a                	mv	a2,a0
     9c0:	85d6                	mv	a1,s5
     9c2:	00006517          	auipc	a0,0x6
     9c6:	a5e50513          	addi	a0,a0,-1442 # 6420 <malloc+0x414>
     9ca:	00005097          	auipc	ra,0x5
     9ce:	584080e7          	jalr	1412(ra) # 5f4e <printf>
    exit(1);
     9d2:	4505                	li	a0,1
     9d4:	00005097          	auipc	ra,0x5
     9d8:	1f2080e7          	jalr	498(ra) # 5bc6 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9dc:	862a                	mv	a2,a0
     9de:	85d6                	mv	a1,s5
     9e0:	00006517          	auipc	a0,0x6
     9e4:	a6050513          	addi	a0,a0,-1440 # 6440 <malloc+0x434>
     9e8:	00005097          	auipc	ra,0x5
     9ec:	566080e7          	jalr	1382(ra) # 5f4e <printf>
    exit(1);
     9f0:	4505                	li	a0,1
     9f2:	00005097          	auipc	ra,0x5
     9f6:	1d4080e7          	jalr	468(ra) # 5bc6 <exit>

00000000000009fa <writetest>:
{
     9fa:	7139                	addi	sp,sp,-64
     9fc:	fc06                	sd	ra,56(sp)
     9fe:	f822                	sd	s0,48(sp)
     a00:	f426                	sd	s1,40(sp)
     a02:	f04a                	sd	s2,32(sp)
     a04:	ec4e                	sd	s3,24(sp)
     a06:	e852                	sd	s4,16(sp)
     a08:	e456                	sd	s5,8(sp)
     a0a:	e05a                	sd	s6,0(sp)
     a0c:	0080                	addi	s0,sp,64
     a0e:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     a10:	20200593          	li	a1,514
     a14:	00006517          	auipc	a0,0x6
     a18:	a4c50513          	addi	a0,a0,-1460 # 6460 <malloc+0x454>
     a1c:	00005097          	auipc	ra,0x5
     a20:	1ea080e7          	jalr	490(ra) # 5c06 <open>
  if(fd < 0){
     a24:	0a054d63          	bltz	a0,ade <writetest+0xe4>
     a28:	892a                	mv	s2,a0
     a2a:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a2c:	00006997          	auipc	s3,0x6
     a30:	a5c98993          	addi	s3,s3,-1444 # 6488 <malloc+0x47c>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a34:	00006a97          	auipc	s5,0x6
     a38:	a8ca8a93          	addi	s5,s5,-1396 # 64c0 <malloc+0x4b4>
  for(i = 0; i < N; i++){
     a3c:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a40:	4629                	li	a2,10
     a42:	85ce                	mv	a1,s3
     a44:	854a                	mv	a0,s2
     a46:	00005097          	auipc	ra,0x5
     a4a:	1a0080e7          	jalr	416(ra) # 5be6 <write>
     a4e:	47a9                	li	a5,10
     a50:	0af51563          	bne	a0,a5,afa <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a54:	4629                	li	a2,10
     a56:	85d6                	mv	a1,s5
     a58:	854a                	mv	a0,s2
     a5a:	00005097          	auipc	ra,0x5
     a5e:	18c080e7          	jalr	396(ra) # 5be6 <write>
     a62:	47a9                	li	a5,10
     a64:	0af51a63          	bne	a0,a5,b18 <writetest+0x11e>
  for(i = 0; i < N; i++){
     a68:	2485                	addiw	s1,s1,1
     a6a:	fd449be3          	bne	s1,s4,a40 <writetest+0x46>
  close(fd);
     a6e:	854a                	mv	a0,s2
     a70:	00005097          	auipc	ra,0x5
     a74:	17e080e7          	jalr	382(ra) # 5bee <close>
  fd = open("small", O_RDONLY);
     a78:	4581                	li	a1,0
     a7a:	00006517          	auipc	a0,0x6
     a7e:	9e650513          	addi	a0,a0,-1562 # 6460 <malloc+0x454>
     a82:	00005097          	auipc	ra,0x5
     a86:	184080e7          	jalr	388(ra) # 5c06 <open>
     a8a:	84aa                	mv	s1,a0
  if(fd < 0){
     a8c:	0a054563          	bltz	a0,b36 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     a90:	7d000613          	li	a2,2000
     a94:	0000c597          	auipc	a1,0xc
     a98:	1c458593          	addi	a1,a1,452 # cc58 <buf>
     a9c:	00005097          	auipc	ra,0x5
     aa0:	142080e7          	jalr	322(ra) # 5bde <read>
  if(i != N*SZ*2){
     aa4:	7d000793          	li	a5,2000
     aa8:	0af51563          	bne	a0,a5,b52 <writetest+0x158>
  close(fd);
     aac:	8526                	mv	a0,s1
     aae:	00005097          	auipc	ra,0x5
     ab2:	140080e7          	jalr	320(ra) # 5bee <close>
  if(unlink("small") < 0){
     ab6:	00006517          	auipc	a0,0x6
     aba:	9aa50513          	addi	a0,a0,-1622 # 6460 <malloc+0x454>
     abe:	00005097          	auipc	ra,0x5
     ac2:	158080e7          	jalr	344(ra) # 5c16 <unlink>
     ac6:	0a054463          	bltz	a0,b6e <writetest+0x174>
}
     aca:	70e2                	ld	ra,56(sp)
     acc:	7442                	ld	s0,48(sp)
     ace:	74a2                	ld	s1,40(sp)
     ad0:	7902                	ld	s2,32(sp)
     ad2:	69e2                	ld	s3,24(sp)
     ad4:	6a42                	ld	s4,16(sp)
     ad6:	6aa2                	ld	s5,8(sp)
     ad8:	6b02                	ld	s6,0(sp)
     ada:	6121                	addi	sp,sp,64
     adc:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     ade:	85da                	mv	a1,s6
     ae0:	00006517          	auipc	a0,0x6
     ae4:	98850513          	addi	a0,a0,-1656 # 6468 <malloc+0x45c>
     ae8:	00005097          	auipc	ra,0x5
     aec:	466080e7          	jalr	1126(ra) # 5f4e <printf>
    exit(1);
     af0:	4505                	li	a0,1
     af2:	00005097          	auipc	ra,0x5
     af6:	0d4080e7          	jalr	212(ra) # 5bc6 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     afa:	8626                	mv	a2,s1
     afc:	85da                	mv	a1,s6
     afe:	00006517          	auipc	a0,0x6
     b02:	99a50513          	addi	a0,a0,-1638 # 6498 <malloc+0x48c>
     b06:	00005097          	auipc	ra,0x5
     b0a:	448080e7          	jalr	1096(ra) # 5f4e <printf>
      exit(1);
     b0e:	4505                	li	a0,1
     b10:	00005097          	auipc	ra,0x5
     b14:	0b6080e7          	jalr	182(ra) # 5bc6 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b18:	8626                	mv	a2,s1
     b1a:	85da                	mv	a1,s6
     b1c:	00006517          	auipc	a0,0x6
     b20:	9b450513          	addi	a0,a0,-1612 # 64d0 <malloc+0x4c4>
     b24:	00005097          	auipc	ra,0x5
     b28:	42a080e7          	jalr	1066(ra) # 5f4e <printf>
      exit(1);
     b2c:	4505                	li	a0,1
     b2e:	00005097          	auipc	ra,0x5
     b32:	098080e7          	jalr	152(ra) # 5bc6 <exit>
    printf("%s: error: open small failed!\n", s);
     b36:	85da                	mv	a1,s6
     b38:	00006517          	auipc	a0,0x6
     b3c:	9c050513          	addi	a0,a0,-1600 # 64f8 <malloc+0x4ec>
     b40:	00005097          	auipc	ra,0x5
     b44:	40e080e7          	jalr	1038(ra) # 5f4e <printf>
    exit(1);
     b48:	4505                	li	a0,1
     b4a:	00005097          	auipc	ra,0x5
     b4e:	07c080e7          	jalr	124(ra) # 5bc6 <exit>
    printf("%s: read failed\n", s);
     b52:	85da                	mv	a1,s6
     b54:	00006517          	auipc	a0,0x6
     b58:	9c450513          	addi	a0,a0,-1596 # 6518 <malloc+0x50c>
     b5c:	00005097          	auipc	ra,0x5
     b60:	3f2080e7          	jalr	1010(ra) # 5f4e <printf>
    exit(1);
     b64:	4505                	li	a0,1
     b66:	00005097          	auipc	ra,0x5
     b6a:	060080e7          	jalr	96(ra) # 5bc6 <exit>
    printf("%s: unlink small failed\n", s);
     b6e:	85da                	mv	a1,s6
     b70:	00006517          	auipc	a0,0x6
     b74:	9c050513          	addi	a0,a0,-1600 # 6530 <malloc+0x524>
     b78:	00005097          	auipc	ra,0x5
     b7c:	3d6080e7          	jalr	982(ra) # 5f4e <printf>
    exit(1);
     b80:	4505                	li	a0,1
     b82:	00005097          	auipc	ra,0x5
     b86:	044080e7          	jalr	68(ra) # 5bc6 <exit>

0000000000000b8a <writebig>:
{
     b8a:	7139                	addi	sp,sp,-64
     b8c:	fc06                	sd	ra,56(sp)
     b8e:	f822                	sd	s0,48(sp)
     b90:	f426                	sd	s1,40(sp)
     b92:	f04a                	sd	s2,32(sp)
     b94:	ec4e                	sd	s3,24(sp)
     b96:	e852                	sd	s4,16(sp)
     b98:	e456                	sd	s5,8(sp)
     b9a:	0080                	addi	s0,sp,64
     b9c:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     b9e:	20200593          	li	a1,514
     ba2:	00006517          	auipc	a0,0x6
     ba6:	9ae50513          	addi	a0,a0,-1618 # 6550 <malloc+0x544>
     baa:	00005097          	auipc	ra,0x5
     bae:	05c080e7          	jalr	92(ra) # 5c06 <open>
     bb2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     bb4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     bb6:	0000c917          	auipc	s2,0xc
     bba:	0a290913          	addi	s2,s2,162 # cc58 <buf>
  for(i = 0; i < MAXFILE; i++){
     bbe:	10c00a13          	li	s4,268
  if(fd < 0){
     bc2:	06054c63          	bltz	a0,c3a <writebig+0xb0>
    ((int*)buf)[0] = i;
     bc6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     bca:	40000613          	li	a2,1024
     bce:	85ca                	mv	a1,s2
     bd0:	854e                	mv	a0,s3
     bd2:	00005097          	auipc	ra,0x5
     bd6:	014080e7          	jalr	20(ra) # 5be6 <write>
     bda:	40000793          	li	a5,1024
     bde:	06f51c63          	bne	a0,a5,c56 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     be2:	2485                	addiw	s1,s1,1
     be4:	ff4491e3          	bne	s1,s4,bc6 <writebig+0x3c>
  close(fd);
     be8:	854e                	mv	a0,s3
     bea:	00005097          	auipc	ra,0x5
     bee:	004080e7          	jalr	4(ra) # 5bee <close>
  fd = open("big", O_RDONLY);
     bf2:	4581                	li	a1,0
     bf4:	00006517          	auipc	a0,0x6
     bf8:	95c50513          	addi	a0,a0,-1700 # 6550 <malloc+0x544>
     bfc:	00005097          	auipc	ra,0x5
     c00:	00a080e7          	jalr	10(ra) # 5c06 <open>
     c04:	89aa                	mv	s3,a0
  n = 0;
     c06:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c08:	0000c917          	auipc	s2,0xc
     c0c:	05090913          	addi	s2,s2,80 # cc58 <buf>
  if(fd < 0){
     c10:	06054263          	bltz	a0,c74 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     c14:	40000613          	li	a2,1024
     c18:	85ca                	mv	a1,s2
     c1a:	854e                	mv	a0,s3
     c1c:	00005097          	auipc	ra,0x5
     c20:	fc2080e7          	jalr	-62(ra) # 5bde <read>
    if(i == 0){
     c24:	c535                	beqz	a0,c90 <writebig+0x106>
    } else if(i != BSIZE){
     c26:	40000793          	li	a5,1024
     c2a:	0af51f63          	bne	a0,a5,ce8 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     c2e:	00092683          	lw	a3,0(s2)
     c32:	0c969a63          	bne	a3,s1,d06 <writebig+0x17c>
    n++;
     c36:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c38:	bff1                	j	c14 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     c3a:	85d6                	mv	a1,s5
     c3c:	00006517          	auipc	a0,0x6
     c40:	91c50513          	addi	a0,a0,-1764 # 6558 <malloc+0x54c>
     c44:	00005097          	auipc	ra,0x5
     c48:	30a080e7          	jalr	778(ra) # 5f4e <printf>
    exit(1);
     c4c:	4505                	li	a0,1
     c4e:	00005097          	auipc	ra,0x5
     c52:	f78080e7          	jalr	-136(ra) # 5bc6 <exit>
      printf("%s: error: write big file failed\n", s, i);
     c56:	8626                	mv	a2,s1
     c58:	85d6                	mv	a1,s5
     c5a:	00006517          	auipc	a0,0x6
     c5e:	91e50513          	addi	a0,a0,-1762 # 6578 <malloc+0x56c>
     c62:	00005097          	auipc	ra,0x5
     c66:	2ec080e7          	jalr	748(ra) # 5f4e <printf>
      exit(1);
     c6a:	4505                	li	a0,1
     c6c:	00005097          	auipc	ra,0x5
     c70:	f5a080e7          	jalr	-166(ra) # 5bc6 <exit>
    printf("%s: error: open big failed!\n", s);
     c74:	85d6                	mv	a1,s5
     c76:	00006517          	auipc	a0,0x6
     c7a:	92a50513          	addi	a0,a0,-1750 # 65a0 <malloc+0x594>
     c7e:	00005097          	auipc	ra,0x5
     c82:	2d0080e7          	jalr	720(ra) # 5f4e <printf>
    exit(1);
     c86:	4505                	li	a0,1
     c88:	00005097          	auipc	ra,0x5
     c8c:	f3e080e7          	jalr	-194(ra) # 5bc6 <exit>
      if(n == MAXFILE - 1){
     c90:	10b00793          	li	a5,267
     c94:	02f48a63          	beq	s1,a5,cc8 <writebig+0x13e>
  close(fd);
     c98:	854e                	mv	a0,s3
     c9a:	00005097          	auipc	ra,0x5
     c9e:	f54080e7          	jalr	-172(ra) # 5bee <close>
  if(unlink("big") < 0){
     ca2:	00006517          	auipc	a0,0x6
     ca6:	8ae50513          	addi	a0,a0,-1874 # 6550 <malloc+0x544>
     caa:	00005097          	auipc	ra,0x5
     cae:	f6c080e7          	jalr	-148(ra) # 5c16 <unlink>
     cb2:	06054963          	bltz	a0,d24 <writebig+0x19a>
}
     cb6:	70e2                	ld	ra,56(sp)
     cb8:	7442                	ld	s0,48(sp)
     cba:	74a2                	ld	s1,40(sp)
     cbc:	7902                	ld	s2,32(sp)
     cbe:	69e2                	ld	s3,24(sp)
     cc0:	6a42                	ld	s4,16(sp)
     cc2:	6aa2                	ld	s5,8(sp)
     cc4:	6121                	addi	sp,sp,64
     cc6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cc8:	10b00613          	li	a2,267
     ccc:	85d6                	mv	a1,s5
     cce:	00006517          	auipc	a0,0x6
     cd2:	8f250513          	addi	a0,a0,-1806 # 65c0 <malloc+0x5b4>
     cd6:	00005097          	auipc	ra,0x5
     cda:	278080e7          	jalr	632(ra) # 5f4e <printf>
        exit(1);
     cde:	4505                	li	a0,1
     ce0:	00005097          	auipc	ra,0x5
     ce4:	ee6080e7          	jalr	-282(ra) # 5bc6 <exit>
      printf("%s: read failed %d\n", s, i);
     ce8:	862a                	mv	a2,a0
     cea:	85d6                	mv	a1,s5
     cec:	00006517          	auipc	a0,0x6
     cf0:	8fc50513          	addi	a0,a0,-1796 # 65e8 <malloc+0x5dc>
     cf4:	00005097          	auipc	ra,0x5
     cf8:	25a080e7          	jalr	602(ra) # 5f4e <printf>
      exit(1);
     cfc:	4505                	li	a0,1
     cfe:	00005097          	auipc	ra,0x5
     d02:	ec8080e7          	jalr	-312(ra) # 5bc6 <exit>
      printf("%s: read content of block %d is %d\n", s,
     d06:	8626                	mv	a2,s1
     d08:	85d6                	mv	a1,s5
     d0a:	00006517          	auipc	a0,0x6
     d0e:	8f650513          	addi	a0,a0,-1802 # 6600 <malloc+0x5f4>
     d12:	00005097          	auipc	ra,0x5
     d16:	23c080e7          	jalr	572(ra) # 5f4e <printf>
      exit(1);
     d1a:	4505                	li	a0,1
     d1c:	00005097          	auipc	ra,0x5
     d20:	eaa080e7          	jalr	-342(ra) # 5bc6 <exit>
    printf("%s: unlink big failed\n", s);
     d24:	85d6                	mv	a1,s5
     d26:	00006517          	auipc	a0,0x6
     d2a:	90250513          	addi	a0,a0,-1790 # 6628 <malloc+0x61c>
     d2e:	00005097          	auipc	ra,0x5
     d32:	220080e7          	jalr	544(ra) # 5f4e <printf>
    exit(1);
     d36:	4505                	li	a0,1
     d38:	00005097          	auipc	ra,0x5
     d3c:	e8e080e7          	jalr	-370(ra) # 5bc6 <exit>

0000000000000d40 <unlinkread>:
{
     d40:	7179                	addi	sp,sp,-48
     d42:	f406                	sd	ra,40(sp)
     d44:	f022                	sd	s0,32(sp)
     d46:	ec26                	sd	s1,24(sp)
     d48:	e84a                	sd	s2,16(sp)
     d4a:	e44e                	sd	s3,8(sp)
     d4c:	1800                	addi	s0,sp,48
     d4e:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d50:	20200593          	li	a1,514
     d54:	00006517          	auipc	a0,0x6
     d58:	8ec50513          	addi	a0,a0,-1812 # 6640 <malloc+0x634>
     d5c:	00005097          	auipc	ra,0x5
     d60:	eaa080e7          	jalr	-342(ra) # 5c06 <open>
  if(fd < 0){
     d64:	0e054563          	bltz	a0,e4e <unlinkread+0x10e>
     d68:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d6a:	4615                	li	a2,5
     d6c:	00006597          	auipc	a1,0x6
     d70:	90458593          	addi	a1,a1,-1788 # 6670 <malloc+0x664>
     d74:	00005097          	auipc	ra,0x5
     d78:	e72080e7          	jalr	-398(ra) # 5be6 <write>
  close(fd);
     d7c:	8526                	mv	a0,s1
     d7e:	00005097          	auipc	ra,0x5
     d82:	e70080e7          	jalr	-400(ra) # 5bee <close>
  fd = open("unlinkread", O_RDWR);
     d86:	4589                	li	a1,2
     d88:	00006517          	auipc	a0,0x6
     d8c:	8b850513          	addi	a0,a0,-1864 # 6640 <malloc+0x634>
     d90:	00005097          	auipc	ra,0x5
     d94:	e76080e7          	jalr	-394(ra) # 5c06 <open>
     d98:	84aa                	mv	s1,a0
  if(fd < 0){
     d9a:	0c054863          	bltz	a0,e6a <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     d9e:	00006517          	auipc	a0,0x6
     da2:	8a250513          	addi	a0,a0,-1886 # 6640 <malloc+0x634>
     da6:	00005097          	auipc	ra,0x5
     daa:	e70080e7          	jalr	-400(ra) # 5c16 <unlink>
     dae:	ed61                	bnez	a0,e86 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     db0:	20200593          	li	a1,514
     db4:	00006517          	auipc	a0,0x6
     db8:	88c50513          	addi	a0,a0,-1908 # 6640 <malloc+0x634>
     dbc:	00005097          	auipc	ra,0x5
     dc0:	e4a080e7          	jalr	-438(ra) # 5c06 <open>
     dc4:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dc6:	460d                	li	a2,3
     dc8:	00006597          	auipc	a1,0x6
     dcc:	8f058593          	addi	a1,a1,-1808 # 66b8 <malloc+0x6ac>
     dd0:	00005097          	auipc	ra,0x5
     dd4:	e16080e7          	jalr	-490(ra) # 5be6 <write>
  close(fd1);
     dd8:	854a                	mv	a0,s2
     dda:	00005097          	auipc	ra,0x5
     dde:	e14080e7          	jalr	-492(ra) # 5bee <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de2:	660d                	lui	a2,0x3
     de4:	0000c597          	auipc	a1,0xc
     de8:	e7458593          	addi	a1,a1,-396 # cc58 <buf>
     dec:	8526                	mv	a0,s1
     dee:	00005097          	auipc	ra,0x5
     df2:	df0080e7          	jalr	-528(ra) # 5bde <read>
     df6:	4795                	li	a5,5
     df8:	0af51563          	bne	a0,a5,ea2 <unlinkread+0x162>
  if(buf[0] != 'h'){
     dfc:	0000c717          	auipc	a4,0xc
     e00:	e5c74703          	lbu	a4,-420(a4) # cc58 <buf>
     e04:	06800793          	li	a5,104
     e08:	0af71b63          	bne	a4,a5,ebe <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e0c:	4629                	li	a2,10
     e0e:	0000c597          	auipc	a1,0xc
     e12:	e4a58593          	addi	a1,a1,-438 # cc58 <buf>
     e16:	8526                	mv	a0,s1
     e18:	00005097          	auipc	ra,0x5
     e1c:	dce080e7          	jalr	-562(ra) # 5be6 <write>
     e20:	47a9                	li	a5,10
     e22:	0af51c63          	bne	a0,a5,eda <unlinkread+0x19a>
  close(fd);
     e26:	8526                	mv	a0,s1
     e28:	00005097          	auipc	ra,0x5
     e2c:	dc6080e7          	jalr	-570(ra) # 5bee <close>
  unlink("unlinkread");
     e30:	00006517          	auipc	a0,0x6
     e34:	81050513          	addi	a0,a0,-2032 # 6640 <malloc+0x634>
     e38:	00005097          	auipc	ra,0x5
     e3c:	dde080e7          	jalr	-546(ra) # 5c16 <unlink>
}
     e40:	70a2                	ld	ra,40(sp)
     e42:	7402                	ld	s0,32(sp)
     e44:	64e2                	ld	s1,24(sp)
     e46:	6942                	ld	s2,16(sp)
     e48:	69a2                	ld	s3,8(sp)
     e4a:	6145                	addi	sp,sp,48
     e4c:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e4e:	85ce                	mv	a1,s3
     e50:	00006517          	auipc	a0,0x6
     e54:	80050513          	addi	a0,a0,-2048 # 6650 <malloc+0x644>
     e58:	00005097          	auipc	ra,0x5
     e5c:	0f6080e7          	jalr	246(ra) # 5f4e <printf>
    exit(1);
     e60:	4505                	li	a0,1
     e62:	00005097          	auipc	ra,0x5
     e66:	d64080e7          	jalr	-668(ra) # 5bc6 <exit>
    printf("%s: open unlinkread failed\n", s);
     e6a:	85ce                	mv	a1,s3
     e6c:	00006517          	auipc	a0,0x6
     e70:	80c50513          	addi	a0,a0,-2036 # 6678 <malloc+0x66c>
     e74:	00005097          	auipc	ra,0x5
     e78:	0da080e7          	jalr	218(ra) # 5f4e <printf>
    exit(1);
     e7c:	4505                	li	a0,1
     e7e:	00005097          	auipc	ra,0x5
     e82:	d48080e7          	jalr	-696(ra) # 5bc6 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e86:	85ce                	mv	a1,s3
     e88:	00006517          	auipc	a0,0x6
     e8c:	81050513          	addi	a0,a0,-2032 # 6698 <malloc+0x68c>
     e90:	00005097          	auipc	ra,0x5
     e94:	0be080e7          	jalr	190(ra) # 5f4e <printf>
    exit(1);
     e98:	4505                	li	a0,1
     e9a:	00005097          	auipc	ra,0x5
     e9e:	d2c080e7          	jalr	-724(ra) # 5bc6 <exit>
    printf("%s: unlinkread read failed", s);
     ea2:	85ce                	mv	a1,s3
     ea4:	00006517          	auipc	a0,0x6
     ea8:	81c50513          	addi	a0,a0,-2020 # 66c0 <malloc+0x6b4>
     eac:	00005097          	auipc	ra,0x5
     eb0:	0a2080e7          	jalr	162(ra) # 5f4e <printf>
    exit(1);
     eb4:	4505                	li	a0,1
     eb6:	00005097          	auipc	ra,0x5
     eba:	d10080e7          	jalr	-752(ra) # 5bc6 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ebe:	85ce                	mv	a1,s3
     ec0:	00006517          	auipc	a0,0x6
     ec4:	82050513          	addi	a0,a0,-2016 # 66e0 <malloc+0x6d4>
     ec8:	00005097          	auipc	ra,0x5
     ecc:	086080e7          	jalr	134(ra) # 5f4e <printf>
    exit(1);
     ed0:	4505                	li	a0,1
     ed2:	00005097          	auipc	ra,0x5
     ed6:	cf4080e7          	jalr	-780(ra) # 5bc6 <exit>
    printf("%s: unlinkread write failed\n", s);
     eda:	85ce                	mv	a1,s3
     edc:	00006517          	auipc	a0,0x6
     ee0:	82450513          	addi	a0,a0,-2012 # 6700 <malloc+0x6f4>
     ee4:	00005097          	auipc	ra,0x5
     ee8:	06a080e7          	jalr	106(ra) # 5f4e <printf>
    exit(1);
     eec:	4505                	li	a0,1
     eee:	00005097          	auipc	ra,0x5
     ef2:	cd8080e7          	jalr	-808(ra) # 5bc6 <exit>

0000000000000ef6 <linktest>:
{
     ef6:	1101                	addi	sp,sp,-32
     ef8:	ec06                	sd	ra,24(sp)
     efa:	e822                	sd	s0,16(sp)
     efc:	e426                	sd	s1,8(sp)
     efe:	e04a                	sd	s2,0(sp)
     f00:	1000                	addi	s0,sp,32
     f02:	892a                	mv	s2,a0
  unlink("lf1");
     f04:	00006517          	auipc	a0,0x6
     f08:	81c50513          	addi	a0,a0,-2020 # 6720 <malloc+0x714>
     f0c:	00005097          	auipc	ra,0x5
     f10:	d0a080e7          	jalr	-758(ra) # 5c16 <unlink>
  unlink("lf2");
     f14:	00006517          	auipc	a0,0x6
     f18:	81450513          	addi	a0,a0,-2028 # 6728 <malloc+0x71c>
     f1c:	00005097          	auipc	ra,0x5
     f20:	cfa080e7          	jalr	-774(ra) # 5c16 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f24:	20200593          	li	a1,514
     f28:	00005517          	auipc	a0,0x5
     f2c:	7f850513          	addi	a0,a0,2040 # 6720 <malloc+0x714>
     f30:	00005097          	auipc	ra,0x5
     f34:	cd6080e7          	jalr	-810(ra) # 5c06 <open>
  if(fd < 0){
     f38:	10054763          	bltz	a0,1046 <linktest+0x150>
     f3c:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     f3e:	4615                	li	a2,5
     f40:	00005597          	auipc	a1,0x5
     f44:	73058593          	addi	a1,a1,1840 # 6670 <malloc+0x664>
     f48:	00005097          	auipc	ra,0x5
     f4c:	c9e080e7          	jalr	-866(ra) # 5be6 <write>
     f50:	4795                	li	a5,5
     f52:	10f51863          	bne	a0,a5,1062 <linktest+0x16c>
  close(fd);
     f56:	8526                	mv	a0,s1
     f58:	00005097          	auipc	ra,0x5
     f5c:	c96080e7          	jalr	-874(ra) # 5bee <close>
  if(link("lf1", "lf2") < 0){
     f60:	00005597          	auipc	a1,0x5
     f64:	7c858593          	addi	a1,a1,1992 # 6728 <malloc+0x71c>
     f68:	00005517          	auipc	a0,0x5
     f6c:	7b850513          	addi	a0,a0,1976 # 6720 <malloc+0x714>
     f70:	00005097          	auipc	ra,0x5
     f74:	cb6080e7          	jalr	-842(ra) # 5c26 <link>
     f78:	10054363          	bltz	a0,107e <linktest+0x188>
  unlink("lf1");
     f7c:	00005517          	auipc	a0,0x5
     f80:	7a450513          	addi	a0,a0,1956 # 6720 <malloc+0x714>
     f84:	00005097          	auipc	ra,0x5
     f88:	c92080e7          	jalr	-878(ra) # 5c16 <unlink>
  if(open("lf1", 0) >= 0){
     f8c:	4581                	li	a1,0
     f8e:	00005517          	auipc	a0,0x5
     f92:	79250513          	addi	a0,a0,1938 # 6720 <malloc+0x714>
     f96:	00005097          	auipc	ra,0x5
     f9a:	c70080e7          	jalr	-912(ra) # 5c06 <open>
     f9e:	0e055e63          	bgez	a0,109a <linktest+0x1a4>
  fd = open("lf2", 0);
     fa2:	4581                	li	a1,0
     fa4:	00005517          	auipc	a0,0x5
     fa8:	78450513          	addi	a0,a0,1924 # 6728 <malloc+0x71c>
     fac:	00005097          	auipc	ra,0x5
     fb0:	c5a080e7          	jalr	-934(ra) # 5c06 <open>
     fb4:	84aa                	mv	s1,a0
  if(fd < 0){
     fb6:	10054063          	bltz	a0,10b6 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     fba:	660d                	lui	a2,0x3
     fbc:	0000c597          	auipc	a1,0xc
     fc0:	c9c58593          	addi	a1,a1,-868 # cc58 <buf>
     fc4:	00005097          	auipc	ra,0x5
     fc8:	c1a080e7          	jalr	-998(ra) # 5bde <read>
     fcc:	4795                	li	a5,5
     fce:	10f51263          	bne	a0,a5,10d2 <linktest+0x1dc>
  close(fd);
     fd2:	8526                	mv	a0,s1
     fd4:	00005097          	auipc	ra,0x5
     fd8:	c1a080e7          	jalr	-998(ra) # 5bee <close>
  if(link("lf2", "lf2") >= 0){
     fdc:	00005597          	auipc	a1,0x5
     fe0:	74c58593          	addi	a1,a1,1868 # 6728 <malloc+0x71c>
     fe4:	852e                	mv	a0,a1
     fe6:	00005097          	auipc	ra,0x5
     fea:	c40080e7          	jalr	-960(ra) # 5c26 <link>
     fee:	10055063          	bgez	a0,10ee <linktest+0x1f8>
  unlink("lf2");
     ff2:	00005517          	auipc	a0,0x5
     ff6:	73650513          	addi	a0,a0,1846 # 6728 <malloc+0x71c>
     ffa:	00005097          	auipc	ra,0x5
     ffe:	c1c080e7          	jalr	-996(ra) # 5c16 <unlink>
  if(link("lf2", "lf1") >= 0){
    1002:	00005597          	auipc	a1,0x5
    1006:	71e58593          	addi	a1,a1,1822 # 6720 <malloc+0x714>
    100a:	00005517          	auipc	a0,0x5
    100e:	71e50513          	addi	a0,a0,1822 # 6728 <malloc+0x71c>
    1012:	00005097          	auipc	ra,0x5
    1016:	c14080e7          	jalr	-1004(ra) # 5c26 <link>
    101a:	0e055863          	bgez	a0,110a <linktest+0x214>
  if(link(".", "lf1") >= 0){
    101e:	00005597          	auipc	a1,0x5
    1022:	70258593          	addi	a1,a1,1794 # 6720 <malloc+0x714>
    1026:	00006517          	auipc	a0,0x6
    102a:	80a50513          	addi	a0,a0,-2038 # 6830 <malloc+0x824>
    102e:	00005097          	auipc	ra,0x5
    1032:	bf8080e7          	jalr	-1032(ra) # 5c26 <link>
    1036:	0e055863          	bgez	a0,1126 <linktest+0x230>
}
    103a:	60e2                	ld	ra,24(sp)
    103c:	6442                	ld	s0,16(sp)
    103e:	64a2                	ld	s1,8(sp)
    1040:	6902                	ld	s2,0(sp)
    1042:	6105                	addi	sp,sp,32
    1044:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1046:	85ca                	mv	a1,s2
    1048:	00005517          	auipc	a0,0x5
    104c:	6e850513          	addi	a0,a0,1768 # 6730 <malloc+0x724>
    1050:	00005097          	auipc	ra,0x5
    1054:	efe080e7          	jalr	-258(ra) # 5f4e <printf>
    exit(1);
    1058:	4505                	li	a0,1
    105a:	00005097          	auipc	ra,0x5
    105e:	b6c080e7          	jalr	-1172(ra) # 5bc6 <exit>
    printf("%s: write lf1 failed\n", s);
    1062:	85ca                	mv	a1,s2
    1064:	00005517          	auipc	a0,0x5
    1068:	6e450513          	addi	a0,a0,1764 # 6748 <malloc+0x73c>
    106c:	00005097          	auipc	ra,0x5
    1070:	ee2080e7          	jalr	-286(ra) # 5f4e <printf>
    exit(1);
    1074:	4505                	li	a0,1
    1076:	00005097          	auipc	ra,0x5
    107a:	b50080e7          	jalr	-1200(ra) # 5bc6 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    107e:	85ca                	mv	a1,s2
    1080:	00005517          	auipc	a0,0x5
    1084:	6e050513          	addi	a0,a0,1760 # 6760 <malloc+0x754>
    1088:	00005097          	auipc	ra,0x5
    108c:	ec6080e7          	jalr	-314(ra) # 5f4e <printf>
    exit(1);
    1090:	4505                	li	a0,1
    1092:	00005097          	auipc	ra,0x5
    1096:	b34080e7          	jalr	-1228(ra) # 5bc6 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    109a:	85ca                	mv	a1,s2
    109c:	00005517          	auipc	a0,0x5
    10a0:	6e450513          	addi	a0,a0,1764 # 6780 <malloc+0x774>
    10a4:	00005097          	auipc	ra,0x5
    10a8:	eaa080e7          	jalr	-342(ra) # 5f4e <printf>
    exit(1);
    10ac:	4505                	li	a0,1
    10ae:	00005097          	auipc	ra,0x5
    10b2:	b18080e7          	jalr	-1256(ra) # 5bc6 <exit>
    printf("%s: open lf2 failed\n", s);
    10b6:	85ca                	mv	a1,s2
    10b8:	00005517          	auipc	a0,0x5
    10bc:	6f850513          	addi	a0,a0,1784 # 67b0 <malloc+0x7a4>
    10c0:	00005097          	auipc	ra,0x5
    10c4:	e8e080e7          	jalr	-370(ra) # 5f4e <printf>
    exit(1);
    10c8:	4505                	li	a0,1
    10ca:	00005097          	auipc	ra,0x5
    10ce:	afc080e7          	jalr	-1284(ra) # 5bc6 <exit>
    printf("%s: read lf2 failed\n", s);
    10d2:	85ca                	mv	a1,s2
    10d4:	00005517          	auipc	a0,0x5
    10d8:	6f450513          	addi	a0,a0,1780 # 67c8 <malloc+0x7bc>
    10dc:	00005097          	auipc	ra,0x5
    10e0:	e72080e7          	jalr	-398(ra) # 5f4e <printf>
    exit(1);
    10e4:	4505                	li	a0,1
    10e6:	00005097          	auipc	ra,0x5
    10ea:	ae0080e7          	jalr	-1312(ra) # 5bc6 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    10ee:	85ca                	mv	a1,s2
    10f0:	00005517          	auipc	a0,0x5
    10f4:	6f050513          	addi	a0,a0,1776 # 67e0 <malloc+0x7d4>
    10f8:	00005097          	auipc	ra,0x5
    10fc:	e56080e7          	jalr	-426(ra) # 5f4e <printf>
    exit(1);
    1100:	4505                	li	a0,1
    1102:	00005097          	auipc	ra,0x5
    1106:	ac4080e7          	jalr	-1340(ra) # 5bc6 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    110a:	85ca                	mv	a1,s2
    110c:	00005517          	auipc	a0,0x5
    1110:	6fc50513          	addi	a0,a0,1788 # 6808 <malloc+0x7fc>
    1114:	00005097          	auipc	ra,0x5
    1118:	e3a080e7          	jalr	-454(ra) # 5f4e <printf>
    exit(1);
    111c:	4505                	li	a0,1
    111e:	00005097          	auipc	ra,0x5
    1122:	aa8080e7          	jalr	-1368(ra) # 5bc6 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1126:	85ca                	mv	a1,s2
    1128:	00005517          	auipc	a0,0x5
    112c:	71050513          	addi	a0,a0,1808 # 6838 <malloc+0x82c>
    1130:	00005097          	auipc	ra,0x5
    1134:	e1e080e7          	jalr	-482(ra) # 5f4e <printf>
    exit(1);
    1138:	4505                	li	a0,1
    113a:	00005097          	auipc	ra,0x5
    113e:	a8c080e7          	jalr	-1396(ra) # 5bc6 <exit>

0000000000001142 <validatetest>:
{
    1142:	7139                	addi	sp,sp,-64
    1144:	fc06                	sd	ra,56(sp)
    1146:	f822                	sd	s0,48(sp)
    1148:	f426                	sd	s1,40(sp)
    114a:	f04a                	sd	s2,32(sp)
    114c:	ec4e                	sd	s3,24(sp)
    114e:	e852                	sd	s4,16(sp)
    1150:	e456                	sd	s5,8(sp)
    1152:	e05a                	sd	s6,0(sp)
    1154:	0080                	addi	s0,sp,64
    1156:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1158:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    115a:	00005997          	auipc	s3,0x5
    115e:	6fe98993          	addi	s3,s3,1790 # 6858 <malloc+0x84c>
    1162:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1164:	6a85                	lui	s5,0x1
    1166:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    116a:	85a6                	mv	a1,s1
    116c:	854e                	mv	a0,s3
    116e:	00005097          	auipc	ra,0x5
    1172:	ab8080e7          	jalr	-1352(ra) # 5c26 <link>
    1176:	01251f63          	bne	a0,s2,1194 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    117a:	94d6                	add	s1,s1,s5
    117c:	ff4497e3          	bne	s1,s4,116a <validatetest+0x28>
}
    1180:	70e2                	ld	ra,56(sp)
    1182:	7442                	ld	s0,48(sp)
    1184:	74a2                	ld	s1,40(sp)
    1186:	7902                	ld	s2,32(sp)
    1188:	69e2                	ld	s3,24(sp)
    118a:	6a42                	ld	s4,16(sp)
    118c:	6aa2                	ld	s5,8(sp)
    118e:	6b02                	ld	s6,0(sp)
    1190:	6121                	addi	sp,sp,64
    1192:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1194:	85da                	mv	a1,s6
    1196:	00005517          	auipc	a0,0x5
    119a:	6d250513          	addi	a0,a0,1746 # 6868 <malloc+0x85c>
    119e:	00005097          	auipc	ra,0x5
    11a2:	db0080e7          	jalr	-592(ra) # 5f4e <printf>
      exit(1);
    11a6:	4505                	li	a0,1
    11a8:	00005097          	auipc	ra,0x5
    11ac:	a1e080e7          	jalr	-1506(ra) # 5bc6 <exit>

00000000000011b0 <bigdir>:
{
    11b0:	715d                	addi	sp,sp,-80
    11b2:	e486                	sd	ra,72(sp)
    11b4:	e0a2                	sd	s0,64(sp)
    11b6:	fc26                	sd	s1,56(sp)
    11b8:	f84a                	sd	s2,48(sp)
    11ba:	f44e                	sd	s3,40(sp)
    11bc:	f052                	sd	s4,32(sp)
    11be:	ec56                	sd	s5,24(sp)
    11c0:	e85a                	sd	s6,16(sp)
    11c2:	0880                	addi	s0,sp,80
    11c4:	89aa                	mv	s3,a0
  unlink("bd");
    11c6:	00005517          	auipc	a0,0x5
    11ca:	6c250513          	addi	a0,a0,1730 # 6888 <malloc+0x87c>
    11ce:	00005097          	auipc	ra,0x5
    11d2:	a48080e7          	jalr	-1464(ra) # 5c16 <unlink>
  fd = open("bd", O_CREATE);
    11d6:	20000593          	li	a1,512
    11da:	00005517          	auipc	a0,0x5
    11de:	6ae50513          	addi	a0,a0,1710 # 6888 <malloc+0x87c>
    11e2:	00005097          	auipc	ra,0x5
    11e6:	a24080e7          	jalr	-1500(ra) # 5c06 <open>
  if(fd < 0){
    11ea:	0c054963          	bltz	a0,12bc <bigdir+0x10c>
  close(fd);
    11ee:	00005097          	auipc	ra,0x5
    11f2:	a00080e7          	jalr	-1536(ra) # 5bee <close>
  for(i = 0; i < N; i++){
    11f6:	4901                	li	s2,0
    name[0] = 'x';
    11f8:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    11fc:	00005a17          	auipc	s4,0x5
    1200:	68ca0a13          	addi	s4,s4,1676 # 6888 <malloc+0x87c>
  for(i = 0; i < N; i++){
    1204:	1f400b13          	li	s6,500
    name[0] = 'x';
    1208:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    120c:	41f9579b          	sraiw	a5,s2,0x1f
    1210:	01a7d71b          	srliw	a4,a5,0x1a
    1214:	012707bb          	addw	a5,a4,s2
    1218:	4067d69b          	sraiw	a3,a5,0x6
    121c:	0306869b          	addiw	a3,a3,48
    1220:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1224:	03f7f793          	andi	a5,a5,63
    1228:	9f99                	subw	a5,a5,a4
    122a:	0307879b          	addiw	a5,a5,48
    122e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1232:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1236:	fb040593          	addi	a1,s0,-80
    123a:	8552                	mv	a0,s4
    123c:	00005097          	auipc	ra,0x5
    1240:	9ea080e7          	jalr	-1558(ra) # 5c26 <link>
    1244:	84aa                	mv	s1,a0
    1246:	e949                	bnez	a0,12d8 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1248:	2905                	addiw	s2,s2,1
    124a:	fb691fe3          	bne	s2,s6,1208 <bigdir+0x58>
  unlink("bd");
    124e:	00005517          	auipc	a0,0x5
    1252:	63a50513          	addi	a0,a0,1594 # 6888 <malloc+0x87c>
    1256:	00005097          	auipc	ra,0x5
    125a:	9c0080e7          	jalr	-1600(ra) # 5c16 <unlink>
    name[0] = 'x';
    125e:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1262:	1f400a13          	li	s4,500
    name[0] = 'x';
    1266:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    126a:	41f4d79b          	sraiw	a5,s1,0x1f
    126e:	01a7d71b          	srliw	a4,a5,0x1a
    1272:	009707bb          	addw	a5,a4,s1
    1276:	4067d69b          	sraiw	a3,a5,0x6
    127a:	0306869b          	addiw	a3,a3,48
    127e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1282:	03f7f793          	andi	a5,a5,63
    1286:	9f99                	subw	a5,a5,a4
    1288:	0307879b          	addiw	a5,a5,48
    128c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1290:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1294:	fb040513          	addi	a0,s0,-80
    1298:	00005097          	auipc	ra,0x5
    129c:	97e080e7          	jalr	-1666(ra) # 5c16 <unlink>
    12a0:	ed21                	bnez	a0,12f8 <bigdir+0x148>
  for(i = 0; i < N; i++){
    12a2:	2485                	addiw	s1,s1,1
    12a4:	fd4491e3          	bne	s1,s4,1266 <bigdir+0xb6>
}
    12a8:	60a6                	ld	ra,72(sp)
    12aa:	6406                	ld	s0,64(sp)
    12ac:	74e2                	ld	s1,56(sp)
    12ae:	7942                	ld	s2,48(sp)
    12b0:	79a2                	ld	s3,40(sp)
    12b2:	7a02                	ld	s4,32(sp)
    12b4:	6ae2                	ld	s5,24(sp)
    12b6:	6b42                	ld	s6,16(sp)
    12b8:	6161                	addi	sp,sp,80
    12ba:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12bc:	85ce                	mv	a1,s3
    12be:	00005517          	auipc	a0,0x5
    12c2:	5d250513          	addi	a0,a0,1490 # 6890 <malloc+0x884>
    12c6:	00005097          	auipc	ra,0x5
    12ca:	c88080e7          	jalr	-888(ra) # 5f4e <printf>
    exit(1);
    12ce:	4505                	li	a0,1
    12d0:	00005097          	auipc	ra,0x5
    12d4:	8f6080e7          	jalr	-1802(ra) # 5bc6 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12d8:	fb040613          	addi	a2,s0,-80
    12dc:	85ce                	mv	a1,s3
    12de:	00005517          	auipc	a0,0x5
    12e2:	5d250513          	addi	a0,a0,1490 # 68b0 <malloc+0x8a4>
    12e6:	00005097          	auipc	ra,0x5
    12ea:	c68080e7          	jalr	-920(ra) # 5f4e <printf>
      exit(1);
    12ee:	4505                	li	a0,1
    12f0:	00005097          	auipc	ra,0x5
    12f4:	8d6080e7          	jalr	-1834(ra) # 5bc6 <exit>
      printf("%s: bigdir unlink failed", s);
    12f8:	85ce                	mv	a1,s3
    12fa:	00005517          	auipc	a0,0x5
    12fe:	5d650513          	addi	a0,a0,1494 # 68d0 <malloc+0x8c4>
    1302:	00005097          	auipc	ra,0x5
    1306:	c4c080e7          	jalr	-948(ra) # 5f4e <printf>
      exit(1);
    130a:	4505                	li	a0,1
    130c:	00005097          	auipc	ra,0x5
    1310:	8ba080e7          	jalr	-1862(ra) # 5bc6 <exit>

0000000000001314 <pgbug>:
{
    1314:	7179                	addi	sp,sp,-48
    1316:	f406                	sd	ra,40(sp)
    1318:	f022                	sd	s0,32(sp)
    131a:	ec26                	sd	s1,24(sp)
    131c:	1800                	addi	s0,sp,48
  argv[0] = 0;
    131e:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1322:	00008497          	auipc	s1,0x8
    1326:	cde48493          	addi	s1,s1,-802 # 9000 <big>
    132a:	fd840593          	addi	a1,s0,-40
    132e:	6088                	ld	a0,0(s1)
    1330:	00005097          	auipc	ra,0x5
    1334:	8ce080e7          	jalr	-1842(ra) # 5bfe <exec>
  pipe(big);
    1338:	6088                	ld	a0,0(s1)
    133a:	00005097          	auipc	ra,0x5
    133e:	89c080e7          	jalr	-1892(ra) # 5bd6 <pipe>
  exit(0);
    1342:	4501                	li	a0,0
    1344:	00005097          	auipc	ra,0x5
    1348:	882080e7          	jalr	-1918(ra) # 5bc6 <exit>

000000000000134c <badarg>:
{
    134c:	7139                	addi	sp,sp,-64
    134e:	fc06                	sd	ra,56(sp)
    1350:	f822                	sd	s0,48(sp)
    1352:	f426                	sd	s1,40(sp)
    1354:	f04a                	sd	s2,32(sp)
    1356:	ec4e                	sd	s3,24(sp)
    1358:	0080                	addi	s0,sp,64
    135a:	64b1                	lui	s1,0xc
    135c:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1e08>
    argv[0] = (char*)0xffffffff;
    1360:	597d                	li	s2,-1
    1362:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    1366:	00005997          	auipc	s3,0x5
    136a:	de298993          	addi	s3,s3,-542 # 6148 <malloc+0x13c>
    argv[0] = (char*)0xffffffff;
    136e:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1372:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1376:	fc040593          	addi	a1,s0,-64
    137a:	854e                	mv	a0,s3
    137c:	00005097          	auipc	ra,0x5
    1380:	882080e7          	jalr	-1918(ra) # 5bfe <exec>
  for(int i = 0; i < 50000; i++){
    1384:	34fd                	addiw	s1,s1,-1
    1386:	f4e5                	bnez	s1,136e <badarg+0x22>
  exit(0);
    1388:	4501                	li	a0,0
    138a:	00005097          	auipc	ra,0x5
    138e:	83c080e7          	jalr	-1988(ra) # 5bc6 <exit>

0000000000001392 <copyinstr2>:
{
    1392:	7155                	addi	sp,sp,-208
    1394:	e586                	sd	ra,200(sp)
    1396:	e1a2                	sd	s0,192(sp)
    1398:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    139a:	f6840793          	addi	a5,s0,-152
    139e:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    13a2:	07800713          	li	a4,120
    13a6:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    13aa:	0785                	addi	a5,a5,1
    13ac:	fed79de3          	bne	a5,a3,13a6 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13b0:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13b4:	f6840513          	addi	a0,s0,-152
    13b8:	00005097          	auipc	ra,0x5
    13bc:	85e080e7          	jalr	-1954(ra) # 5c16 <unlink>
  if(ret != -1){
    13c0:	57fd                	li	a5,-1
    13c2:	0ef51063          	bne	a0,a5,14a2 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13c6:	20100593          	li	a1,513
    13ca:	f6840513          	addi	a0,s0,-152
    13ce:	00005097          	auipc	ra,0x5
    13d2:	838080e7          	jalr	-1992(ra) # 5c06 <open>
  if(fd != -1){
    13d6:	57fd                	li	a5,-1
    13d8:	0ef51563          	bne	a0,a5,14c2 <copyinstr2+0x130>
  ret = link(b, b);
    13dc:	f6840593          	addi	a1,s0,-152
    13e0:	852e                	mv	a0,a1
    13e2:	00005097          	auipc	ra,0x5
    13e6:	844080e7          	jalr	-1980(ra) # 5c26 <link>
  if(ret != -1){
    13ea:	57fd                	li	a5,-1
    13ec:	0ef51b63          	bne	a0,a5,14e2 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    13f0:	00006797          	auipc	a5,0x6
    13f4:	72078793          	addi	a5,a5,1824 # 7b10 <malloc+0x1b04>
    13f8:	f4f43c23          	sd	a5,-168(s0)
    13fc:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1400:	f5840593          	addi	a1,s0,-168
    1404:	f6840513          	addi	a0,s0,-152
    1408:	00004097          	auipc	ra,0x4
    140c:	7f6080e7          	jalr	2038(ra) # 5bfe <exec>
  if(ret != -1){
    1410:	57fd                	li	a5,-1
    1412:	0ef51963          	bne	a0,a5,1504 <copyinstr2+0x172>
  int pid = fork();
    1416:	00004097          	auipc	ra,0x4
    141a:	7a8080e7          	jalr	1960(ra) # 5bbe <fork>
  if(pid < 0){
    141e:	10054363          	bltz	a0,1524 <copyinstr2+0x192>
  if(pid == 0){
    1422:	12051463          	bnez	a0,154a <copyinstr2+0x1b8>
    1426:	00008797          	auipc	a5,0x8
    142a:	11a78793          	addi	a5,a5,282 # 9540 <big.0>
    142e:	00009697          	auipc	a3,0x9
    1432:	11268693          	addi	a3,a3,274 # a540 <big.0+0x1000>
      big[i] = 'x';
    1436:	07800713          	li	a4,120
    143a:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    143e:	0785                	addi	a5,a5,1
    1440:	fed79de3          	bne	a5,a3,143a <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1444:	00009797          	auipc	a5,0x9
    1448:	0e078e23          	sb	zero,252(a5) # a540 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    144c:	00007797          	auipc	a5,0x7
    1450:	0e478793          	addi	a5,a5,228 # 8530 <malloc+0x2524>
    1454:	6390                	ld	a2,0(a5)
    1456:	6794                	ld	a3,8(a5)
    1458:	6b98                	ld	a4,16(a5)
    145a:	6f9c                	ld	a5,24(a5)
    145c:	f2c43823          	sd	a2,-208(s0)
    1460:	f2d43c23          	sd	a3,-200(s0)
    1464:	f4e43023          	sd	a4,-192(s0)
    1468:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    146c:	f3040593          	addi	a1,s0,-208
    1470:	00005517          	auipc	a0,0x5
    1474:	cd850513          	addi	a0,a0,-808 # 6148 <malloc+0x13c>
    1478:	00004097          	auipc	ra,0x4
    147c:	786080e7          	jalr	1926(ra) # 5bfe <exec>
    if(ret != -1){
    1480:	57fd                	li	a5,-1
    1482:	0af50e63          	beq	a0,a5,153e <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1486:	55fd                	li	a1,-1
    1488:	00005517          	auipc	a0,0x5
    148c:	4f050513          	addi	a0,a0,1264 # 6978 <malloc+0x96c>
    1490:	00005097          	auipc	ra,0x5
    1494:	abe080e7          	jalr	-1346(ra) # 5f4e <printf>
      exit(1);
    1498:	4505                	li	a0,1
    149a:	00004097          	auipc	ra,0x4
    149e:	72c080e7          	jalr	1836(ra) # 5bc6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14a2:	862a                	mv	a2,a0
    14a4:	f6840593          	addi	a1,s0,-152
    14a8:	00005517          	auipc	a0,0x5
    14ac:	44850513          	addi	a0,a0,1096 # 68f0 <malloc+0x8e4>
    14b0:	00005097          	auipc	ra,0x5
    14b4:	a9e080e7          	jalr	-1378(ra) # 5f4e <printf>
    exit(1);
    14b8:	4505                	li	a0,1
    14ba:	00004097          	auipc	ra,0x4
    14be:	70c080e7          	jalr	1804(ra) # 5bc6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14c2:	862a                	mv	a2,a0
    14c4:	f6840593          	addi	a1,s0,-152
    14c8:	00005517          	auipc	a0,0x5
    14cc:	44850513          	addi	a0,a0,1096 # 6910 <malloc+0x904>
    14d0:	00005097          	auipc	ra,0x5
    14d4:	a7e080e7          	jalr	-1410(ra) # 5f4e <printf>
    exit(1);
    14d8:	4505                	li	a0,1
    14da:	00004097          	auipc	ra,0x4
    14de:	6ec080e7          	jalr	1772(ra) # 5bc6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14e2:	86aa                	mv	a3,a0
    14e4:	f6840613          	addi	a2,s0,-152
    14e8:	85b2                	mv	a1,a2
    14ea:	00005517          	auipc	a0,0x5
    14ee:	44650513          	addi	a0,a0,1094 # 6930 <malloc+0x924>
    14f2:	00005097          	auipc	ra,0x5
    14f6:	a5c080e7          	jalr	-1444(ra) # 5f4e <printf>
    exit(1);
    14fa:	4505                	li	a0,1
    14fc:	00004097          	auipc	ra,0x4
    1500:	6ca080e7          	jalr	1738(ra) # 5bc6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1504:	567d                	li	a2,-1
    1506:	f6840593          	addi	a1,s0,-152
    150a:	00005517          	auipc	a0,0x5
    150e:	44e50513          	addi	a0,a0,1102 # 6958 <malloc+0x94c>
    1512:	00005097          	auipc	ra,0x5
    1516:	a3c080e7          	jalr	-1476(ra) # 5f4e <printf>
    exit(1);
    151a:	4505                	li	a0,1
    151c:	00004097          	auipc	ra,0x4
    1520:	6aa080e7          	jalr	1706(ra) # 5bc6 <exit>
    printf("fork failed\n");
    1524:	00006517          	auipc	a0,0x6
    1528:	89c50513          	addi	a0,a0,-1892 # 6dc0 <malloc+0xdb4>
    152c:	00005097          	auipc	ra,0x5
    1530:	a22080e7          	jalr	-1502(ra) # 5f4e <printf>
    exit(1);
    1534:	4505                	li	a0,1
    1536:	00004097          	auipc	ra,0x4
    153a:	690080e7          	jalr	1680(ra) # 5bc6 <exit>
    exit(747); // OK
    153e:	2eb00513          	li	a0,747
    1542:	00004097          	auipc	ra,0x4
    1546:	684080e7          	jalr	1668(ra) # 5bc6 <exit>
  int st = 0;
    154a:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    154e:	f5440513          	addi	a0,s0,-172
    1552:	00004097          	auipc	ra,0x4
    1556:	67c080e7          	jalr	1660(ra) # 5bce <wait>
  if(st != 747){
    155a:	f5442703          	lw	a4,-172(s0)
    155e:	2eb00793          	li	a5,747
    1562:	00f71663          	bne	a4,a5,156e <copyinstr2+0x1dc>
}
    1566:	60ae                	ld	ra,200(sp)
    1568:	640e                	ld	s0,192(sp)
    156a:	6169                	addi	sp,sp,208
    156c:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    156e:	00005517          	auipc	a0,0x5
    1572:	43250513          	addi	a0,a0,1074 # 69a0 <malloc+0x994>
    1576:	00005097          	auipc	ra,0x5
    157a:	9d8080e7          	jalr	-1576(ra) # 5f4e <printf>
    exit(1);
    157e:	4505                	li	a0,1
    1580:	00004097          	auipc	ra,0x4
    1584:	646080e7          	jalr	1606(ra) # 5bc6 <exit>

0000000000001588 <truncate3>:
{
    1588:	7159                	addi	sp,sp,-112
    158a:	f486                	sd	ra,104(sp)
    158c:	f0a2                	sd	s0,96(sp)
    158e:	eca6                	sd	s1,88(sp)
    1590:	e8ca                	sd	s2,80(sp)
    1592:	e4ce                	sd	s3,72(sp)
    1594:	e0d2                	sd	s4,64(sp)
    1596:	fc56                	sd	s5,56(sp)
    1598:	1880                	addi	s0,sp,112
    159a:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    159c:	60100593          	li	a1,1537
    15a0:	00005517          	auipc	a0,0x5
    15a4:	c0050513          	addi	a0,a0,-1024 # 61a0 <malloc+0x194>
    15a8:	00004097          	auipc	ra,0x4
    15ac:	65e080e7          	jalr	1630(ra) # 5c06 <open>
    15b0:	00004097          	auipc	ra,0x4
    15b4:	63e080e7          	jalr	1598(ra) # 5bee <close>
  pid = fork();
    15b8:	00004097          	auipc	ra,0x4
    15bc:	606080e7          	jalr	1542(ra) # 5bbe <fork>
  if(pid < 0){
    15c0:	08054063          	bltz	a0,1640 <truncate3+0xb8>
  if(pid == 0){
    15c4:	e969                	bnez	a0,1696 <truncate3+0x10e>
    15c6:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15ca:	00005a17          	auipc	s4,0x5
    15ce:	bd6a0a13          	addi	s4,s4,-1066 # 61a0 <malloc+0x194>
      int n = write(fd, "1234567890", 10);
    15d2:	00005a97          	auipc	s5,0x5
    15d6:	42ea8a93          	addi	s5,s5,1070 # 6a00 <malloc+0x9f4>
      int fd = open("truncfile", O_WRONLY);
    15da:	4585                	li	a1,1
    15dc:	8552                	mv	a0,s4
    15de:	00004097          	auipc	ra,0x4
    15e2:	628080e7          	jalr	1576(ra) # 5c06 <open>
    15e6:	84aa                	mv	s1,a0
      if(fd < 0){
    15e8:	06054a63          	bltz	a0,165c <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    15ec:	4629                	li	a2,10
    15ee:	85d6                	mv	a1,s5
    15f0:	00004097          	auipc	ra,0x4
    15f4:	5f6080e7          	jalr	1526(ra) # 5be6 <write>
      if(n != 10){
    15f8:	47a9                	li	a5,10
    15fa:	06f51f63          	bne	a0,a5,1678 <truncate3+0xf0>
      close(fd);
    15fe:	8526                	mv	a0,s1
    1600:	00004097          	auipc	ra,0x4
    1604:	5ee080e7          	jalr	1518(ra) # 5bee <close>
      fd = open("truncfile", O_RDONLY);
    1608:	4581                	li	a1,0
    160a:	8552                	mv	a0,s4
    160c:	00004097          	auipc	ra,0x4
    1610:	5fa080e7          	jalr	1530(ra) # 5c06 <open>
    1614:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1616:	02000613          	li	a2,32
    161a:	f9840593          	addi	a1,s0,-104
    161e:	00004097          	auipc	ra,0x4
    1622:	5c0080e7          	jalr	1472(ra) # 5bde <read>
      close(fd);
    1626:	8526                	mv	a0,s1
    1628:	00004097          	auipc	ra,0x4
    162c:	5c6080e7          	jalr	1478(ra) # 5bee <close>
    for(int i = 0; i < 100; i++){
    1630:	39fd                	addiw	s3,s3,-1
    1632:	fa0994e3          	bnez	s3,15da <truncate3+0x52>
    exit(0);
    1636:	4501                	li	a0,0
    1638:	00004097          	auipc	ra,0x4
    163c:	58e080e7          	jalr	1422(ra) # 5bc6 <exit>
    printf("%s: fork failed\n", s);
    1640:	85ca                	mv	a1,s2
    1642:	00005517          	auipc	a0,0x5
    1646:	38e50513          	addi	a0,a0,910 # 69d0 <malloc+0x9c4>
    164a:	00005097          	auipc	ra,0x5
    164e:	904080e7          	jalr	-1788(ra) # 5f4e <printf>
    exit(1);
    1652:	4505                	li	a0,1
    1654:	00004097          	auipc	ra,0x4
    1658:	572080e7          	jalr	1394(ra) # 5bc6 <exit>
        printf("%s: open failed\n", s);
    165c:	85ca                	mv	a1,s2
    165e:	00005517          	auipc	a0,0x5
    1662:	38a50513          	addi	a0,a0,906 # 69e8 <malloc+0x9dc>
    1666:	00005097          	auipc	ra,0x5
    166a:	8e8080e7          	jalr	-1816(ra) # 5f4e <printf>
        exit(1);
    166e:	4505                	li	a0,1
    1670:	00004097          	auipc	ra,0x4
    1674:	556080e7          	jalr	1366(ra) # 5bc6 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1678:	862a                	mv	a2,a0
    167a:	85ca                	mv	a1,s2
    167c:	00005517          	auipc	a0,0x5
    1680:	39450513          	addi	a0,a0,916 # 6a10 <malloc+0xa04>
    1684:	00005097          	auipc	ra,0x5
    1688:	8ca080e7          	jalr	-1846(ra) # 5f4e <printf>
        exit(1);
    168c:	4505                	li	a0,1
    168e:	00004097          	auipc	ra,0x4
    1692:	538080e7          	jalr	1336(ra) # 5bc6 <exit>
    1696:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    169a:	00005a17          	auipc	s4,0x5
    169e:	b06a0a13          	addi	s4,s4,-1274 # 61a0 <malloc+0x194>
    int n = write(fd, "xxx", 3);
    16a2:	00005a97          	auipc	s5,0x5
    16a6:	38ea8a93          	addi	s5,s5,910 # 6a30 <malloc+0xa24>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16aa:	60100593          	li	a1,1537
    16ae:	8552                	mv	a0,s4
    16b0:	00004097          	auipc	ra,0x4
    16b4:	556080e7          	jalr	1366(ra) # 5c06 <open>
    16b8:	84aa                	mv	s1,a0
    if(fd < 0){
    16ba:	04054763          	bltz	a0,1708 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    16be:	460d                	li	a2,3
    16c0:	85d6                	mv	a1,s5
    16c2:	00004097          	auipc	ra,0x4
    16c6:	524080e7          	jalr	1316(ra) # 5be6 <write>
    if(n != 3){
    16ca:	478d                	li	a5,3
    16cc:	04f51c63          	bne	a0,a5,1724 <truncate3+0x19c>
    close(fd);
    16d0:	8526                	mv	a0,s1
    16d2:	00004097          	auipc	ra,0x4
    16d6:	51c080e7          	jalr	1308(ra) # 5bee <close>
  for(int i = 0; i < 150; i++){
    16da:	39fd                	addiw	s3,s3,-1
    16dc:	fc0997e3          	bnez	s3,16aa <truncate3+0x122>
  wait(&xstatus);
    16e0:	fbc40513          	addi	a0,s0,-68
    16e4:	00004097          	auipc	ra,0x4
    16e8:	4ea080e7          	jalr	1258(ra) # 5bce <wait>
  unlink("truncfile");
    16ec:	00005517          	auipc	a0,0x5
    16f0:	ab450513          	addi	a0,a0,-1356 # 61a0 <malloc+0x194>
    16f4:	00004097          	auipc	ra,0x4
    16f8:	522080e7          	jalr	1314(ra) # 5c16 <unlink>
  exit(xstatus);
    16fc:	fbc42503          	lw	a0,-68(s0)
    1700:	00004097          	auipc	ra,0x4
    1704:	4c6080e7          	jalr	1222(ra) # 5bc6 <exit>
      printf("%s: open failed\n", s);
    1708:	85ca                	mv	a1,s2
    170a:	00005517          	auipc	a0,0x5
    170e:	2de50513          	addi	a0,a0,734 # 69e8 <malloc+0x9dc>
    1712:	00005097          	auipc	ra,0x5
    1716:	83c080e7          	jalr	-1988(ra) # 5f4e <printf>
      exit(1);
    171a:	4505                	li	a0,1
    171c:	00004097          	auipc	ra,0x4
    1720:	4aa080e7          	jalr	1194(ra) # 5bc6 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1724:	862a                	mv	a2,a0
    1726:	85ca                	mv	a1,s2
    1728:	00005517          	auipc	a0,0x5
    172c:	31050513          	addi	a0,a0,784 # 6a38 <malloc+0xa2c>
    1730:	00005097          	auipc	ra,0x5
    1734:	81e080e7          	jalr	-2018(ra) # 5f4e <printf>
      exit(1);
    1738:	4505                	li	a0,1
    173a:	00004097          	auipc	ra,0x4
    173e:	48c080e7          	jalr	1164(ra) # 5bc6 <exit>

0000000000001742 <exectest>:
{
    1742:	715d                	addi	sp,sp,-80
    1744:	e486                	sd	ra,72(sp)
    1746:	e0a2                	sd	s0,64(sp)
    1748:	fc26                	sd	s1,56(sp)
    174a:	f84a                	sd	s2,48(sp)
    174c:	0880                	addi	s0,sp,80
    174e:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1750:	00005797          	auipc	a5,0x5
    1754:	9f878793          	addi	a5,a5,-1544 # 6148 <malloc+0x13c>
    1758:	fcf43023          	sd	a5,-64(s0)
    175c:	00005797          	auipc	a5,0x5
    1760:	2fc78793          	addi	a5,a5,764 # 6a58 <malloc+0xa4c>
    1764:	fcf43423          	sd	a5,-56(s0)
    1768:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    176c:	00005517          	auipc	a0,0x5
    1770:	2f450513          	addi	a0,a0,756 # 6a60 <malloc+0xa54>
    1774:	00004097          	auipc	ra,0x4
    1778:	4a2080e7          	jalr	1186(ra) # 5c16 <unlink>
  pid = fork();
    177c:	00004097          	auipc	ra,0x4
    1780:	442080e7          	jalr	1090(ra) # 5bbe <fork>
  if(pid < 0) {
    1784:	04054663          	bltz	a0,17d0 <exectest+0x8e>
    1788:	84aa                	mv	s1,a0
  if(pid == 0) {
    178a:	e959                	bnez	a0,1820 <exectest+0xde>
    close(1);
    178c:	4505                	li	a0,1
    178e:	00004097          	auipc	ra,0x4
    1792:	460080e7          	jalr	1120(ra) # 5bee <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1796:	20100593          	li	a1,513
    179a:	00005517          	auipc	a0,0x5
    179e:	2c650513          	addi	a0,a0,710 # 6a60 <malloc+0xa54>
    17a2:	00004097          	auipc	ra,0x4
    17a6:	464080e7          	jalr	1124(ra) # 5c06 <open>
    if(fd < 0) {
    17aa:	04054163          	bltz	a0,17ec <exectest+0xaa>
    if(fd != 1) {
    17ae:	4785                	li	a5,1
    17b0:	04f50c63          	beq	a0,a5,1808 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    17b4:	85ca                	mv	a1,s2
    17b6:	00005517          	auipc	a0,0x5
    17ba:	2ca50513          	addi	a0,a0,714 # 6a80 <malloc+0xa74>
    17be:	00004097          	auipc	ra,0x4
    17c2:	790080e7          	jalr	1936(ra) # 5f4e <printf>
      exit(1);
    17c6:	4505                	li	a0,1
    17c8:	00004097          	auipc	ra,0x4
    17cc:	3fe080e7          	jalr	1022(ra) # 5bc6 <exit>
     printf("%s: fork failed\n", s);
    17d0:	85ca                	mv	a1,s2
    17d2:	00005517          	auipc	a0,0x5
    17d6:	1fe50513          	addi	a0,a0,510 # 69d0 <malloc+0x9c4>
    17da:	00004097          	auipc	ra,0x4
    17de:	774080e7          	jalr	1908(ra) # 5f4e <printf>
     exit(1);
    17e2:	4505                	li	a0,1
    17e4:	00004097          	auipc	ra,0x4
    17e8:	3e2080e7          	jalr	994(ra) # 5bc6 <exit>
      printf("%s: create failed\n", s);
    17ec:	85ca                	mv	a1,s2
    17ee:	00005517          	auipc	a0,0x5
    17f2:	27a50513          	addi	a0,a0,634 # 6a68 <malloc+0xa5c>
    17f6:	00004097          	auipc	ra,0x4
    17fa:	758080e7          	jalr	1880(ra) # 5f4e <printf>
      exit(1);
    17fe:	4505                	li	a0,1
    1800:	00004097          	auipc	ra,0x4
    1804:	3c6080e7          	jalr	966(ra) # 5bc6 <exit>
    if(exec("echo", echoargv) < 0){
    1808:	fc040593          	addi	a1,s0,-64
    180c:	00005517          	auipc	a0,0x5
    1810:	93c50513          	addi	a0,a0,-1732 # 6148 <malloc+0x13c>
    1814:	00004097          	auipc	ra,0x4
    1818:	3ea080e7          	jalr	1002(ra) # 5bfe <exec>
    181c:	02054163          	bltz	a0,183e <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1820:	fdc40513          	addi	a0,s0,-36
    1824:	00004097          	auipc	ra,0x4
    1828:	3aa080e7          	jalr	938(ra) # 5bce <wait>
    182c:	02951763          	bne	a0,s1,185a <exectest+0x118>
  if(xstatus != 0)
    1830:	fdc42503          	lw	a0,-36(s0)
    1834:	cd0d                	beqz	a0,186e <exectest+0x12c>
    exit(xstatus);
    1836:	00004097          	auipc	ra,0x4
    183a:	390080e7          	jalr	912(ra) # 5bc6 <exit>
      printf("%s: exec echo failed\n", s);
    183e:	85ca                	mv	a1,s2
    1840:	00005517          	auipc	a0,0x5
    1844:	25050513          	addi	a0,a0,592 # 6a90 <malloc+0xa84>
    1848:	00004097          	auipc	ra,0x4
    184c:	706080e7          	jalr	1798(ra) # 5f4e <printf>
      exit(1);
    1850:	4505                	li	a0,1
    1852:	00004097          	auipc	ra,0x4
    1856:	374080e7          	jalr	884(ra) # 5bc6 <exit>
    printf("%s: wait failed!\n", s);
    185a:	85ca                	mv	a1,s2
    185c:	00005517          	auipc	a0,0x5
    1860:	24c50513          	addi	a0,a0,588 # 6aa8 <malloc+0xa9c>
    1864:	00004097          	auipc	ra,0x4
    1868:	6ea080e7          	jalr	1770(ra) # 5f4e <printf>
    186c:	b7d1                	j	1830 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    186e:	4581                	li	a1,0
    1870:	00005517          	auipc	a0,0x5
    1874:	1f050513          	addi	a0,a0,496 # 6a60 <malloc+0xa54>
    1878:	00004097          	auipc	ra,0x4
    187c:	38e080e7          	jalr	910(ra) # 5c06 <open>
  if(fd < 0) {
    1880:	02054a63          	bltz	a0,18b4 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    1884:	4609                	li	a2,2
    1886:	fb840593          	addi	a1,s0,-72
    188a:	00004097          	auipc	ra,0x4
    188e:	354080e7          	jalr	852(ra) # 5bde <read>
    1892:	4789                	li	a5,2
    1894:	02f50e63          	beq	a0,a5,18d0 <exectest+0x18e>
    printf("%s: read failed\n", s);
    1898:	85ca                	mv	a1,s2
    189a:	00005517          	auipc	a0,0x5
    189e:	c7e50513          	addi	a0,a0,-898 # 6518 <malloc+0x50c>
    18a2:	00004097          	auipc	ra,0x4
    18a6:	6ac080e7          	jalr	1708(ra) # 5f4e <printf>
    exit(1);
    18aa:	4505                	li	a0,1
    18ac:	00004097          	auipc	ra,0x4
    18b0:	31a080e7          	jalr	794(ra) # 5bc6 <exit>
    printf("%s: open failed\n", s);
    18b4:	85ca                	mv	a1,s2
    18b6:	00005517          	auipc	a0,0x5
    18ba:	13250513          	addi	a0,a0,306 # 69e8 <malloc+0x9dc>
    18be:	00004097          	auipc	ra,0x4
    18c2:	690080e7          	jalr	1680(ra) # 5f4e <printf>
    exit(1);
    18c6:	4505                	li	a0,1
    18c8:	00004097          	auipc	ra,0x4
    18cc:	2fe080e7          	jalr	766(ra) # 5bc6 <exit>
  unlink("echo-ok");
    18d0:	00005517          	auipc	a0,0x5
    18d4:	19050513          	addi	a0,a0,400 # 6a60 <malloc+0xa54>
    18d8:	00004097          	auipc	ra,0x4
    18dc:	33e080e7          	jalr	830(ra) # 5c16 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    18e0:	fb844703          	lbu	a4,-72(s0)
    18e4:	04f00793          	li	a5,79
    18e8:	00f71863          	bne	a4,a5,18f8 <exectest+0x1b6>
    18ec:	fb944703          	lbu	a4,-71(s0)
    18f0:	04b00793          	li	a5,75
    18f4:	02f70063          	beq	a4,a5,1914 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    18f8:	85ca                	mv	a1,s2
    18fa:	00005517          	auipc	a0,0x5
    18fe:	1c650513          	addi	a0,a0,454 # 6ac0 <malloc+0xab4>
    1902:	00004097          	auipc	ra,0x4
    1906:	64c080e7          	jalr	1612(ra) # 5f4e <printf>
    exit(1);
    190a:	4505                	li	a0,1
    190c:	00004097          	auipc	ra,0x4
    1910:	2ba080e7          	jalr	698(ra) # 5bc6 <exit>
    exit(0);
    1914:	4501                	li	a0,0
    1916:	00004097          	auipc	ra,0x4
    191a:	2b0080e7          	jalr	688(ra) # 5bc6 <exit>

000000000000191e <pipe1>:
{
    191e:	711d                	addi	sp,sp,-96
    1920:	ec86                	sd	ra,88(sp)
    1922:	e8a2                	sd	s0,80(sp)
    1924:	e4a6                	sd	s1,72(sp)
    1926:	e0ca                	sd	s2,64(sp)
    1928:	fc4e                	sd	s3,56(sp)
    192a:	f852                	sd	s4,48(sp)
    192c:	f456                	sd	s5,40(sp)
    192e:	f05a                	sd	s6,32(sp)
    1930:	ec5e                	sd	s7,24(sp)
    1932:	1080                	addi	s0,sp,96
    1934:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1936:	fa840513          	addi	a0,s0,-88
    193a:	00004097          	auipc	ra,0x4
    193e:	29c080e7          	jalr	668(ra) # 5bd6 <pipe>
    1942:	ed25                	bnez	a0,19ba <pipe1+0x9c>
    1944:	84aa                	mv	s1,a0
  pid = fork();
    1946:	00004097          	auipc	ra,0x4
    194a:	278080e7          	jalr	632(ra) # 5bbe <fork>
    194e:	8a2a                	mv	s4,a0
  if(pid == 0){
    1950:	c159                	beqz	a0,19d6 <pipe1+0xb8>
  } else if(pid > 0){
    1952:	16a05e63          	blez	a0,1ace <pipe1+0x1b0>
    close(fds[1]);
    1956:	fac42503          	lw	a0,-84(s0)
    195a:	00004097          	auipc	ra,0x4
    195e:	294080e7          	jalr	660(ra) # 5bee <close>
    total = 0;
    1962:	8a26                	mv	s4,s1
    cc = 1;
    1964:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1966:	0000ba97          	auipc	s5,0xb
    196a:	2f2a8a93          	addi	s5,s5,754 # cc58 <buf>
      if(cc > sizeof(buf))
    196e:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1970:	864e                	mv	a2,s3
    1972:	85d6                	mv	a1,s5
    1974:	fa842503          	lw	a0,-88(s0)
    1978:	00004097          	auipc	ra,0x4
    197c:	266080e7          	jalr	614(ra) # 5bde <read>
    1980:	10a05263          	blez	a0,1a84 <pipe1+0x166>
      for(i = 0; i < n; i++){
    1984:	0000b717          	auipc	a4,0xb
    1988:	2d470713          	addi	a4,a4,724 # cc58 <buf>
    198c:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1990:	00074683          	lbu	a3,0(a4)
    1994:	0ff4f793          	andi	a5,s1,255
    1998:	2485                	addiw	s1,s1,1
    199a:	0cf69163          	bne	a3,a5,1a5c <pipe1+0x13e>
      for(i = 0; i < n; i++){
    199e:	0705                	addi	a4,a4,1
    19a0:	fec498e3          	bne	s1,a2,1990 <pipe1+0x72>
      total += n;
    19a4:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19a8:	0019979b          	slliw	a5,s3,0x1
    19ac:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    19b0:	013b7363          	bgeu	s6,s3,19b6 <pipe1+0x98>
        cc = sizeof(buf);
    19b4:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    19b6:	84b2                	mv	s1,a2
    19b8:	bf65                	j	1970 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    19ba:	85ca                	mv	a1,s2
    19bc:	00005517          	auipc	a0,0x5
    19c0:	11c50513          	addi	a0,a0,284 # 6ad8 <malloc+0xacc>
    19c4:	00004097          	auipc	ra,0x4
    19c8:	58a080e7          	jalr	1418(ra) # 5f4e <printf>
    exit(1);
    19cc:	4505                	li	a0,1
    19ce:	00004097          	auipc	ra,0x4
    19d2:	1f8080e7          	jalr	504(ra) # 5bc6 <exit>
    close(fds[0]);
    19d6:	fa842503          	lw	a0,-88(s0)
    19da:	00004097          	auipc	ra,0x4
    19de:	214080e7          	jalr	532(ra) # 5bee <close>
    for(n = 0; n < N; n++){
    19e2:	0000bb17          	auipc	s6,0xb
    19e6:	276b0b13          	addi	s6,s6,630 # cc58 <buf>
    19ea:	416004bb          	negw	s1,s6
    19ee:	0ff4f493          	andi	s1,s1,255
    19f2:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    19f6:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    19f8:	6a85                	lui	s5,0x1
    19fa:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x9b>
{
    19fe:	87da                	mv	a5,s6
        buf[i] = seq++;
    1a00:	0097873b          	addw	a4,a5,s1
    1a04:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1a08:	0785                	addi	a5,a5,1
    1a0a:	fef99be3          	bne	s3,a5,1a00 <pipe1+0xe2>
        buf[i] = seq++;
    1a0e:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a12:	40900613          	li	a2,1033
    1a16:	85de                	mv	a1,s7
    1a18:	fac42503          	lw	a0,-84(s0)
    1a1c:	00004097          	auipc	ra,0x4
    1a20:	1ca080e7          	jalr	458(ra) # 5be6 <write>
    1a24:	40900793          	li	a5,1033
    1a28:	00f51c63          	bne	a0,a5,1a40 <pipe1+0x122>
    for(n = 0; n < N; n++){
    1a2c:	24a5                	addiw	s1,s1,9
    1a2e:	0ff4f493          	andi	s1,s1,255
    1a32:	fd5a16e3          	bne	s4,s5,19fe <pipe1+0xe0>
    exit(0);
    1a36:	4501                	li	a0,0
    1a38:	00004097          	auipc	ra,0x4
    1a3c:	18e080e7          	jalr	398(ra) # 5bc6 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a40:	85ca                	mv	a1,s2
    1a42:	00005517          	auipc	a0,0x5
    1a46:	0ae50513          	addi	a0,a0,174 # 6af0 <malloc+0xae4>
    1a4a:	00004097          	auipc	ra,0x4
    1a4e:	504080e7          	jalr	1284(ra) # 5f4e <printf>
        exit(1);
    1a52:	4505                	li	a0,1
    1a54:	00004097          	auipc	ra,0x4
    1a58:	172080e7          	jalr	370(ra) # 5bc6 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a5c:	85ca                	mv	a1,s2
    1a5e:	00005517          	auipc	a0,0x5
    1a62:	0aa50513          	addi	a0,a0,170 # 6b08 <malloc+0xafc>
    1a66:	00004097          	auipc	ra,0x4
    1a6a:	4e8080e7          	jalr	1256(ra) # 5f4e <printf>
}
    1a6e:	60e6                	ld	ra,88(sp)
    1a70:	6446                	ld	s0,80(sp)
    1a72:	64a6                	ld	s1,72(sp)
    1a74:	6906                	ld	s2,64(sp)
    1a76:	79e2                	ld	s3,56(sp)
    1a78:	7a42                	ld	s4,48(sp)
    1a7a:	7aa2                	ld	s5,40(sp)
    1a7c:	7b02                	ld	s6,32(sp)
    1a7e:	6be2                	ld	s7,24(sp)
    1a80:	6125                	addi	sp,sp,96
    1a82:	8082                	ret
    if(total != N * SZ){
    1a84:	6785                	lui	a5,0x1
    1a86:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x9b>
    1a8a:	02fa0063          	beq	s4,a5,1aaa <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1a8e:	85d2                	mv	a1,s4
    1a90:	00005517          	auipc	a0,0x5
    1a94:	09050513          	addi	a0,a0,144 # 6b20 <malloc+0xb14>
    1a98:	00004097          	auipc	ra,0x4
    1a9c:	4b6080e7          	jalr	1206(ra) # 5f4e <printf>
      exit(1);
    1aa0:	4505                	li	a0,1
    1aa2:	00004097          	auipc	ra,0x4
    1aa6:	124080e7          	jalr	292(ra) # 5bc6 <exit>
    close(fds[0]);
    1aaa:	fa842503          	lw	a0,-88(s0)
    1aae:	00004097          	auipc	ra,0x4
    1ab2:	140080e7          	jalr	320(ra) # 5bee <close>
    wait(&xstatus);
    1ab6:	fa440513          	addi	a0,s0,-92
    1aba:	00004097          	auipc	ra,0x4
    1abe:	114080e7          	jalr	276(ra) # 5bce <wait>
    exit(xstatus);
    1ac2:	fa442503          	lw	a0,-92(s0)
    1ac6:	00004097          	auipc	ra,0x4
    1aca:	100080e7          	jalr	256(ra) # 5bc6 <exit>
    printf("%s: fork() failed\n", s);
    1ace:	85ca                	mv	a1,s2
    1ad0:	00005517          	auipc	a0,0x5
    1ad4:	07050513          	addi	a0,a0,112 # 6b40 <malloc+0xb34>
    1ad8:	00004097          	auipc	ra,0x4
    1adc:	476080e7          	jalr	1142(ra) # 5f4e <printf>
    exit(1);
    1ae0:	4505                	li	a0,1
    1ae2:	00004097          	auipc	ra,0x4
    1ae6:	0e4080e7          	jalr	228(ra) # 5bc6 <exit>

0000000000001aea <exitwait>:
{
    1aea:	7139                	addi	sp,sp,-64
    1aec:	fc06                	sd	ra,56(sp)
    1aee:	f822                	sd	s0,48(sp)
    1af0:	f426                	sd	s1,40(sp)
    1af2:	f04a                	sd	s2,32(sp)
    1af4:	ec4e                	sd	s3,24(sp)
    1af6:	e852                	sd	s4,16(sp)
    1af8:	0080                	addi	s0,sp,64
    1afa:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1afc:	4901                	li	s2,0
    1afe:	06400993          	li	s3,100
    pid = fork();
    1b02:	00004097          	auipc	ra,0x4
    1b06:	0bc080e7          	jalr	188(ra) # 5bbe <fork>
    1b0a:	84aa                	mv	s1,a0
    if(pid < 0){
    1b0c:	02054a63          	bltz	a0,1b40 <exitwait+0x56>
    if(pid){
    1b10:	c151                	beqz	a0,1b94 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1b12:	fcc40513          	addi	a0,s0,-52
    1b16:	00004097          	auipc	ra,0x4
    1b1a:	0b8080e7          	jalr	184(ra) # 5bce <wait>
    1b1e:	02951f63          	bne	a0,s1,1b5c <exitwait+0x72>
      if(i != xstate) {
    1b22:	fcc42783          	lw	a5,-52(s0)
    1b26:	05279963          	bne	a5,s2,1b78 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1b2a:	2905                	addiw	s2,s2,1
    1b2c:	fd391be3          	bne	s2,s3,1b02 <exitwait+0x18>
}
    1b30:	70e2                	ld	ra,56(sp)
    1b32:	7442                	ld	s0,48(sp)
    1b34:	74a2                	ld	s1,40(sp)
    1b36:	7902                	ld	s2,32(sp)
    1b38:	69e2                	ld	s3,24(sp)
    1b3a:	6a42                	ld	s4,16(sp)
    1b3c:	6121                	addi	sp,sp,64
    1b3e:	8082                	ret
      printf("%s: fork failed\n", s);
    1b40:	85d2                	mv	a1,s4
    1b42:	00005517          	auipc	a0,0x5
    1b46:	e8e50513          	addi	a0,a0,-370 # 69d0 <malloc+0x9c4>
    1b4a:	00004097          	auipc	ra,0x4
    1b4e:	404080e7          	jalr	1028(ra) # 5f4e <printf>
      exit(1);
    1b52:	4505                	li	a0,1
    1b54:	00004097          	auipc	ra,0x4
    1b58:	072080e7          	jalr	114(ra) # 5bc6 <exit>
        printf("%s: wait wrong pid\n", s);
    1b5c:	85d2                	mv	a1,s4
    1b5e:	00005517          	auipc	a0,0x5
    1b62:	ffa50513          	addi	a0,a0,-6 # 6b58 <malloc+0xb4c>
    1b66:	00004097          	auipc	ra,0x4
    1b6a:	3e8080e7          	jalr	1000(ra) # 5f4e <printf>
        exit(1);
    1b6e:	4505                	li	a0,1
    1b70:	00004097          	auipc	ra,0x4
    1b74:	056080e7          	jalr	86(ra) # 5bc6 <exit>
        printf("%s: wait wrong exit status\n", s);
    1b78:	85d2                	mv	a1,s4
    1b7a:	00005517          	auipc	a0,0x5
    1b7e:	ff650513          	addi	a0,a0,-10 # 6b70 <malloc+0xb64>
    1b82:	00004097          	auipc	ra,0x4
    1b86:	3cc080e7          	jalr	972(ra) # 5f4e <printf>
        exit(1);
    1b8a:	4505                	li	a0,1
    1b8c:	00004097          	auipc	ra,0x4
    1b90:	03a080e7          	jalr	58(ra) # 5bc6 <exit>
      exit(i);
    1b94:	854a                	mv	a0,s2
    1b96:	00004097          	auipc	ra,0x4
    1b9a:	030080e7          	jalr	48(ra) # 5bc6 <exit>

0000000000001b9e <twochildren>:
{
    1b9e:	1101                	addi	sp,sp,-32
    1ba0:	ec06                	sd	ra,24(sp)
    1ba2:	e822                	sd	s0,16(sp)
    1ba4:	e426                	sd	s1,8(sp)
    1ba6:	e04a                	sd	s2,0(sp)
    1ba8:	1000                	addi	s0,sp,32
    1baa:	892a                	mv	s2,a0
    1bac:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bb0:	00004097          	auipc	ra,0x4
    1bb4:	00e080e7          	jalr	14(ra) # 5bbe <fork>
    if(pid1 < 0){
    1bb8:	02054c63          	bltz	a0,1bf0 <twochildren+0x52>
    if(pid1 == 0){
    1bbc:	c921                	beqz	a0,1c0c <twochildren+0x6e>
      int pid2 = fork();
    1bbe:	00004097          	auipc	ra,0x4
    1bc2:	000080e7          	jalr	ra # 5bbe <fork>
      if(pid2 < 0){
    1bc6:	04054763          	bltz	a0,1c14 <twochildren+0x76>
      if(pid2 == 0){
    1bca:	c13d                	beqz	a0,1c30 <twochildren+0x92>
        wait(0);
    1bcc:	4501                	li	a0,0
    1bce:	00004097          	auipc	ra,0x4
    1bd2:	000080e7          	jalr	ra # 5bce <wait>
        wait(0);
    1bd6:	4501                	li	a0,0
    1bd8:	00004097          	auipc	ra,0x4
    1bdc:	ff6080e7          	jalr	-10(ra) # 5bce <wait>
  for(int i = 0; i < 1000; i++){
    1be0:	34fd                	addiw	s1,s1,-1
    1be2:	f4f9                	bnez	s1,1bb0 <twochildren+0x12>
}
    1be4:	60e2                	ld	ra,24(sp)
    1be6:	6442                	ld	s0,16(sp)
    1be8:	64a2                	ld	s1,8(sp)
    1bea:	6902                	ld	s2,0(sp)
    1bec:	6105                	addi	sp,sp,32
    1bee:	8082                	ret
      printf("%s: fork failed\n", s);
    1bf0:	85ca                	mv	a1,s2
    1bf2:	00005517          	auipc	a0,0x5
    1bf6:	dde50513          	addi	a0,a0,-546 # 69d0 <malloc+0x9c4>
    1bfa:	00004097          	auipc	ra,0x4
    1bfe:	354080e7          	jalr	852(ra) # 5f4e <printf>
      exit(1);
    1c02:	4505                	li	a0,1
    1c04:	00004097          	auipc	ra,0x4
    1c08:	fc2080e7          	jalr	-62(ra) # 5bc6 <exit>
      exit(0);
    1c0c:	00004097          	auipc	ra,0x4
    1c10:	fba080e7          	jalr	-70(ra) # 5bc6 <exit>
        printf("%s: fork failed\n", s);
    1c14:	85ca                	mv	a1,s2
    1c16:	00005517          	auipc	a0,0x5
    1c1a:	dba50513          	addi	a0,a0,-582 # 69d0 <malloc+0x9c4>
    1c1e:	00004097          	auipc	ra,0x4
    1c22:	330080e7          	jalr	816(ra) # 5f4e <printf>
        exit(1);
    1c26:	4505                	li	a0,1
    1c28:	00004097          	auipc	ra,0x4
    1c2c:	f9e080e7          	jalr	-98(ra) # 5bc6 <exit>
        exit(0);
    1c30:	00004097          	auipc	ra,0x4
    1c34:	f96080e7          	jalr	-106(ra) # 5bc6 <exit>

0000000000001c38 <forkfork>:
{
    1c38:	7179                	addi	sp,sp,-48
    1c3a:	f406                	sd	ra,40(sp)
    1c3c:	f022                	sd	s0,32(sp)
    1c3e:	ec26                	sd	s1,24(sp)
    1c40:	1800                	addi	s0,sp,48
    1c42:	84aa                	mv	s1,a0
    int pid = fork();
    1c44:	00004097          	auipc	ra,0x4
    1c48:	f7a080e7          	jalr	-134(ra) # 5bbe <fork>
    if(pid < 0){
    1c4c:	04054163          	bltz	a0,1c8e <forkfork+0x56>
    if(pid == 0){
    1c50:	cd29                	beqz	a0,1caa <forkfork+0x72>
    int pid = fork();
    1c52:	00004097          	auipc	ra,0x4
    1c56:	f6c080e7          	jalr	-148(ra) # 5bbe <fork>
    if(pid < 0){
    1c5a:	02054a63          	bltz	a0,1c8e <forkfork+0x56>
    if(pid == 0){
    1c5e:	c531                	beqz	a0,1caa <forkfork+0x72>
    wait(&xstatus);
    1c60:	fdc40513          	addi	a0,s0,-36
    1c64:	00004097          	auipc	ra,0x4
    1c68:	f6a080e7          	jalr	-150(ra) # 5bce <wait>
    if(xstatus != 0) {
    1c6c:	fdc42783          	lw	a5,-36(s0)
    1c70:	ebbd                	bnez	a5,1ce6 <forkfork+0xae>
    wait(&xstatus);
    1c72:	fdc40513          	addi	a0,s0,-36
    1c76:	00004097          	auipc	ra,0x4
    1c7a:	f58080e7          	jalr	-168(ra) # 5bce <wait>
    if(xstatus != 0) {
    1c7e:	fdc42783          	lw	a5,-36(s0)
    1c82:	e3b5                	bnez	a5,1ce6 <forkfork+0xae>
}
    1c84:	70a2                	ld	ra,40(sp)
    1c86:	7402                	ld	s0,32(sp)
    1c88:	64e2                	ld	s1,24(sp)
    1c8a:	6145                	addi	sp,sp,48
    1c8c:	8082                	ret
      printf("%s: fork failed", s);
    1c8e:	85a6                	mv	a1,s1
    1c90:	00005517          	auipc	a0,0x5
    1c94:	f0050513          	addi	a0,a0,-256 # 6b90 <malloc+0xb84>
    1c98:	00004097          	auipc	ra,0x4
    1c9c:	2b6080e7          	jalr	694(ra) # 5f4e <printf>
      exit(1);
    1ca0:	4505                	li	a0,1
    1ca2:	00004097          	auipc	ra,0x4
    1ca6:	f24080e7          	jalr	-220(ra) # 5bc6 <exit>
{
    1caa:	0c800493          	li	s1,200
        int pid1 = fork();
    1cae:	00004097          	auipc	ra,0x4
    1cb2:	f10080e7          	jalr	-240(ra) # 5bbe <fork>
        if(pid1 < 0){
    1cb6:	00054f63          	bltz	a0,1cd4 <forkfork+0x9c>
        if(pid1 == 0){
    1cba:	c115                	beqz	a0,1cde <forkfork+0xa6>
        wait(0);
    1cbc:	4501                	li	a0,0
    1cbe:	00004097          	auipc	ra,0x4
    1cc2:	f10080e7          	jalr	-240(ra) # 5bce <wait>
      for(int j = 0; j < 200; j++){
    1cc6:	34fd                	addiw	s1,s1,-1
    1cc8:	f0fd                	bnez	s1,1cae <forkfork+0x76>
      exit(0);
    1cca:	4501                	li	a0,0
    1ccc:	00004097          	auipc	ra,0x4
    1cd0:	efa080e7          	jalr	-262(ra) # 5bc6 <exit>
          exit(1);
    1cd4:	4505                	li	a0,1
    1cd6:	00004097          	auipc	ra,0x4
    1cda:	ef0080e7          	jalr	-272(ra) # 5bc6 <exit>
          exit(0);
    1cde:	00004097          	auipc	ra,0x4
    1ce2:	ee8080e7          	jalr	-280(ra) # 5bc6 <exit>
      printf("%s: fork in child failed", s);
    1ce6:	85a6                	mv	a1,s1
    1ce8:	00005517          	auipc	a0,0x5
    1cec:	eb850513          	addi	a0,a0,-328 # 6ba0 <malloc+0xb94>
    1cf0:	00004097          	auipc	ra,0x4
    1cf4:	25e080e7          	jalr	606(ra) # 5f4e <printf>
      exit(1);
    1cf8:	4505                	li	a0,1
    1cfa:	00004097          	auipc	ra,0x4
    1cfe:	ecc080e7          	jalr	-308(ra) # 5bc6 <exit>

0000000000001d02 <reparent2>:
{
    1d02:	1101                	addi	sp,sp,-32
    1d04:	ec06                	sd	ra,24(sp)
    1d06:	e822                	sd	s0,16(sp)
    1d08:	e426                	sd	s1,8(sp)
    1d0a:	1000                	addi	s0,sp,32
    1d0c:	32000493          	li	s1,800
    int pid1 = fork();
    1d10:	00004097          	auipc	ra,0x4
    1d14:	eae080e7          	jalr	-338(ra) # 5bbe <fork>
    if(pid1 < 0){
    1d18:	00054f63          	bltz	a0,1d36 <reparent2+0x34>
    if(pid1 == 0){
    1d1c:	c915                	beqz	a0,1d50 <reparent2+0x4e>
    wait(0);
    1d1e:	4501                	li	a0,0
    1d20:	00004097          	auipc	ra,0x4
    1d24:	eae080e7          	jalr	-338(ra) # 5bce <wait>
  for(int i = 0; i < 800; i++){
    1d28:	34fd                	addiw	s1,s1,-1
    1d2a:	f0fd                	bnez	s1,1d10 <reparent2+0xe>
  exit(0);
    1d2c:	4501                	li	a0,0
    1d2e:	00004097          	auipc	ra,0x4
    1d32:	e98080e7          	jalr	-360(ra) # 5bc6 <exit>
      printf("fork failed\n");
    1d36:	00005517          	auipc	a0,0x5
    1d3a:	08a50513          	addi	a0,a0,138 # 6dc0 <malloc+0xdb4>
    1d3e:	00004097          	auipc	ra,0x4
    1d42:	210080e7          	jalr	528(ra) # 5f4e <printf>
      exit(1);
    1d46:	4505                	li	a0,1
    1d48:	00004097          	auipc	ra,0x4
    1d4c:	e7e080e7          	jalr	-386(ra) # 5bc6 <exit>
      fork();
    1d50:	00004097          	auipc	ra,0x4
    1d54:	e6e080e7          	jalr	-402(ra) # 5bbe <fork>
      fork();
    1d58:	00004097          	auipc	ra,0x4
    1d5c:	e66080e7          	jalr	-410(ra) # 5bbe <fork>
      exit(0);
    1d60:	4501                	li	a0,0
    1d62:	00004097          	auipc	ra,0x4
    1d66:	e64080e7          	jalr	-412(ra) # 5bc6 <exit>

0000000000001d6a <createdelete>:
{
    1d6a:	7175                	addi	sp,sp,-144
    1d6c:	e506                	sd	ra,136(sp)
    1d6e:	e122                	sd	s0,128(sp)
    1d70:	fca6                	sd	s1,120(sp)
    1d72:	f8ca                	sd	s2,112(sp)
    1d74:	f4ce                	sd	s3,104(sp)
    1d76:	f0d2                	sd	s4,96(sp)
    1d78:	ecd6                	sd	s5,88(sp)
    1d7a:	e8da                	sd	s6,80(sp)
    1d7c:	e4de                	sd	s7,72(sp)
    1d7e:	e0e2                	sd	s8,64(sp)
    1d80:	fc66                	sd	s9,56(sp)
    1d82:	0900                	addi	s0,sp,144
    1d84:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1d86:	4901                	li	s2,0
    1d88:	4991                	li	s3,4
    pid = fork();
    1d8a:	00004097          	auipc	ra,0x4
    1d8e:	e34080e7          	jalr	-460(ra) # 5bbe <fork>
    1d92:	84aa                	mv	s1,a0
    if(pid < 0){
    1d94:	02054f63          	bltz	a0,1dd2 <createdelete+0x68>
    if(pid == 0){
    1d98:	c939                	beqz	a0,1dee <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1d9a:	2905                	addiw	s2,s2,1
    1d9c:	ff3917e3          	bne	s2,s3,1d8a <createdelete+0x20>
    1da0:	4491                	li	s1,4
    wait(&xstatus);
    1da2:	f7c40513          	addi	a0,s0,-132
    1da6:	00004097          	auipc	ra,0x4
    1daa:	e28080e7          	jalr	-472(ra) # 5bce <wait>
    if(xstatus != 0)
    1dae:	f7c42903          	lw	s2,-132(s0)
    1db2:	0e091263          	bnez	s2,1e96 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1db6:	34fd                	addiw	s1,s1,-1
    1db8:	f4ed                	bnez	s1,1da2 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1dba:	f8040123          	sb	zero,-126(s0)
    1dbe:	03000993          	li	s3,48
    1dc2:	5a7d                	li	s4,-1
    1dc4:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1dc8:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1dca:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1dcc:	07400a93          	li	s5,116
    1dd0:	a29d                	j	1f36 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1dd2:	85e6                	mv	a1,s9
    1dd4:	00005517          	auipc	a0,0x5
    1dd8:	fec50513          	addi	a0,a0,-20 # 6dc0 <malloc+0xdb4>
    1ddc:	00004097          	auipc	ra,0x4
    1de0:	172080e7          	jalr	370(ra) # 5f4e <printf>
      exit(1);
    1de4:	4505                	li	a0,1
    1de6:	00004097          	auipc	ra,0x4
    1dea:	de0080e7          	jalr	-544(ra) # 5bc6 <exit>
      name[0] = 'p' + pi;
    1dee:	0709091b          	addiw	s2,s2,112
    1df2:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1df6:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1dfa:	4951                	li	s2,20
    1dfc:	a015                	j	1e20 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1dfe:	85e6                	mv	a1,s9
    1e00:	00005517          	auipc	a0,0x5
    1e04:	c6850513          	addi	a0,a0,-920 # 6a68 <malloc+0xa5c>
    1e08:	00004097          	auipc	ra,0x4
    1e0c:	146080e7          	jalr	326(ra) # 5f4e <printf>
          exit(1);
    1e10:	4505                	li	a0,1
    1e12:	00004097          	auipc	ra,0x4
    1e16:	db4080e7          	jalr	-588(ra) # 5bc6 <exit>
      for(i = 0; i < N; i++){
    1e1a:	2485                	addiw	s1,s1,1
    1e1c:	07248863          	beq	s1,s2,1e8c <createdelete+0x122>
        name[1] = '0' + i;
    1e20:	0304879b          	addiw	a5,s1,48
    1e24:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e28:	20200593          	li	a1,514
    1e2c:	f8040513          	addi	a0,s0,-128
    1e30:	00004097          	auipc	ra,0x4
    1e34:	dd6080e7          	jalr	-554(ra) # 5c06 <open>
        if(fd < 0){
    1e38:	fc0543e3          	bltz	a0,1dfe <createdelete+0x94>
        close(fd);
    1e3c:	00004097          	auipc	ra,0x4
    1e40:	db2080e7          	jalr	-590(ra) # 5bee <close>
        if(i > 0 && (i % 2 ) == 0){
    1e44:	fc905be3          	blez	s1,1e1a <createdelete+0xb0>
    1e48:	0014f793          	andi	a5,s1,1
    1e4c:	f7f9                	bnez	a5,1e1a <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e4e:	01f4d79b          	srliw	a5,s1,0x1f
    1e52:	9fa5                	addw	a5,a5,s1
    1e54:	4017d79b          	sraiw	a5,a5,0x1
    1e58:	0307879b          	addiw	a5,a5,48
    1e5c:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1e60:	f8040513          	addi	a0,s0,-128
    1e64:	00004097          	auipc	ra,0x4
    1e68:	db2080e7          	jalr	-590(ra) # 5c16 <unlink>
    1e6c:	fa0557e3          	bgez	a0,1e1a <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e70:	85e6                	mv	a1,s9
    1e72:	00005517          	auipc	a0,0x5
    1e76:	d4e50513          	addi	a0,a0,-690 # 6bc0 <malloc+0xbb4>
    1e7a:	00004097          	auipc	ra,0x4
    1e7e:	0d4080e7          	jalr	212(ra) # 5f4e <printf>
            exit(1);
    1e82:	4505                	li	a0,1
    1e84:	00004097          	auipc	ra,0x4
    1e88:	d42080e7          	jalr	-702(ra) # 5bc6 <exit>
      exit(0);
    1e8c:	4501                	li	a0,0
    1e8e:	00004097          	auipc	ra,0x4
    1e92:	d38080e7          	jalr	-712(ra) # 5bc6 <exit>
      exit(1);
    1e96:	4505                	li	a0,1
    1e98:	00004097          	auipc	ra,0x4
    1e9c:	d2e080e7          	jalr	-722(ra) # 5bc6 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1ea0:	f8040613          	addi	a2,s0,-128
    1ea4:	85e6                	mv	a1,s9
    1ea6:	00005517          	auipc	a0,0x5
    1eaa:	d3250513          	addi	a0,a0,-718 # 6bd8 <malloc+0xbcc>
    1eae:	00004097          	auipc	ra,0x4
    1eb2:	0a0080e7          	jalr	160(ra) # 5f4e <printf>
        exit(1);
    1eb6:	4505                	li	a0,1
    1eb8:	00004097          	auipc	ra,0x4
    1ebc:	d0e080e7          	jalr	-754(ra) # 5bc6 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ec0:	054b7163          	bgeu	s6,s4,1f02 <createdelete+0x198>
      if(fd >= 0)
    1ec4:	02055a63          	bgez	a0,1ef8 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1ec8:	2485                	addiw	s1,s1,1
    1eca:	0ff4f493          	andi	s1,s1,255
    1ece:	05548c63          	beq	s1,s5,1f26 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1ed2:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1ed6:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1eda:	4581                	li	a1,0
    1edc:	f8040513          	addi	a0,s0,-128
    1ee0:	00004097          	auipc	ra,0x4
    1ee4:	d26080e7          	jalr	-730(ra) # 5c06 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1ee8:	00090463          	beqz	s2,1ef0 <createdelete+0x186>
    1eec:	fd2bdae3          	bge	s7,s2,1ec0 <createdelete+0x156>
    1ef0:	fa0548e3          	bltz	a0,1ea0 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ef4:	014b7963          	bgeu	s6,s4,1f06 <createdelete+0x19c>
        close(fd);
    1ef8:	00004097          	auipc	ra,0x4
    1efc:	cf6080e7          	jalr	-778(ra) # 5bee <close>
    1f00:	b7e1                	j	1ec8 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f02:	fc0543e3          	bltz	a0,1ec8 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f06:	f8040613          	addi	a2,s0,-128
    1f0a:	85e6                	mv	a1,s9
    1f0c:	00005517          	auipc	a0,0x5
    1f10:	cf450513          	addi	a0,a0,-780 # 6c00 <malloc+0xbf4>
    1f14:	00004097          	auipc	ra,0x4
    1f18:	03a080e7          	jalr	58(ra) # 5f4e <printf>
        exit(1);
    1f1c:	4505                	li	a0,1
    1f1e:	00004097          	auipc	ra,0x4
    1f22:	ca8080e7          	jalr	-856(ra) # 5bc6 <exit>
  for(i = 0; i < N; i++){
    1f26:	2905                	addiw	s2,s2,1
    1f28:	2a05                	addiw	s4,s4,1
    1f2a:	2985                	addiw	s3,s3,1
    1f2c:	0ff9f993          	andi	s3,s3,255
    1f30:	47d1                	li	a5,20
    1f32:	02f90a63          	beq	s2,a5,1f66 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1f36:	84e2                	mv	s1,s8
    1f38:	bf69                	j	1ed2 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1f3a:	2905                	addiw	s2,s2,1
    1f3c:	0ff97913          	andi	s2,s2,255
    1f40:	2985                	addiw	s3,s3,1
    1f42:	0ff9f993          	andi	s3,s3,255
    1f46:	03490863          	beq	s2,s4,1f76 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f4a:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f4c:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f50:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f54:	f8040513          	addi	a0,s0,-128
    1f58:	00004097          	auipc	ra,0x4
    1f5c:	cbe080e7          	jalr	-834(ra) # 5c16 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1f60:	34fd                	addiw	s1,s1,-1
    1f62:	f4ed                	bnez	s1,1f4c <createdelete+0x1e2>
    1f64:	bfd9                	j	1f3a <createdelete+0x1d0>
    1f66:	03000993          	li	s3,48
    1f6a:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f6e:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1f70:	08400a13          	li	s4,132
    1f74:	bfd9                	j	1f4a <createdelete+0x1e0>
}
    1f76:	60aa                	ld	ra,136(sp)
    1f78:	640a                	ld	s0,128(sp)
    1f7a:	74e6                	ld	s1,120(sp)
    1f7c:	7946                	ld	s2,112(sp)
    1f7e:	79a6                	ld	s3,104(sp)
    1f80:	7a06                	ld	s4,96(sp)
    1f82:	6ae6                	ld	s5,88(sp)
    1f84:	6b46                	ld	s6,80(sp)
    1f86:	6ba6                	ld	s7,72(sp)
    1f88:	6c06                	ld	s8,64(sp)
    1f8a:	7ce2                	ld	s9,56(sp)
    1f8c:	6149                	addi	sp,sp,144
    1f8e:	8082                	ret

0000000000001f90 <linkunlink>:
{
    1f90:	711d                	addi	sp,sp,-96
    1f92:	ec86                	sd	ra,88(sp)
    1f94:	e8a2                	sd	s0,80(sp)
    1f96:	e4a6                	sd	s1,72(sp)
    1f98:	e0ca                	sd	s2,64(sp)
    1f9a:	fc4e                	sd	s3,56(sp)
    1f9c:	f852                	sd	s4,48(sp)
    1f9e:	f456                	sd	s5,40(sp)
    1fa0:	f05a                	sd	s6,32(sp)
    1fa2:	ec5e                	sd	s7,24(sp)
    1fa4:	e862                	sd	s8,16(sp)
    1fa6:	e466                	sd	s9,8(sp)
    1fa8:	1080                	addi	s0,sp,96
    1faa:	84aa                	mv	s1,a0
  unlink("x");
    1fac:	00004517          	auipc	a0,0x4
    1fb0:	20c50513          	addi	a0,a0,524 # 61b8 <malloc+0x1ac>
    1fb4:	00004097          	auipc	ra,0x4
    1fb8:	c62080e7          	jalr	-926(ra) # 5c16 <unlink>
  pid = fork();
    1fbc:	00004097          	auipc	ra,0x4
    1fc0:	c02080e7          	jalr	-1022(ra) # 5bbe <fork>
  if(pid < 0){
    1fc4:	02054b63          	bltz	a0,1ffa <linkunlink+0x6a>
    1fc8:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1fca:	4c85                	li	s9,1
    1fcc:	e119                	bnez	a0,1fd2 <linkunlink+0x42>
    1fce:	06100c93          	li	s9,97
    1fd2:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1fd6:	41c659b7          	lui	s3,0x41c65
    1fda:	e6d9899b          	addiw	s3,s3,-403
    1fde:	690d                	lui	s2,0x3
    1fe0:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1fe4:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1fe6:	4b05                	li	s6,1
      unlink("x");
    1fe8:	00004a97          	auipc	s5,0x4
    1fec:	1d0a8a93          	addi	s5,s5,464 # 61b8 <malloc+0x1ac>
      link("cat", "x");
    1ff0:	00005b97          	auipc	s7,0x5
    1ff4:	c38b8b93          	addi	s7,s7,-968 # 6c28 <malloc+0xc1c>
    1ff8:	a825                	j	2030 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1ffa:	85a6                	mv	a1,s1
    1ffc:	00005517          	auipc	a0,0x5
    2000:	9d450513          	addi	a0,a0,-1580 # 69d0 <malloc+0x9c4>
    2004:	00004097          	auipc	ra,0x4
    2008:	f4a080e7          	jalr	-182(ra) # 5f4e <printf>
    exit(1);
    200c:	4505                	li	a0,1
    200e:	00004097          	auipc	ra,0x4
    2012:	bb8080e7          	jalr	-1096(ra) # 5bc6 <exit>
      close(open("x", O_RDWR | O_CREATE));
    2016:	20200593          	li	a1,514
    201a:	8556                	mv	a0,s5
    201c:	00004097          	auipc	ra,0x4
    2020:	bea080e7          	jalr	-1046(ra) # 5c06 <open>
    2024:	00004097          	auipc	ra,0x4
    2028:	bca080e7          	jalr	-1078(ra) # 5bee <close>
  for(i = 0; i < 100; i++){
    202c:	34fd                	addiw	s1,s1,-1
    202e:	c88d                	beqz	s1,2060 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    2030:	033c87bb          	mulw	a5,s9,s3
    2034:	012787bb          	addw	a5,a5,s2
    2038:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    203c:	0347f7bb          	remuw	a5,a5,s4
    2040:	dbf9                	beqz	a5,2016 <linkunlink+0x86>
    } else if((x % 3) == 1){
    2042:	01678863          	beq	a5,s6,2052 <linkunlink+0xc2>
      unlink("x");
    2046:	8556                	mv	a0,s5
    2048:	00004097          	auipc	ra,0x4
    204c:	bce080e7          	jalr	-1074(ra) # 5c16 <unlink>
    2050:	bff1                	j	202c <linkunlink+0x9c>
      link("cat", "x");
    2052:	85d6                	mv	a1,s5
    2054:	855e                	mv	a0,s7
    2056:	00004097          	auipc	ra,0x4
    205a:	bd0080e7          	jalr	-1072(ra) # 5c26 <link>
    205e:	b7f9                	j	202c <linkunlink+0x9c>
  if(pid)
    2060:	020c0463          	beqz	s8,2088 <linkunlink+0xf8>
    wait(0);
    2064:	4501                	li	a0,0
    2066:	00004097          	auipc	ra,0x4
    206a:	b68080e7          	jalr	-1176(ra) # 5bce <wait>
}
    206e:	60e6                	ld	ra,88(sp)
    2070:	6446                	ld	s0,80(sp)
    2072:	64a6                	ld	s1,72(sp)
    2074:	6906                	ld	s2,64(sp)
    2076:	79e2                	ld	s3,56(sp)
    2078:	7a42                	ld	s4,48(sp)
    207a:	7aa2                	ld	s5,40(sp)
    207c:	7b02                	ld	s6,32(sp)
    207e:	6be2                	ld	s7,24(sp)
    2080:	6c42                	ld	s8,16(sp)
    2082:	6ca2                	ld	s9,8(sp)
    2084:	6125                	addi	sp,sp,96
    2086:	8082                	ret
    exit(0);
    2088:	4501                	li	a0,0
    208a:	00004097          	auipc	ra,0x4
    208e:	b3c080e7          	jalr	-1220(ra) # 5bc6 <exit>

0000000000002092 <forktest>:
{
    2092:	7179                	addi	sp,sp,-48
    2094:	f406                	sd	ra,40(sp)
    2096:	f022                	sd	s0,32(sp)
    2098:	ec26                	sd	s1,24(sp)
    209a:	e84a                	sd	s2,16(sp)
    209c:	e44e                	sd	s3,8(sp)
    209e:	1800                	addi	s0,sp,48
    20a0:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    20a2:	4481                	li	s1,0
    20a4:	3e800913          	li	s2,1000
    pid = fork();
    20a8:	00004097          	auipc	ra,0x4
    20ac:	b16080e7          	jalr	-1258(ra) # 5bbe <fork>
    if(pid < 0)
    20b0:	02054863          	bltz	a0,20e0 <forktest+0x4e>
    if(pid == 0)
    20b4:	c115                	beqz	a0,20d8 <forktest+0x46>
  for(n=0; n<N; n++){
    20b6:	2485                	addiw	s1,s1,1
    20b8:	ff2498e3          	bne	s1,s2,20a8 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    20bc:	85ce                	mv	a1,s3
    20be:	00005517          	auipc	a0,0x5
    20c2:	b8a50513          	addi	a0,a0,-1142 # 6c48 <malloc+0xc3c>
    20c6:	00004097          	auipc	ra,0x4
    20ca:	e88080e7          	jalr	-376(ra) # 5f4e <printf>
    exit(1);
    20ce:	4505                	li	a0,1
    20d0:	00004097          	auipc	ra,0x4
    20d4:	af6080e7          	jalr	-1290(ra) # 5bc6 <exit>
      exit(0);
    20d8:	00004097          	auipc	ra,0x4
    20dc:	aee080e7          	jalr	-1298(ra) # 5bc6 <exit>
  if (n == 0) {
    20e0:	cc9d                	beqz	s1,211e <forktest+0x8c>
  if(n == N){
    20e2:	3e800793          	li	a5,1000
    20e6:	fcf48be3          	beq	s1,a5,20bc <forktest+0x2a>
  for(; n > 0; n--){
    20ea:	00905b63          	blez	s1,2100 <forktest+0x6e>
    if(wait(0) < 0){
    20ee:	4501                	li	a0,0
    20f0:	00004097          	auipc	ra,0x4
    20f4:	ade080e7          	jalr	-1314(ra) # 5bce <wait>
    20f8:	04054163          	bltz	a0,213a <forktest+0xa8>
  for(; n > 0; n--){
    20fc:	34fd                	addiw	s1,s1,-1
    20fe:	f8e5                	bnez	s1,20ee <forktest+0x5c>
  if(wait(0) != -1){
    2100:	4501                	li	a0,0
    2102:	00004097          	auipc	ra,0x4
    2106:	acc080e7          	jalr	-1332(ra) # 5bce <wait>
    210a:	57fd                	li	a5,-1
    210c:	04f51563          	bne	a0,a5,2156 <forktest+0xc4>
}
    2110:	70a2                	ld	ra,40(sp)
    2112:	7402                	ld	s0,32(sp)
    2114:	64e2                	ld	s1,24(sp)
    2116:	6942                	ld	s2,16(sp)
    2118:	69a2                	ld	s3,8(sp)
    211a:	6145                	addi	sp,sp,48
    211c:	8082                	ret
    printf("%s: no fork at all!\n", s);
    211e:	85ce                	mv	a1,s3
    2120:	00005517          	auipc	a0,0x5
    2124:	b1050513          	addi	a0,a0,-1264 # 6c30 <malloc+0xc24>
    2128:	00004097          	auipc	ra,0x4
    212c:	e26080e7          	jalr	-474(ra) # 5f4e <printf>
    exit(1);
    2130:	4505                	li	a0,1
    2132:	00004097          	auipc	ra,0x4
    2136:	a94080e7          	jalr	-1388(ra) # 5bc6 <exit>
      printf("%s: wait stopped early\n", s);
    213a:	85ce                	mv	a1,s3
    213c:	00005517          	auipc	a0,0x5
    2140:	b3450513          	addi	a0,a0,-1228 # 6c70 <malloc+0xc64>
    2144:	00004097          	auipc	ra,0x4
    2148:	e0a080e7          	jalr	-502(ra) # 5f4e <printf>
      exit(1);
    214c:	4505                	li	a0,1
    214e:	00004097          	auipc	ra,0x4
    2152:	a78080e7          	jalr	-1416(ra) # 5bc6 <exit>
    printf("%s: wait got too many\n", s);
    2156:	85ce                	mv	a1,s3
    2158:	00005517          	auipc	a0,0x5
    215c:	b3050513          	addi	a0,a0,-1232 # 6c88 <malloc+0xc7c>
    2160:	00004097          	auipc	ra,0x4
    2164:	dee080e7          	jalr	-530(ra) # 5f4e <printf>
    exit(1);
    2168:	4505                	li	a0,1
    216a:	00004097          	auipc	ra,0x4
    216e:	a5c080e7          	jalr	-1444(ra) # 5bc6 <exit>

0000000000002172 <kernmem>:
{
    2172:	715d                	addi	sp,sp,-80
    2174:	e486                	sd	ra,72(sp)
    2176:	e0a2                	sd	s0,64(sp)
    2178:	fc26                	sd	s1,56(sp)
    217a:	f84a                	sd	s2,48(sp)
    217c:	f44e                	sd	s3,40(sp)
    217e:	f052                	sd	s4,32(sp)
    2180:	ec56                	sd	s5,24(sp)
    2182:	0880                	addi	s0,sp,80
    2184:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2186:	4485                	li	s1,1
    2188:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    218a:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    218c:	69b1                	lui	s3,0xc
    218e:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1e08>
    2192:	1003d937          	lui	s2,0x1003d
    2196:	090e                	slli	s2,s2,0x3
    2198:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d828>
    pid = fork();
    219c:	00004097          	auipc	ra,0x4
    21a0:	a22080e7          	jalr	-1502(ra) # 5bbe <fork>
    if(pid < 0){
    21a4:	02054963          	bltz	a0,21d6 <kernmem+0x64>
    if(pid == 0){
    21a8:	c529                	beqz	a0,21f2 <kernmem+0x80>
    wait(&xstatus);
    21aa:	fbc40513          	addi	a0,s0,-68
    21ae:	00004097          	auipc	ra,0x4
    21b2:	a20080e7          	jalr	-1504(ra) # 5bce <wait>
    if(xstatus != -1)  // did kernel kill child?
    21b6:	fbc42783          	lw	a5,-68(s0)
    21ba:	05579d63          	bne	a5,s5,2214 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21be:	94ce                	add	s1,s1,s3
    21c0:	fd249ee3          	bne	s1,s2,219c <kernmem+0x2a>
}
    21c4:	60a6                	ld	ra,72(sp)
    21c6:	6406                	ld	s0,64(sp)
    21c8:	74e2                	ld	s1,56(sp)
    21ca:	7942                	ld	s2,48(sp)
    21cc:	79a2                	ld	s3,40(sp)
    21ce:	7a02                	ld	s4,32(sp)
    21d0:	6ae2                	ld	s5,24(sp)
    21d2:	6161                	addi	sp,sp,80
    21d4:	8082                	ret
      printf("%s: fork failed\n", s);
    21d6:	85d2                	mv	a1,s4
    21d8:	00004517          	auipc	a0,0x4
    21dc:	7f850513          	addi	a0,a0,2040 # 69d0 <malloc+0x9c4>
    21e0:	00004097          	auipc	ra,0x4
    21e4:	d6e080e7          	jalr	-658(ra) # 5f4e <printf>
      exit(1);
    21e8:	4505                	li	a0,1
    21ea:	00004097          	auipc	ra,0x4
    21ee:	9dc080e7          	jalr	-1572(ra) # 5bc6 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    21f2:	0004c683          	lbu	a3,0(s1)
    21f6:	8626                	mv	a2,s1
    21f8:	85d2                	mv	a1,s4
    21fa:	00005517          	auipc	a0,0x5
    21fe:	aa650513          	addi	a0,a0,-1370 # 6ca0 <malloc+0xc94>
    2202:	00004097          	auipc	ra,0x4
    2206:	d4c080e7          	jalr	-692(ra) # 5f4e <printf>
      exit(1);
    220a:	4505                	li	a0,1
    220c:	00004097          	auipc	ra,0x4
    2210:	9ba080e7          	jalr	-1606(ra) # 5bc6 <exit>
      exit(1);
    2214:	4505                	li	a0,1
    2216:	00004097          	auipc	ra,0x4
    221a:	9b0080e7          	jalr	-1616(ra) # 5bc6 <exit>

000000000000221e <bigargtest>:
{
    221e:	7179                	addi	sp,sp,-48
    2220:	f406                	sd	ra,40(sp)
    2222:	f022                	sd	s0,32(sp)
    2224:	ec26                	sd	s1,24(sp)
    2226:	1800                	addi	s0,sp,48
    2228:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    222a:	00005517          	auipc	a0,0x5
    222e:	a9650513          	addi	a0,a0,-1386 # 6cc0 <malloc+0xcb4>
    2232:	00004097          	auipc	ra,0x4
    2236:	9e4080e7          	jalr	-1564(ra) # 5c16 <unlink>
  pid = fork();
    223a:	00004097          	auipc	ra,0x4
    223e:	984080e7          	jalr	-1660(ra) # 5bbe <fork>
  if(pid == 0){
    2242:	c121                	beqz	a0,2282 <bigargtest+0x64>
  } else if(pid < 0){
    2244:	0a054063          	bltz	a0,22e4 <bigargtest+0xc6>
  wait(&xstatus);
    2248:	fdc40513          	addi	a0,s0,-36
    224c:	00004097          	auipc	ra,0x4
    2250:	982080e7          	jalr	-1662(ra) # 5bce <wait>
  if(xstatus != 0)
    2254:	fdc42503          	lw	a0,-36(s0)
    2258:	e545                	bnez	a0,2300 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    225a:	4581                	li	a1,0
    225c:	00005517          	auipc	a0,0x5
    2260:	a6450513          	addi	a0,a0,-1436 # 6cc0 <malloc+0xcb4>
    2264:	00004097          	auipc	ra,0x4
    2268:	9a2080e7          	jalr	-1630(ra) # 5c06 <open>
  if(fd < 0){
    226c:	08054e63          	bltz	a0,2308 <bigargtest+0xea>
  close(fd);
    2270:	00004097          	auipc	ra,0x4
    2274:	97e080e7          	jalr	-1666(ra) # 5bee <close>
}
    2278:	70a2                	ld	ra,40(sp)
    227a:	7402                	ld	s0,32(sp)
    227c:	64e2                	ld	s1,24(sp)
    227e:	6145                	addi	sp,sp,48
    2280:	8082                	ret
    2282:	00007797          	auipc	a5,0x7
    2286:	1be78793          	addi	a5,a5,446 # 9440 <args.1>
    228a:	00007697          	auipc	a3,0x7
    228e:	2ae68693          	addi	a3,a3,686 # 9538 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2292:	00005717          	auipc	a4,0x5
    2296:	a3e70713          	addi	a4,a4,-1474 # 6cd0 <malloc+0xcc4>
    229a:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    229c:	07a1                	addi	a5,a5,8
    229e:	fed79ee3          	bne	a5,a3,229a <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    22a2:	00007597          	auipc	a1,0x7
    22a6:	19e58593          	addi	a1,a1,414 # 9440 <args.1>
    22aa:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    22ae:	00004517          	auipc	a0,0x4
    22b2:	e9a50513          	addi	a0,a0,-358 # 6148 <malloc+0x13c>
    22b6:	00004097          	auipc	ra,0x4
    22ba:	948080e7          	jalr	-1720(ra) # 5bfe <exec>
    fd = open("bigarg-ok", O_CREATE);
    22be:	20000593          	li	a1,512
    22c2:	00005517          	auipc	a0,0x5
    22c6:	9fe50513          	addi	a0,a0,-1538 # 6cc0 <malloc+0xcb4>
    22ca:	00004097          	auipc	ra,0x4
    22ce:	93c080e7          	jalr	-1732(ra) # 5c06 <open>
    close(fd);
    22d2:	00004097          	auipc	ra,0x4
    22d6:	91c080e7          	jalr	-1764(ra) # 5bee <close>
    exit(0);
    22da:	4501                	li	a0,0
    22dc:	00004097          	auipc	ra,0x4
    22e0:	8ea080e7          	jalr	-1814(ra) # 5bc6 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    22e4:	85a6                	mv	a1,s1
    22e6:	00005517          	auipc	a0,0x5
    22ea:	aca50513          	addi	a0,a0,-1334 # 6db0 <malloc+0xda4>
    22ee:	00004097          	auipc	ra,0x4
    22f2:	c60080e7          	jalr	-928(ra) # 5f4e <printf>
    exit(1);
    22f6:	4505                	li	a0,1
    22f8:	00004097          	auipc	ra,0x4
    22fc:	8ce080e7          	jalr	-1842(ra) # 5bc6 <exit>
    exit(xstatus);
    2300:	00004097          	auipc	ra,0x4
    2304:	8c6080e7          	jalr	-1850(ra) # 5bc6 <exit>
    printf("%s: bigarg test failed!\n", s);
    2308:	85a6                	mv	a1,s1
    230a:	00005517          	auipc	a0,0x5
    230e:	ac650513          	addi	a0,a0,-1338 # 6dd0 <malloc+0xdc4>
    2312:	00004097          	auipc	ra,0x4
    2316:	c3c080e7          	jalr	-964(ra) # 5f4e <printf>
    exit(1);
    231a:	4505                	li	a0,1
    231c:	00004097          	auipc	ra,0x4
    2320:	8aa080e7          	jalr	-1878(ra) # 5bc6 <exit>

0000000000002324 <stacktest>:
{
    2324:	7179                	addi	sp,sp,-48
    2326:	f406                	sd	ra,40(sp)
    2328:	f022                	sd	s0,32(sp)
    232a:	ec26                	sd	s1,24(sp)
    232c:	1800                	addi	s0,sp,48
    232e:	84aa                	mv	s1,a0
  pid = fork();
    2330:	00004097          	auipc	ra,0x4
    2334:	88e080e7          	jalr	-1906(ra) # 5bbe <fork>
  if(pid == 0) {
    2338:	c115                	beqz	a0,235c <stacktest+0x38>
  } else if(pid < 0){
    233a:	04054463          	bltz	a0,2382 <stacktest+0x5e>
  wait(&xstatus);
    233e:	fdc40513          	addi	a0,s0,-36
    2342:	00004097          	auipc	ra,0x4
    2346:	88c080e7          	jalr	-1908(ra) # 5bce <wait>
  if(xstatus == -1)  // kernel killed child?
    234a:	fdc42503          	lw	a0,-36(s0)
    234e:	57fd                	li	a5,-1
    2350:	04f50763          	beq	a0,a5,239e <stacktest+0x7a>
    exit(xstatus);
    2354:	00004097          	auipc	ra,0x4
    2358:	872080e7          	jalr	-1934(ra) # 5bc6 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    235c:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    235e:	77fd                	lui	a5,0xfffff
    2360:	97ba                	add	a5,a5,a4
    2362:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef3a8>
    2366:	85a6                	mv	a1,s1
    2368:	00005517          	auipc	a0,0x5
    236c:	a8850513          	addi	a0,a0,-1400 # 6df0 <malloc+0xde4>
    2370:	00004097          	auipc	ra,0x4
    2374:	bde080e7          	jalr	-1058(ra) # 5f4e <printf>
    exit(1);
    2378:	4505                	li	a0,1
    237a:	00004097          	auipc	ra,0x4
    237e:	84c080e7          	jalr	-1972(ra) # 5bc6 <exit>
    printf("%s: fork failed\n", s);
    2382:	85a6                	mv	a1,s1
    2384:	00004517          	auipc	a0,0x4
    2388:	64c50513          	addi	a0,a0,1612 # 69d0 <malloc+0x9c4>
    238c:	00004097          	auipc	ra,0x4
    2390:	bc2080e7          	jalr	-1086(ra) # 5f4e <printf>
    exit(1);
    2394:	4505                	li	a0,1
    2396:	00004097          	auipc	ra,0x4
    239a:	830080e7          	jalr	-2000(ra) # 5bc6 <exit>
    exit(0);
    239e:	4501                	li	a0,0
    23a0:	00004097          	auipc	ra,0x4
    23a4:	826080e7          	jalr	-2010(ra) # 5bc6 <exit>

00000000000023a8 <textwrite>:
{
    23a8:	7179                	addi	sp,sp,-48
    23aa:	f406                	sd	ra,40(sp)
    23ac:	f022                	sd	s0,32(sp)
    23ae:	ec26                	sd	s1,24(sp)
    23b0:	1800                	addi	s0,sp,48
    23b2:	84aa                	mv	s1,a0
  pid = fork();
    23b4:	00004097          	auipc	ra,0x4
    23b8:	80a080e7          	jalr	-2038(ra) # 5bbe <fork>
  if(pid == 0) {
    23bc:	c115                	beqz	a0,23e0 <textwrite+0x38>
  } else if(pid < 0){
    23be:	02054963          	bltz	a0,23f0 <textwrite+0x48>
  wait(&xstatus);
    23c2:	fdc40513          	addi	a0,s0,-36
    23c6:	00004097          	auipc	ra,0x4
    23ca:	808080e7          	jalr	-2040(ra) # 5bce <wait>
  if(xstatus == -1)  // kernel killed child?
    23ce:	fdc42503          	lw	a0,-36(s0)
    23d2:	57fd                	li	a5,-1
    23d4:	02f50c63          	beq	a0,a5,240c <textwrite+0x64>
    exit(xstatus);
    23d8:	00003097          	auipc	ra,0x3
    23dc:	7ee080e7          	jalr	2030(ra) # 5bc6 <exit>
    *addr = 10;
    23e0:	47a9                	li	a5,10
    23e2:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    23e6:	4505                	li	a0,1
    23e8:	00003097          	auipc	ra,0x3
    23ec:	7de080e7          	jalr	2014(ra) # 5bc6 <exit>
    printf("%s: fork failed\n", s);
    23f0:	85a6                	mv	a1,s1
    23f2:	00004517          	auipc	a0,0x4
    23f6:	5de50513          	addi	a0,a0,1502 # 69d0 <malloc+0x9c4>
    23fa:	00004097          	auipc	ra,0x4
    23fe:	b54080e7          	jalr	-1196(ra) # 5f4e <printf>
    exit(1);
    2402:	4505                	li	a0,1
    2404:	00003097          	auipc	ra,0x3
    2408:	7c2080e7          	jalr	1986(ra) # 5bc6 <exit>
    exit(0);
    240c:	4501                	li	a0,0
    240e:	00003097          	auipc	ra,0x3
    2412:	7b8080e7          	jalr	1976(ra) # 5bc6 <exit>

0000000000002416 <manywrites>:
{
    2416:	711d                	addi	sp,sp,-96
    2418:	ec86                	sd	ra,88(sp)
    241a:	e8a2                	sd	s0,80(sp)
    241c:	e4a6                	sd	s1,72(sp)
    241e:	e0ca                	sd	s2,64(sp)
    2420:	fc4e                	sd	s3,56(sp)
    2422:	f852                	sd	s4,48(sp)
    2424:	f456                	sd	s5,40(sp)
    2426:	f05a                	sd	s6,32(sp)
    2428:	ec5e                	sd	s7,24(sp)
    242a:	1080                	addi	s0,sp,96
    242c:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    242e:	4981                	li	s3,0
    2430:	4911                	li	s2,4
    int pid = fork();
    2432:	00003097          	auipc	ra,0x3
    2436:	78c080e7          	jalr	1932(ra) # 5bbe <fork>
    243a:	84aa                	mv	s1,a0
    if(pid < 0){
    243c:	02054963          	bltz	a0,246e <manywrites+0x58>
    if(pid == 0){
    2440:	c521                	beqz	a0,2488 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    2442:	2985                	addiw	s3,s3,1
    2444:	ff2997e3          	bne	s3,s2,2432 <manywrites+0x1c>
    2448:	4491                	li	s1,4
    int st = 0;
    244a:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    244e:	fa840513          	addi	a0,s0,-88
    2452:	00003097          	auipc	ra,0x3
    2456:	77c080e7          	jalr	1916(ra) # 5bce <wait>
    if(st != 0)
    245a:	fa842503          	lw	a0,-88(s0)
    245e:	ed6d                	bnez	a0,2558 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    2460:	34fd                	addiw	s1,s1,-1
    2462:	f4e5                	bnez	s1,244a <manywrites+0x34>
  exit(0);
    2464:	4501                	li	a0,0
    2466:	00003097          	auipc	ra,0x3
    246a:	760080e7          	jalr	1888(ra) # 5bc6 <exit>
      printf("fork failed\n");
    246e:	00005517          	auipc	a0,0x5
    2472:	95250513          	addi	a0,a0,-1710 # 6dc0 <malloc+0xdb4>
    2476:	00004097          	auipc	ra,0x4
    247a:	ad8080e7          	jalr	-1320(ra) # 5f4e <printf>
      exit(1);
    247e:	4505                	li	a0,1
    2480:	00003097          	auipc	ra,0x3
    2484:	746080e7          	jalr	1862(ra) # 5bc6 <exit>
      name[0] = 'b';
    2488:	06200793          	li	a5,98
    248c:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    2490:	0619879b          	addiw	a5,s3,97
    2494:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    2498:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    249c:	fa840513          	addi	a0,s0,-88
    24a0:	00003097          	auipc	ra,0x3
    24a4:	776080e7          	jalr	1910(ra) # 5c16 <unlink>
    24a8:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    24aa:	0000ab17          	auipc	s6,0xa
    24ae:	7aeb0b13          	addi	s6,s6,1966 # cc58 <buf>
        for(int i = 0; i < ci+1; i++){
    24b2:	8a26                	mv	s4,s1
    24b4:	0209ce63          	bltz	s3,24f0 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    24b8:	20200593          	li	a1,514
    24bc:	fa840513          	addi	a0,s0,-88
    24c0:	00003097          	auipc	ra,0x3
    24c4:	746080e7          	jalr	1862(ra) # 5c06 <open>
    24c8:	892a                	mv	s2,a0
          if(fd < 0){
    24ca:	04054763          	bltz	a0,2518 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    24ce:	660d                	lui	a2,0x3
    24d0:	85da                	mv	a1,s6
    24d2:	00003097          	auipc	ra,0x3
    24d6:	714080e7          	jalr	1812(ra) # 5be6 <write>
          if(cc != sz){
    24da:	678d                	lui	a5,0x3
    24dc:	04f51e63          	bne	a0,a5,2538 <manywrites+0x122>
          close(fd);
    24e0:	854a                	mv	a0,s2
    24e2:	00003097          	auipc	ra,0x3
    24e6:	70c080e7          	jalr	1804(ra) # 5bee <close>
        for(int i = 0; i < ci+1; i++){
    24ea:	2a05                	addiw	s4,s4,1
    24ec:	fd49d6e3          	bge	s3,s4,24b8 <manywrites+0xa2>
        unlink(name);
    24f0:	fa840513          	addi	a0,s0,-88
    24f4:	00003097          	auipc	ra,0x3
    24f8:	722080e7          	jalr	1826(ra) # 5c16 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    24fc:	3bfd                	addiw	s7,s7,-1
    24fe:	fa0b9ae3          	bnez	s7,24b2 <manywrites+0x9c>
      unlink(name);
    2502:	fa840513          	addi	a0,s0,-88
    2506:	00003097          	auipc	ra,0x3
    250a:	710080e7          	jalr	1808(ra) # 5c16 <unlink>
      exit(0);
    250e:	4501                	li	a0,0
    2510:	00003097          	auipc	ra,0x3
    2514:	6b6080e7          	jalr	1718(ra) # 5bc6 <exit>
            printf("%s: cannot create %s\n", s, name);
    2518:	fa840613          	addi	a2,s0,-88
    251c:	85d6                	mv	a1,s5
    251e:	00005517          	auipc	a0,0x5
    2522:	8fa50513          	addi	a0,a0,-1798 # 6e18 <malloc+0xe0c>
    2526:	00004097          	auipc	ra,0x4
    252a:	a28080e7          	jalr	-1496(ra) # 5f4e <printf>
            exit(1);
    252e:	4505                	li	a0,1
    2530:	00003097          	auipc	ra,0x3
    2534:	696080e7          	jalr	1686(ra) # 5bc6 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    2538:	86aa                	mv	a3,a0
    253a:	660d                	lui	a2,0x3
    253c:	85d6                	mv	a1,s5
    253e:	00004517          	auipc	a0,0x4
    2542:	cda50513          	addi	a0,a0,-806 # 6218 <malloc+0x20c>
    2546:	00004097          	auipc	ra,0x4
    254a:	a08080e7          	jalr	-1528(ra) # 5f4e <printf>
            exit(1);
    254e:	4505                	li	a0,1
    2550:	00003097          	auipc	ra,0x3
    2554:	676080e7          	jalr	1654(ra) # 5bc6 <exit>
      exit(st);
    2558:	00003097          	auipc	ra,0x3
    255c:	66e080e7          	jalr	1646(ra) # 5bc6 <exit>

0000000000002560 <copyinstr3>:
{
    2560:	7179                	addi	sp,sp,-48
    2562:	f406                	sd	ra,40(sp)
    2564:	f022                	sd	s0,32(sp)
    2566:	ec26                	sd	s1,24(sp)
    2568:	1800                	addi	s0,sp,48
  sbrk(8192);
    256a:	6509                	lui	a0,0x2
    256c:	00003097          	auipc	ra,0x3
    2570:	6e2080e7          	jalr	1762(ra) # 5c4e <sbrk>
  uint64 top = (uint64) sbrk(0);
    2574:	4501                	li	a0,0
    2576:	00003097          	auipc	ra,0x3
    257a:	6d8080e7          	jalr	1752(ra) # 5c4e <sbrk>
  if((top % PGSIZE) != 0){
    257e:	03451793          	slli	a5,a0,0x34
    2582:	e3c9                	bnez	a5,2604 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2584:	4501                	li	a0,0
    2586:	00003097          	auipc	ra,0x3
    258a:	6c8080e7          	jalr	1736(ra) # 5c4e <sbrk>
  if(top % PGSIZE){
    258e:	03451793          	slli	a5,a0,0x34
    2592:	e3d9                	bnez	a5,2618 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2594:	fff50493          	addi	s1,a0,-1 # 1fff <linkunlink+0x6f>
  *b = 'x';
    2598:	07800793          	li	a5,120
    259c:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    25a0:	8526                	mv	a0,s1
    25a2:	00003097          	auipc	ra,0x3
    25a6:	674080e7          	jalr	1652(ra) # 5c16 <unlink>
  if(ret != -1){
    25aa:	57fd                	li	a5,-1
    25ac:	08f51363          	bne	a0,a5,2632 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    25b0:	20100593          	li	a1,513
    25b4:	8526                	mv	a0,s1
    25b6:	00003097          	auipc	ra,0x3
    25ba:	650080e7          	jalr	1616(ra) # 5c06 <open>
  if(fd != -1){
    25be:	57fd                	li	a5,-1
    25c0:	08f51863          	bne	a0,a5,2650 <copyinstr3+0xf0>
  ret = link(b, b);
    25c4:	85a6                	mv	a1,s1
    25c6:	8526                	mv	a0,s1
    25c8:	00003097          	auipc	ra,0x3
    25cc:	65e080e7          	jalr	1630(ra) # 5c26 <link>
  if(ret != -1){
    25d0:	57fd                	li	a5,-1
    25d2:	08f51e63          	bne	a0,a5,266e <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    25d6:	00005797          	auipc	a5,0x5
    25da:	53a78793          	addi	a5,a5,1338 # 7b10 <malloc+0x1b04>
    25de:	fcf43823          	sd	a5,-48(s0)
    25e2:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    25e6:	fd040593          	addi	a1,s0,-48
    25ea:	8526                	mv	a0,s1
    25ec:	00003097          	auipc	ra,0x3
    25f0:	612080e7          	jalr	1554(ra) # 5bfe <exec>
  if(ret != -1){
    25f4:	57fd                	li	a5,-1
    25f6:	08f51c63          	bne	a0,a5,268e <copyinstr3+0x12e>
}
    25fa:	70a2                	ld	ra,40(sp)
    25fc:	7402                	ld	s0,32(sp)
    25fe:	64e2                	ld	s1,24(sp)
    2600:	6145                	addi	sp,sp,48
    2602:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2604:	0347d513          	srli	a0,a5,0x34
    2608:	6785                	lui	a5,0x1
    260a:	40a7853b          	subw	a0,a5,a0
    260e:	00003097          	auipc	ra,0x3
    2612:	640080e7          	jalr	1600(ra) # 5c4e <sbrk>
    2616:	b7bd                	j	2584 <copyinstr3+0x24>
    printf("oops\n");
    2618:	00005517          	auipc	a0,0x5
    261c:	81850513          	addi	a0,a0,-2024 # 6e30 <malloc+0xe24>
    2620:	00004097          	auipc	ra,0x4
    2624:	92e080e7          	jalr	-1746(ra) # 5f4e <printf>
    exit(1);
    2628:	4505                	li	a0,1
    262a:	00003097          	auipc	ra,0x3
    262e:	59c080e7          	jalr	1436(ra) # 5bc6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2632:	862a                	mv	a2,a0
    2634:	85a6                	mv	a1,s1
    2636:	00004517          	auipc	a0,0x4
    263a:	2ba50513          	addi	a0,a0,698 # 68f0 <malloc+0x8e4>
    263e:	00004097          	auipc	ra,0x4
    2642:	910080e7          	jalr	-1776(ra) # 5f4e <printf>
    exit(1);
    2646:	4505                	li	a0,1
    2648:	00003097          	auipc	ra,0x3
    264c:	57e080e7          	jalr	1406(ra) # 5bc6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2650:	862a                	mv	a2,a0
    2652:	85a6                	mv	a1,s1
    2654:	00004517          	auipc	a0,0x4
    2658:	2bc50513          	addi	a0,a0,700 # 6910 <malloc+0x904>
    265c:	00004097          	auipc	ra,0x4
    2660:	8f2080e7          	jalr	-1806(ra) # 5f4e <printf>
    exit(1);
    2664:	4505                	li	a0,1
    2666:	00003097          	auipc	ra,0x3
    266a:	560080e7          	jalr	1376(ra) # 5bc6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    266e:	86aa                	mv	a3,a0
    2670:	8626                	mv	a2,s1
    2672:	85a6                	mv	a1,s1
    2674:	00004517          	auipc	a0,0x4
    2678:	2bc50513          	addi	a0,a0,700 # 6930 <malloc+0x924>
    267c:	00004097          	auipc	ra,0x4
    2680:	8d2080e7          	jalr	-1838(ra) # 5f4e <printf>
    exit(1);
    2684:	4505                	li	a0,1
    2686:	00003097          	auipc	ra,0x3
    268a:	540080e7          	jalr	1344(ra) # 5bc6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    268e:	567d                	li	a2,-1
    2690:	85a6                	mv	a1,s1
    2692:	00004517          	auipc	a0,0x4
    2696:	2c650513          	addi	a0,a0,710 # 6958 <malloc+0x94c>
    269a:	00004097          	auipc	ra,0x4
    269e:	8b4080e7          	jalr	-1868(ra) # 5f4e <printf>
    exit(1);
    26a2:	4505                	li	a0,1
    26a4:	00003097          	auipc	ra,0x3
    26a8:	522080e7          	jalr	1314(ra) # 5bc6 <exit>

00000000000026ac <rwsbrk>:
{
    26ac:	1101                	addi	sp,sp,-32
    26ae:	ec06                	sd	ra,24(sp)
    26b0:	e822                	sd	s0,16(sp)
    26b2:	e426                	sd	s1,8(sp)
    26b4:	e04a                	sd	s2,0(sp)
    26b6:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    26b8:	6509                	lui	a0,0x2
    26ba:	00003097          	auipc	ra,0x3
    26be:	594080e7          	jalr	1428(ra) # 5c4e <sbrk>
  if(a == 0xffffffffffffffffLL) {
    26c2:	57fd                	li	a5,-1
    26c4:	06f50363          	beq	a0,a5,272a <rwsbrk+0x7e>
    26c8:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    26ca:	7579                	lui	a0,0xffffe
    26cc:	00003097          	auipc	ra,0x3
    26d0:	582080e7          	jalr	1410(ra) # 5c4e <sbrk>
    26d4:	57fd                	li	a5,-1
    26d6:	06f50763          	beq	a0,a5,2744 <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    26da:	20100593          	li	a1,513
    26de:	00004517          	auipc	a0,0x4
    26e2:	79250513          	addi	a0,a0,1938 # 6e70 <malloc+0xe64>
    26e6:	00003097          	auipc	ra,0x3
    26ea:	520080e7          	jalr	1312(ra) # 5c06 <open>
    26ee:	892a                	mv	s2,a0
  if(fd < 0){
    26f0:	06054763          	bltz	a0,275e <rwsbrk+0xb2>
  n = write(fd, (void*)(a+4096), 1024);
    26f4:	6505                	lui	a0,0x1
    26f6:	94aa                	add	s1,s1,a0
    26f8:	40000613          	li	a2,1024
    26fc:	85a6                	mv	a1,s1
    26fe:	854a                	mv	a0,s2
    2700:	00003097          	auipc	ra,0x3
    2704:	4e6080e7          	jalr	1254(ra) # 5be6 <write>
    2708:	862a                	mv	a2,a0
  if(n >= 0){
    270a:	06054763          	bltz	a0,2778 <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    270e:	85a6                	mv	a1,s1
    2710:	00004517          	auipc	a0,0x4
    2714:	78050513          	addi	a0,a0,1920 # 6e90 <malloc+0xe84>
    2718:	00004097          	auipc	ra,0x4
    271c:	836080e7          	jalr	-1994(ra) # 5f4e <printf>
    exit(1);
    2720:	4505                	li	a0,1
    2722:	00003097          	auipc	ra,0x3
    2726:	4a4080e7          	jalr	1188(ra) # 5bc6 <exit>
    printf("sbrk(rwsbrk) failed\n");
    272a:	00004517          	auipc	a0,0x4
    272e:	70e50513          	addi	a0,a0,1806 # 6e38 <malloc+0xe2c>
    2732:	00004097          	auipc	ra,0x4
    2736:	81c080e7          	jalr	-2020(ra) # 5f4e <printf>
    exit(1);
    273a:	4505                	li	a0,1
    273c:	00003097          	auipc	ra,0x3
    2740:	48a080e7          	jalr	1162(ra) # 5bc6 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    2744:	00004517          	auipc	a0,0x4
    2748:	70c50513          	addi	a0,a0,1804 # 6e50 <malloc+0xe44>
    274c:	00004097          	auipc	ra,0x4
    2750:	802080e7          	jalr	-2046(ra) # 5f4e <printf>
    exit(1);
    2754:	4505                	li	a0,1
    2756:	00003097          	auipc	ra,0x3
    275a:	470080e7          	jalr	1136(ra) # 5bc6 <exit>
    printf("open(rwsbrk) failed\n");
    275e:	00004517          	auipc	a0,0x4
    2762:	71a50513          	addi	a0,a0,1818 # 6e78 <malloc+0xe6c>
    2766:	00003097          	auipc	ra,0x3
    276a:	7e8080e7          	jalr	2024(ra) # 5f4e <printf>
    exit(1);
    276e:	4505                	li	a0,1
    2770:	00003097          	auipc	ra,0x3
    2774:	456080e7          	jalr	1110(ra) # 5bc6 <exit>
  close(fd);
    2778:	854a                	mv	a0,s2
    277a:	00003097          	auipc	ra,0x3
    277e:	474080e7          	jalr	1140(ra) # 5bee <close>
  unlink("rwsbrk");
    2782:	00004517          	auipc	a0,0x4
    2786:	6ee50513          	addi	a0,a0,1774 # 6e70 <malloc+0xe64>
    278a:	00003097          	auipc	ra,0x3
    278e:	48c080e7          	jalr	1164(ra) # 5c16 <unlink>
  fd = open("README", O_RDONLY);
    2792:	4581                	li	a1,0
    2794:	00004517          	auipc	a0,0x4
    2798:	b8c50513          	addi	a0,a0,-1140 # 6320 <malloc+0x314>
    279c:	00003097          	auipc	ra,0x3
    27a0:	46a080e7          	jalr	1130(ra) # 5c06 <open>
    27a4:	892a                	mv	s2,a0
  if(fd < 0){
    27a6:	02054963          	bltz	a0,27d8 <rwsbrk+0x12c>
  n = read(fd, (void*)(a+4096), 10);
    27aa:	4629                	li	a2,10
    27ac:	85a6                	mv	a1,s1
    27ae:	00003097          	auipc	ra,0x3
    27b2:	430080e7          	jalr	1072(ra) # 5bde <read>
    27b6:	862a                	mv	a2,a0
  if(n >= 0){
    27b8:	02054d63          	bltz	a0,27f2 <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    27bc:	85a6                	mv	a1,s1
    27be:	00004517          	auipc	a0,0x4
    27c2:	70250513          	addi	a0,a0,1794 # 6ec0 <malloc+0xeb4>
    27c6:	00003097          	auipc	ra,0x3
    27ca:	788080e7          	jalr	1928(ra) # 5f4e <printf>
    exit(1);
    27ce:	4505                	li	a0,1
    27d0:	00003097          	auipc	ra,0x3
    27d4:	3f6080e7          	jalr	1014(ra) # 5bc6 <exit>
    printf("open(rwsbrk) failed\n");
    27d8:	00004517          	auipc	a0,0x4
    27dc:	6a050513          	addi	a0,a0,1696 # 6e78 <malloc+0xe6c>
    27e0:	00003097          	auipc	ra,0x3
    27e4:	76e080e7          	jalr	1902(ra) # 5f4e <printf>
    exit(1);
    27e8:	4505                	li	a0,1
    27ea:	00003097          	auipc	ra,0x3
    27ee:	3dc080e7          	jalr	988(ra) # 5bc6 <exit>
  close(fd);
    27f2:	854a                	mv	a0,s2
    27f4:	00003097          	auipc	ra,0x3
    27f8:	3fa080e7          	jalr	1018(ra) # 5bee <close>
  exit(0);
    27fc:	4501                	li	a0,0
    27fe:	00003097          	auipc	ra,0x3
    2802:	3c8080e7          	jalr	968(ra) # 5bc6 <exit>

0000000000002806 <sbrkbasic>:
{
    2806:	7139                	addi	sp,sp,-64
    2808:	fc06                	sd	ra,56(sp)
    280a:	f822                	sd	s0,48(sp)
    280c:	f426                	sd	s1,40(sp)
    280e:	f04a                	sd	s2,32(sp)
    2810:	ec4e                	sd	s3,24(sp)
    2812:	e852                	sd	s4,16(sp)
    2814:	0080                	addi	s0,sp,64
    2816:	8a2a                	mv	s4,a0
  pid = fork();
    2818:	00003097          	auipc	ra,0x3
    281c:	3a6080e7          	jalr	934(ra) # 5bbe <fork>
  if(pid < 0){
    2820:	02054c63          	bltz	a0,2858 <sbrkbasic+0x52>
  if(pid == 0){
    2824:	ed21                	bnez	a0,287c <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    2826:	40000537          	lui	a0,0x40000
    282a:	00003097          	auipc	ra,0x3
    282e:	424080e7          	jalr	1060(ra) # 5c4e <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2832:	57fd                	li	a5,-1
    2834:	02f50f63          	beq	a0,a5,2872 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2838:	400007b7          	lui	a5,0x40000
    283c:	97aa                	add	a5,a5,a0
      *b = 99;
    283e:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2842:	6705                	lui	a4,0x1
      *b = 99;
    2844:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff03a8>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2848:	953a                	add	a0,a0,a4
    284a:	fef51de3          	bne	a0,a5,2844 <sbrkbasic+0x3e>
    exit(1);
    284e:	4505                	li	a0,1
    2850:	00003097          	auipc	ra,0x3
    2854:	376080e7          	jalr	886(ra) # 5bc6 <exit>
    printf("fork failed in sbrkbasic\n");
    2858:	00004517          	auipc	a0,0x4
    285c:	69050513          	addi	a0,a0,1680 # 6ee8 <malloc+0xedc>
    2860:	00003097          	auipc	ra,0x3
    2864:	6ee080e7          	jalr	1774(ra) # 5f4e <printf>
    exit(1);
    2868:	4505                	li	a0,1
    286a:	00003097          	auipc	ra,0x3
    286e:	35c080e7          	jalr	860(ra) # 5bc6 <exit>
      exit(0);
    2872:	4501                	li	a0,0
    2874:	00003097          	auipc	ra,0x3
    2878:	352080e7          	jalr	850(ra) # 5bc6 <exit>
  wait(&xstatus);
    287c:	fcc40513          	addi	a0,s0,-52
    2880:	00003097          	auipc	ra,0x3
    2884:	34e080e7          	jalr	846(ra) # 5bce <wait>
  if(xstatus == 1){
    2888:	fcc42703          	lw	a4,-52(s0)
    288c:	4785                	li	a5,1
    288e:	00f70d63          	beq	a4,a5,28a8 <sbrkbasic+0xa2>
  a = sbrk(0);
    2892:	4501                	li	a0,0
    2894:	00003097          	auipc	ra,0x3
    2898:	3ba080e7          	jalr	954(ra) # 5c4e <sbrk>
    289c:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    289e:	4901                	li	s2,0
    28a0:	6985                	lui	s3,0x1
    28a2:	38898993          	addi	s3,s3,904 # 1388 <badarg+0x3c>
    28a6:	a005                	j	28c6 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    28a8:	85d2                	mv	a1,s4
    28aa:	00004517          	auipc	a0,0x4
    28ae:	65e50513          	addi	a0,a0,1630 # 6f08 <malloc+0xefc>
    28b2:	00003097          	auipc	ra,0x3
    28b6:	69c080e7          	jalr	1692(ra) # 5f4e <printf>
    exit(1);
    28ba:	4505                	li	a0,1
    28bc:	00003097          	auipc	ra,0x3
    28c0:	30a080e7          	jalr	778(ra) # 5bc6 <exit>
    a = b + 1;
    28c4:	84be                	mv	s1,a5
    b = sbrk(1);
    28c6:	4505                	li	a0,1
    28c8:	00003097          	auipc	ra,0x3
    28cc:	386080e7          	jalr	902(ra) # 5c4e <sbrk>
    if(b != a){
    28d0:	04951c63          	bne	a0,s1,2928 <sbrkbasic+0x122>
    *b = 1;
    28d4:	4785                	li	a5,1
    28d6:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    28da:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    28de:	2905                	addiw	s2,s2,1
    28e0:	ff3912e3          	bne	s2,s3,28c4 <sbrkbasic+0xbe>
  pid = fork();
    28e4:	00003097          	auipc	ra,0x3
    28e8:	2da080e7          	jalr	730(ra) # 5bbe <fork>
    28ec:	892a                	mv	s2,a0
  if(pid < 0){
    28ee:	04054e63          	bltz	a0,294a <sbrkbasic+0x144>
  c = sbrk(1);
    28f2:	4505                	li	a0,1
    28f4:	00003097          	auipc	ra,0x3
    28f8:	35a080e7          	jalr	858(ra) # 5c4e <sbrk>
  c = sbrk(1);
    28fc:	4505                	li	a0,1
    28fe:	00003097          	auipc	ra,0x3
    2902:	350080e7          	jalr	848(ra) # 5c4e <sbrk>
  if(c != a + 1){
    2906:	0489                	addi	s1,s1,2
    2908:	04a48f63          	beq	s1,a0,2966 <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    290c:	85d2                	mv	a1,s4
    290e:	00004517          	auipc	a0,0x4
    2912:	65a50513          	addi	a0,a0,1626 # 6f68 <malloc+0xf5c>
    2916:	00003097          	auipc	ra,0x3
    291a:	638080e7          	jalr	1592(ra) # 5f4e <printf>
    exit(1);
    291e:	4505                	li	a0,1
    2920:	00003097          	auipc	ra,0x3
    2924:	2a6080e7          	jalr	678(ra) # 5bc6 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    2928:	872a                	mv	a4,a0
    292a:	86a6                	mv	a3,s1
    292c:	864a                	mv	a2,s2
    292e:	85d2                	mv	a1,s4
    2930:	00004517          	auipc	a0,0x4
    2934:	5f850513          	addi	a0,a0,1528 # 6f28 <malloc+0xf1c>
    2938:	00003097          	auipc	ra,0x3
    293c:	616080e7          	jalr	1558(ra) # 5f4e <printf>
      exit(1);
    2940:	4505                	li	a0,1
    2942:	00003097          	auipc	ra,0x3
    2946:	284080e7          	jalr	644(ra) # 5bc6 <exit>
    printf("%s: sbrk test fork failed\n", s);
    294a:	85d2                	mv	a1,s4
    294c:	00004517          	auipc	a0,0x4
    2950:	5fc50513          	addi	a0,a0,1532 # 6f48 <malloc+0xf3c>
    2954:	00003097          	auipc	ra,0x3
    2958:	5fa080e7          	jalr	1530(ra) # 5f4e <printf>
    exit(1);
    295c:	4505                	li	a0,1
    295e:	00003097          	auipc	ra,0x3
    2962:	268080e7          	jalr	616(ra) # 5bc6 <exit>
  if(pid == 0)
    2966:	00091763          	bnez	s2,2974 <sbrkbasic+0x16e>
    exit(0);
    296a:	4501                	li	a0,0
    296c:	00003097          	auipc	ra,0x3
    2970:	25a080e7          	jalr	602(ra) # 5bc6 <exit>
  wait(&xstatus);
    2974:	fcc40513          	addi	a0,s0,-52
    2978:	00003097          	auipc	ra,0x3
    297c:	256080e7          	jalr	598(ra) # 5bce <wait>
  exit(xstatus);
    2980:	fcc42503          	lw	a0,-52(s0)
    2984:	00003097          	auipc	ra,0x3
    2988:	242080e7          	jalr	578(ra) # 5bc6 <exit>

000000000000298c <sbrkmuch>:
{
    298c:	7179                	addi	sp,sp,-48
    298e:	f406                	sd	ra,40(sp)
    2990:	f022                	sd	s0,32(sp)
    2992:	ec26                	sd	s1,24(sp)
    2994:	e84a                	sd	s2,16(sp)
    2996:	e44e                	sd	s3,8(sp)
    2998:	e052                	sd	s4,0(sp)
    299a:	1800                	addi	s0,sp,48
    299c:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    299e:	4501                	li	a0,0
    29a0:	00003097          	auipc	ra,0x3
    29a4:	2ae080e7          	jalr	686(ra) # 5c4e <sbrk>
    29a8:	892a                	mv	s2,a0
  a = sbrk(0);
    29aa:	4501                	li	a0,0
    29ac:	00003097          	auipc	ra,0x3
    29b0:	2a2080e7          	jalr	674(ra) # 5c4e <sbrk>
    29b4:	84aa                	mv	s1,a0
  p = sbrk(amt);
    29b6:	06400537          	lui	a0,0x6400
    29ba:	9d05                	subw	a0,a0,s1
    29bc:	00003097          	auipc	ra,0x3
    29c0:	292080e7          	jalr	658(ra) # 5c4e <sbrk>
  if (p != a) {
    29c4:	0ca49863          	bne	s1,a0,2a94 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    29c8:	4501                	li	a0,0
    29ca:	00003097          	auipc	ra,0x3
    29ce:	284080e7          	jalr	644(ra) # 5c4e <sbrk>
    29d2:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    29d4:	00a4f963          	bgeu	s1,a0,29e6 <sbrkmuch+0x5a>
    *pp = 1;
    29d8:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    29da:	6705                	lui	a4,0x1
    *pp = 1;
    29dc:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    29e0:	94ba                	add	s1,s1,a4
    29e2:	fef4ede3          	bltu	s1,a5,29dc <sbrkmuch+0x50>
  *lastaddr = 99;
    29e6:	064007b7          	lui	a5,0x6400
    29ea:	06300713          	li	a4,99
    29ee:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f03a7>
  a = sbrk(0);
    29f2:	4501                	li	a0,0
    29f4:	00003097          	auipc	ra,0x3
    29f8:	25a080e7          	jalr	602(ra) # 5c4e <sbrk>
    29fc:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    29fe:	757d                	lui	a0,0xfffff
    2a00:	00003097          	auipc	ra,0x3
    2a04:	24e080e7          	jalr	590(ra) # 5c4e <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2a08:	57fd                	li	a5,-1
    2a0a:	0af50363          	beq	a0,a5,2ab0 <sbrkmuch+0x124>
  c = sbrk(0);
    2a0e:	4501                	li	a0,0
    2a10:	00003097          	auipc	ra,0x3
    2a14:	23e080e7          	jalr	574(ra) # 5c4e <sbrk>
  if(c != a - PGSIZE){
    2a18:	77fd                	lui	a5,0xfffff
    2a1a:	97a6                	add	a5,a5,s1
    2a1c:	0af51863          	bne	a0,a5,2acc <sbrkmuch+0x140>
  a = sbrk(0);
    2a20:	4501                	li	a0,0
    2a22:	00003097          	auipc	ra,0x3
    2a26:	22c080e7          	jalr	556(ra) # 5c4e <sbrk>
    2a2a:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2a2c:	6505                	lui	a0,0x1
    2a2e:	00003097          	auipc	ra,0x3
    2a32:	220080e7          	jalr	544(ra) # 5c4e <sbrk>
    2a36:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2a38:	0aa49a63          	bne	s1,a0,2aec <sbrkmuch+0x160>
    2a3c:	4501                	li	a0,0
    2a3e:	00003097          	auipc	ra,0x3
    2a42:	210080e7          	jalr	528(ra) # 5c4e <sbrk>
    2a46:	6785                	lui	a5,0x1
    2a48:	97a6                	add	a5,a5,s1
    2a4a:	0af51163          	bne	a0,a5,2aec <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2a4e:	064007b7          	lui	a5,0x6400
    2a52:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f03a7>
    2a56:	06300793          	li	a5,99
    2a5a:	0af70963          	beq	a4,a5,2b0c <sbrkmuch+0x180>
  a = sbrk(0);
    2a5e:	4501                	li	a0,0
    2a60:	00003097          	auipc	ra,0x3
    2a64:	1ee080e7          	jalr	494(ra) # 5c4e <sbrk>
    2a68:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2a6a:	4501                	li	a0,0
    2a6c:	00003097          	auipc	ra,0x3
    2a70:	1e2080e7          	jalr	482(ra) # 5c4e <sbrk>
    2a74:	40a9053b          	subw	a0,s2,a0
    2a78:	00003097          	auipc	ra,0x3
    2a7c:	1d6080e7          	jalr	470(ra) # 5c4e <sbrk>
  if(c != a){
    2a80:	0aa49463          	bne	s1,a0,2b28 <sbrkmuch+0x19c>
}
    2a84:	70a2                	ld	ra,40(sp)
    2a86:	7402                	ld	s0,32(sp)
    2a88:	64e2                	ld	s1,24(sp)
    2a8a:	6942                	ld	s2,16(sp)
    2a8c:	69a2                	ld	s3,8(sp)
    2a8e:	6a02                	ld	s4,0(sp)
    2a90:	6145                	addi	sp,sp,48
    2a92:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2a94:	85ce                	mv	a1,s3
    2a96:	00004517          	auipc	a0,0x4
    2a9a:	4f250513          	addi	a0,a0,1266 # 6f88 <malloc+0xf7c>
    2a9e:	00003097          	auipc	ra,0x3
    2aa2:	4b0080e7          	jalr	1200(ra) # 5f4e <printf>
    exit(1);
    2aa6:	4505                	li	a0,1
    2aa8:	00003097          	auipc	ra,0x3
    2aac:	11e080e7          	jalr	286(ra) # 5bc6 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2ab0:	85ce                	mv	a1,s3
    2ab2:	00004517          	auipc	a0,0x4
    2ab6:	51e50513          	addi	a0,a0,1310 # 6fd0 <malloc+0xfc4>
    2aba:	00003097          	auipc	ra,0x3
    2abe:	494080e7          	jalr	1172(ra) # 5f4e <printf>
    exit(1);
    2ac2:	4505                	li	a0,1
    2ac4:	00003097          	auipc	ra,0x3
    2ac8:	102080e7          	jalr	258(ra) # 5bc6 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2acc:	86aa                	mv	a3,a0
    2ace:	8626                	mv	a2,s1
    2ad0:	85ce                	mv	a1,s3
    2ad2:	00004517          	auipc	a0,0x4
    2ad6:	51e50513          	addi	a0,a0,1310 # 6ff0 <malloc+0xfe4>
    2ada:	00003097          	auipc	ra,0x3
    2ade:	474080e7          	jalr	1140(ra) # 5f4e <printf>
    exit(1);
    2ae2:	4505                	li	a0,1
    2ae4:	00003097          	auipc	ra,0x3
    2ae8:	0e2080e7          	jalr	226(ra) # 5bc6 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2aec:	86d2                	mv	a3,s4
    2aee:	8626                	mv	a2,s1
    2af0:	85ce                	mv	a1,s3
    2af2:	00004517          	auipc	a0,0x4
    2af6:	53e50513          	addi	a0,a0,1342 # 7030 <malloc+0x1024>
    2afa:	00003097          	auipc	ra,0x3
    2afe:	454080e7          	jalr	1108(ra) # 5f4e <printf>
    exit(1);
    2b02:	4505                	li	a0,1
    2b04:	00003097          	auipc	ra,0x3
    2b08:	0c2080e7          	jalr	194(ra) # 5bc6 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2b0c:	85ce                	mv	a1,s3
    2b0e:	00004517          	auipc	a0,0x4
    2b12:	55250513          	addi	a0,a0,1362 # 7060 <malloc+0x1054>
    2b16:	00003097          	auipc	ra,0x3
    2b1a:	438080e7          	jalr	1080(ra) # 5f4e <printf>
    exit(1);
    2b1e:	4505                	li	a0,1
    2b20:	00003097          	auipc	ra,0x3
    2b24:	0a6080e7          	jalr	166(ra) # 5bc6 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2b28:	86aa                	mv	a3,a0
    2b2a:	8626                	mv	a2,s1
    2b2c:	85ce                	mv	a1,s3
    2b2e:	00004517          	auipc	a0,0x4
    2b32:	56a50513          	addi	a0,a0,1386 # 7098 <malloc+0x108c>
    2b36:	00003097          	auipc	ra,0x3
    2b3a:	418080e7          	jalr	1048(ra) # 5f4e <printf>
    exit(1);
    2b3e:	4505                	li	a0,1
    2b40:	00003097          	auipc	ra,0x3
    2b44:	086080e7          	jalr	134(ra) # 5bc6 <exit>

0000000000002b48 <sbrkarg>:
{
    2b48:	7179                	addi	sp,sp,-48
    2b4a:	f406                	sd	ra,40(sp)
    2b4c:	f022                	sd	s0,32(sp)
    2b4e:	ec26                	sd	s1,24(sp)
    2b50:	e84a                	sd	s2,16(sp)
    2b52:	e44e                	sd	s3,8(sp)
    2b54:	1800                	addi	s0,sp,48
    2b56:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2b58:	6505                	lui	a0,0x1
    2b5a:	00003097          	auipc	ra,0x3
    2b5e:	0f4080e7          	jalr	244(ra) # 5c4e <sbrk>
    2b62:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2b64:	20100593          	li	a1,513
    2b68:	00004517          	auipc	a0,0x4
    2b6c:	55850513          	addi	a0,a0,1368 # 70c0 <malloc+0x10b4>
    2b70:	00003097          	auipc	ra,0x3
    2b74:	096080e7          	jalr	150(ra) # 5c06 <open>
    2b78:	84aa                	mv	s1,a0
  unlink("sbrk");
    2b7a:	00004517          	auipc	a0,0x4
    2b7e:	54650513          	addi	a0,a0,1350 # 70c0 <malloc+0x10b4>
    2b82:	00003097          	auipc	ra,0x3
    2b86:	094080e7          	jalr	148(ra) # 5c16 <unlink>
  if(fd < 0)  {
    2b8a:	0404c163          	bltz	s1,2bcc <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2b8e:	6605                	lui	a2,0x1
    2b90:	85ca                	mv	a1,s2
    2b92:	8526                	mv	a0,s1
    2b94:	00003097          	auipc	ra,0x3
    2b98:	052080e7          	jalr	82(ra) # 5be6 <write>
    2b9c:	04054663          	bltz	a0,2be8 <sbrkarg+0xa0>
  close(fd);
    2ba0:	8526                	mv	a0,s1
    2ba2:	00003097          	auipc	ra,0x3
    2ba6:	04c080e7          	jalr	76(ra) # 5bee <close>
  a = sbrk(PGSIZE);
    2baa:	6505                	lui	a0,0x1
    2bac:	00003097          	auipc	ra,0x3
    2bb0:	0a2080e7          	jalr	162(ra) # 5c4e <sbrk>
  if(pipe((int *) a) != 0){
    2bb4:	00003097          	auipc	ra,0x3
    2bb8:	022080e7          	jalr	34(ra) # 5bd6 <pipe>
    2bbc:	e521                	bnez	a0,2c04 <sbrkarg+0xbc>
}
    2bbe:	70a2                	ld	ra,40(sp)
    2bc0:	7402                	ld	s0,32(sp)
    2bc2:	64e2                	ld	s1,24(sp)
    2bc4:	6942                	ld	s2,16(sp)
    2bc6:	69a2                	ld	s3,8(sp)
    2bc8:	6145                	addi	sp,sp,48
    2bca:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2bcc:	85ce                	mv	a1,s3
    2bce:	00004517          	auipc	a0,0x4
    2bd2:	4fa50513          	addi	a0,a0,1274 # 70c8 <malloc+0x10bc>
    2bd6:	00003097          	auipc	ra,0x3
    2bda:	378080e7          	jalr	888(ra) # 5f4e <printf>
    exit(1);
    2bde:	4505                	li	a0,1
    2be0:	00003097          	auipc	ra,0x3
    2be4:	fe6080e7          	jalr	-26(ra) # 5bc6 <exit>
    printf("%s: write sbrk failed\n", s);
    2be8:	85ce                	mv	a1,s3
    2bea:	00004517          	auipc	a0,0x4
    2bee:	4f650513          	addi	a0,a0,1270 # 70e0 <malloc+0x10d4>
    2bf2:	00003097          	auipc	ra,0x3
    2bf6:	35c080e7          	jalr	860(ra) # 5f4e <printf>
    exit(1);
    2bfa:	4505                	li	a0,1
    2bfc:	00003097          	auipc	ra,0x3
    2c00:	fca080e7          	jalr	-54(ra) # 5bc6 <exit>
    printf("%s: pipe() failed\n", s);
    2c04:	85ce                	mv	a1,s3
    2c06:	00004517          	auipc	a0,0x4
    2c0a:	ed250513          	addi	a0,a0,-302 # 6ad8 <malloc+0xacc>
    2c0e:	00003097          	auipc	ra,0x3
    2c12:	340080e7          	jalr	832(ra) # 5f4e <printf>
    exit(1);
    2c16:	4505                	li	a0,1
    2c18:	00003097          	auipc	ra,0x3
    2c1c:	fae080e7          	jalr	-82(ra) # 5bc6 <exit>

0000000000002c20 <argptest>:
{
    2c20:	1101                	addi	sp,sp,-32
    2c22:	ec06                	sd	ra,24(sp)
    2c24:	e822                	sd	s0,16(sp)
    2c26:	e426                	sd	s1,8(sp)
    2c28:	e04a                	sd	s2,0(sp)
    2c2a:	1000                	addi	s0,sp,32
    2c2c:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2c2e:	4581                	li	a1,0
    2c30:	00004517          	auipc	a0,0x4
    2c34:	4c850513          	addi	a0,a0,1224 # 70f8 <malloc+0x10ec>
    2c38:	00003097          	auipc	ra,0x3
    2c3c:	fce080e7          	jalr	-50(ra) # 5c06 <open>
  if (fd < 0) {
    2c40:	02054b63          	bltz	a0,2c76 <argptest+0x56>
    2c44:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2c46:	4501                	li	a0,0
    2c48:	00003097          	auipc	ra,0x3
    2c4c:	006080e7          	jalr	6(ra) # 5c4e <sbrk>
    2c50:	567d                	li	a2,-1
    2c52:	fff50593          	addi	a1,a0,-1
    2c56:	8526                	mv	a0,s1
    2c58:	00003097          	auipc	ra,0x3
    2c5c:	f86080e7          	jalr	-122(ra) # 5bde <read>
  close(fd);
    2c60:	8526                	mv	a0,s1
    2c62:	00003097          	auipc	ra,0x3
    2c66:	f8c080e7          	jalr	-116(ra) # 5bee <close>
}
    2c6a:	60e2                	ld	ra,24(sp)
    2c6c:	6442                	ld	s0,16(sp)
    2c6e:	64a2                	ld	s1,8(sp)
    2c70:	6902                	ld	s2,0(sp)
    2c72:	6105                	addi	sp,sp,32
    2c74:	8082                	ret
    printf("%s: open failed\n", s);
    2c76:	85ca                	mv	a1,s2
    2c78:	00004517          	auipc	a0,0x4
    2c7c:	d7050513          	addi	a0,a0,-656 # 69e8 <malloc+0x9dc>
    2c80:	00003097          	auipc	ra,0x3
    2c84:	2ce080e7          	jalr	718(ra) # 5f4e <printf>
    exit(1);
    2c88:	4505                	li	a0,1
    2c8a:	00003097          	auipc	ra,0x3
    2c8e:	f3c080e7          	jalr	-196(ra) # 5bc6 <exit>

0000000000002c92 <sbrkbugs>:
{
    2c92:	1141                	addi	sp,sp,-16
    2c94:	e406                	sd	ra,8(sp)
    2c96:	e022                	sd	s0,0(sp)
    2c98:	0800                	addi	s0,sp,16
  int pid = fork();
    2c9a:	00003097          	auipc	ra,0x3
    2c9e:	f24080e7          	jalr	-220(ra) # 5bbe <fork>
  if(pid < 0){
    2ca2:	02054263          	bltz	a0,2cc6 <sbrkbugs+0x34>
  if(pid == 0){
    2ca6:	ed0d                	bnez	a0,2ce0 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2ca8:	00003097          	auipc	ra,0x3
    2cac:	fa6080e7          	jalr	-90(ra) # 5c4e <sbrk>
    sbrk(-sz);
    2cb0:	40a0053b          	negw	a0,a0
    2cb4:	00003097          	auipc	ra,0x3
    2cb8:	f9a080e7          	jalr	-102(ra) # 5c4e <sbrk>
    exit(0);
    2cbc:	4501                	li	a0,0
    2cbe:	00003097          	auipc	ra,0x3
    2cc2:	f08080e7          	jalr	-248(ra) # 5bc6 <exit>
    printf("fork failed\n");
    2cc6:	00004517          	auipc	a0,0x4
    2cca:	0fa50513          	addi	a0,a0,250 # 6dc0 <malloc+0xdb4>
    2cce:	00003097          	auipc	ra,0x3
    2cd2:	280080e7          	jalr	640(ra) # 5f4e <printf>
    exit(1);
    2cd6:	4505                	li	a0,1
    2cd8:	00003097          	auipc	ra,0x3
    2cdc:	eee080e7          	jalr	-274(ra) # 5bc6 <exit>
  wait(0);
    2ce0:	4501                	li	a0,0
    2ce2:	00003097          	auipc	ra,0x3
    2ce6:	eec080e7          	jalr	-276(ra) # 5bce <wait>
  pid = fork();
    2cea:	00003097          	auipc	ra,0x3
    2cee:	ed4080e7          	jalr	-300(ra) # 5bbe <fork>
  if(pid < 0){
    2cf2:	02054563          	bltz	a0,2d1c <sbrkbugs+0x8a>
  if(pid == 0){
    2cf6:	e121                	bnez	a0,2d36 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2cf8:	00003097          	auipc	ra,0x3
    2cfc:	f56080e7          	jalr	-170(ra) # 5c4e <sbrk>
    sbrk(-(sz - 3500));
    2d00:	6785                	lui	a5,0x1
    2d02:	dac7879b          	addiw	a5,a5,-596
    2d06:	40a7853b          	subw	a0,a5,a0
    2d0a:	00003097          	auipc	ra,0x3
    2d0e:	f44080e7          	jalr	-188(ra) # 5c4e <sbrk>
    exit(0);
    2d12:	4501                	li	a0,0
    2d14:	00003097          	auipc	ra,0x3
    2d18:	eb2080e7          	jalr	-334(ra) # 5bc6 <exit>
    printf("fork failed\n");
    2d1c:	00004517          	auipc	a0,0x4
    2d20:	0a450513          	addi	a0,a0,164 # 6dc0 <malloc+0xdb4>
    2d24:	00003097          	auipc	ra,0x3
    2d28:	22a080e7          	jalr	554(ra) # 5f4e <printf>
    exit(1);
    2d2c:	4505                	li	a0,1
    2d2e:	00003097          	auipc	ra,0x3
    2d32:	e98080e7          	jalr	-360(ra) # 5bc6 <exit>
  wait(0);
    2d36:	4501                	li	a0,0
    2d38:	00003097          	auipc	ra,0x3
    2d3c:	e96080e7          	jalr	-362(ra) # 5bce <wait>
  pid = fork();
    2d40:	00003097          	auipc	ra,0x3
    2d44:	e7e080e7          	jalr	-386(ra) # 5bbe <fork>
  if(pid < 0){
    2d48:	02054a63          	bltz	a0,2d7c <sbrkbugs+0xea>
  if(pid == 0){
    2d4c:	e529                	bnez	a0,2d96 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2d4e:	00003097          	auipc	ra,0x3
    2d52:	f00080e7          	jalr	-256(ra) # 5c4e <sbrk>
    2d56:	67ad                	lui	a5,0xb
    2d58:	8007879b          	addiw	a5,a5,-2048
    2d5c:	40a7853b          	subw	a0,a5,a0
    2d60:	00003097          	auipc	ra,0x3
    2d64:	eee080e7          	jalr	-274(ra) # 5c4e <sbrk>
    sbrk(-10);
    2d68:	5559                	li	a0,-10
    2d6a:	00003097          	auipc	ra,0x3
    2d6e:	ee4080e7          	jalr	-284(ra) # 5c4e <sbrk>
    exit(0);
    2d72:	4501                	li	a0,0
    2d74:	00003097          	auipc	ra,0x3
    2d78:	e52080e7          	jalr	-430(ra) # 5bc6 <exit>
    printf("fork failed\n");
    2d7c:	00004517          	auipc	a0,0x4
    2d80:	04450513          	addi	a0,a0,68 # 6dc0 <malloc+0xdb4>
    2d84:	00003097          	auipc	ra,0x3
    2d88:	1ca080e7          	jalr	458(ra) # 5f4e <printf>
    exit(1);
    2d8c:	4505                	li	a0,1
    2d8e:	00003097          	auipc	ra,0x3
    2d92:	e38080e7          	jalr	-456(ra) # 5bc6 <exit>
  wait(0);
    2d96:	4501                	li	a0,0
    2d98:	00003097          	auipc	ra,0x3
    2d9c:	e36080e7          	jalr	-458(ra) # 5bce <wait>
  exit(0);
    2da0:	4501                	li	a0,0
    2da2:	00003097          	auipc	ra,0x3
    2da6:	e24080e7          	jalr	-476(ra) # 5bc6 <exit>

0000000000002daa <sbrklast>:
{
    2daa:	7179                	addi	sp,sp,-48
    2dac:	f406                	sd	ra,40(sp)
    2dae:	f022                	sd	s0,32(sp)
    2db0:	ec26                	sd	s1,24(sp)
    2db2:	e84a                	sd	s2,16(sp)
    2db4:	e44e                	sd	s3,8(sp)
    2db6:	e052                	sd	s4,0(sp)
    2db8:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2dba:	4501                	li	a0,0
    2dbc:	00003097          	auipc	ra,0x3
    2dc0:	e92080e7          	jalr	-366(ra) # 5c4e <sbrk>
  if((top % 4096) != 0)
    2dc4:	03451793          	slli	a5,a0,0x34
    2dc8:	ebd9                	bnez	a5,2e5e <sbrklast+0xb4>
  sbrk(4096);
    2dca:	6505                	lui	a0,0x1
    2dcc:	00003097          	auipc	ra,0x3
    2dd0:	e82080e7          	jalr	-382(ra) # 5c4e <sbrk>
  sbrk(10);
    2dd4:	4529                	li	a0,10
    2dd6:	00003097          	auipc	ra,0x3
    2dda:	e78080e7          	jalr	-392(ra) # 5c4e <sbrk>
  sbrk(-20);
    2dde:	5531                	li	a0,-20
    2de0:	00003097          	auipc	ra,0x3
    2de4:	e6e080e7          	jalr	-402(ra) # 5c4e <sbrk>
  top = (uint64) sbrk(0);
    2de8:	4501                	li	a0,0
    2dea:	00003097          	auipc	ra,0x3
    2dee:	e64080e7          	jalr	-412(ra) # 5c4e <sbrk>
    2df2:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2df4:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0xca>
  p[0] = 'x';
    2df8:	07800a13          	li	s4,120
    2dfc:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2e00:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2e04:	20200593          	li	a1,514
    2e08:	854a                	mv	a0,s2
    2e0a:	00003097          	auipc	ra,0x3
    2e0e:	dfc080e7          	jalr	-516(ra) # 5c06 <open>
    2e12:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2e14:	4605                	li	a2,1
    2e16:	85ca                	mv	a1,s2
    2e18:	00003097          	auipc	ra,0x3
    2e1c:	dce080e7          	jalr	-562(ra) # 5be6 <write>
  close(fd);
    2e20:	854e                	mv	a0,s3
    2e22:	00003097          	auipc	ra,0x3
    2e26:	dcc080e7          	jalr	-564(ra) # 5bee <close>
  fd = open(p, O_RDWR);
    2e2a:	4589                	li	a1,2
    2e2c:	854a                	mv	a0,s2
    2e2e:	00003097          	auipc	ra,0x3
    2e32:	dd8080e7          	jalr	-552(ra) # 5c06 <open>
  p[0] = '\0';
    2e36:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2e3a:	4605                	li	a2,1
    2e3c:	85ca                	mv	a1,s2
    2e3e:	00003097          	auipc	ra,0x3
    2e42:	da0080e7          	jalr	-608(ra) # 5bde <read>
  if(p[0] != 'x')
    2e46:	fc04c783          	lbu	a5,-64(s1)
    2e4a:	03479463          	bne	a5,s4,2e72 <sbrklast+0xc8>
}
    2e4e:	70a2                	ld	ra,40(sp)
    2e50:	7402                	ld	s0,32(sp)
    2e52:	64e2                	ld	s1,24(sp)
    2e54:	6942                	ld	s2,16(sp)
    2e56:	69a2                	ld	s3,8(sp)
    2e58:	6a02                	ld	s4,0(sp)
    2e5a:	6145                	addi	sp,sp,48
    2e5c:	8082                	ret
    sbrk(4096 - (top % 4096));
    2e5e:	0347d513          	srli	a0,a5,0x34
    2e62:	6785                	lui	a5,0x1
    2e64:	40a7853b          	subw	a0,a5,a0
    2e68:	00003097          	auipc	ra,0x3
    2e6c:	de6080e7          	jalr	-538(ra) # 5c4e <sbrk>
    2e70:	bfa9                	j	2dca <sbrklast+0x20>
    exit(1);
    2e72:	4505                	li	a0,1
    2e74:	00003097          	auipc	ra,0x3
    2e78:	d52080e7          	jalr	-686(ra) # 5bc6 <exit>

0000000000002e7c <sbrk8000>:
{
    2e7c:	1141                	addi	sp,sp,-16
    2e7e:	e406                	sd	ra,8(sp)
    2e80:	e022                	sd	s0,0(sp)
    2e82:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2e84:	80000537          	lui	a0,0x80000
    2e88:	0511                	addi	a0,a0,4
    2e8a:	00003097          	auipc	ra,0x3
    2e8e:	dc4080e7          	jalr	-572(ra) # 5c4e <sbrk>
  volatile char *top = sbrk(0);
    2e92:	4501                	li	a0,0
    2e94:	00003097          	auipc	ra,0x3
    2e98:	dba080e7          	jalr	-582(ra) # 5c4e <sbrk>
  *(top-1) = *(top-1) + 1;
    2e9c:	fff54783          	lbu	a5,-1(a0) # ffffffff7fffffff <base+0xffffffff7fff03a7>
    2ea0:	0785                	addi	a5,a5,1
    2ea2:	0ff7f793          	andi	a5,a5,255
    2ea6:	fef50fa3          	sb	a5,-1(a0)
}
    2eaa:	60a2                	ld	ra,8(sp)
    2eac:	6402                	ld	s0,0(sp)
    2eae:	0141                	addi	sp,sp,16
    2eb0:	8082                	ret

0000000000002eb2 <fourteen>:
{
    2eb2:	1101                	addi	sp,sp,-32
    2eb4:	ec06                	sd	ra,24(sp)
    2eb6:	e822                	sd	s0,16(sp)
    2eb8:	e426                	sd	s1,8(sp)
    2eba:	1000                	addi	s0,sp,32
    2ebc:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2ebe:	00004517          	auipc	a0,0x4
    2ec2:	41250513          	addi	a0,a0,1042 # 72d0 <malloc+0x12c4>
    2ec6:	00003097          	auipc	ra,0x3
    2eca:	d68080e7          	jalr	-664(ra) # 5c2e <mkdir>
    2ece:	e165                	bnez	a0,2fae <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2ed0:	00004517          	auipc	a0,0x4
    2ed4:	25850513          	addi	a0,a0,600 # 7128 <malloc+0x111c>
    2ed8:	00003097          	auipc	ra,0x3
    2edc:	d56080e7          	jalr	-682(ra) # 5c2e <mkdir>
    2ee0:	e56d                	bnez	a0,2fca <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2ee2:	20000593          	li	a1,512
    2ee6:	00004517          	auipc	a0,0x4
    2eea:	29a50513          	addi	a0,a0,666 # 7180 <malloc+0x1174>
    2eee:	00003097          	auipc	ra,0x3
    2ef2:	d18080e7          	jalr	-744(ra) # 5c06 <open>
  if(fd < 0){
    2ef6:	0e054863          	bltz	a0,2fe6 <fourteen+0x134>
  close(fd);
    2efa:	00003097          	auipc	ra,0x3
    2efe:	cf4080e7          	jalr	-780(ra) # 5bee <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2f02:	4581                	li	a1,0
    2f04:	00004517          	auipc	a0,0x4
    2f08:	2f450513          	addi	a0,a0,756 # 71f8 <malloc+0x11ec>
    2f0c:	00003097          	auipc	ra,0x3
    2f10:	cfa080e7          	jalr	-774(ra) # 5c06 <open>
  if(fd < 0){
    2f14:	0e054763          	bltz	a0,3002 <fourteen+0x150>
  close(fd);
    2f18:	00003097          	auipc	ra,0x3
    2f1c:	cd6080e7          	jalr	-810(ra) # 5bee <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2f20:	00004517          	auipc	a0,0x4
    2f24:	34850513          	addi	a0,a0,840 # 7268 <malloc+0x125c>
    2f28:	00003097          	auipc	ra,0x3
    2f2c:	d06080e7          	jalr	-762(ra) # 5c2e <mkdir>
    2f30:	c57d                	beqz	a0,301e <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2f32:	00004517          	auipc	a0,0x4
    2f36:	38e50513          	addi	a0,a0,910 # 72c0 <malloc+0x12b4>
    2f3a:	00003097          	auipc	ra,0x3
    2f3e:	cf4080e7          	jalr	-780(ra) # 5c2e <mkdir>
    2f42:	cd65                	beqz	a0,303a <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2f44:	00004517          	auipc	a0,0x4
    2f48:	37c50513          	addi	a0,a0,892 # 72c0 <malloc+0x12b4>
    2f4c:	00003097          	auipc	ra,0x3
    2f50:	cca080e7          	jalr	-822(ra) # 5c16 <unlink>
  unlink("12345678901234/12345678901234");
    2f54:	00004517          	auipc	a0,0x4
    2f58:	31450513          	addi	a0,a0,788 # 7268 <malloc+0x125c>
    2f5c:	00003097          	auipc	ra,0x3
    2f60:	cba080e7          	jalr	-838(ra) # 5c16 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2f64:	00004517          	auipc	a0,0x4
    2f68:	29450513          	addi	a0,a0,660 # 71f8 <malloc+0x11ec>
    2f6c:	00003097          	auipc	ra,0x3
    2f70:	caa080e7          	jalr	-854(ra) # 5c16 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2f74:	00004517          	auipc	a0,0x4
    2f78:	20c50513          	addi	a0,a0,524 # 7180 <malloc+0x1174>
    2f7c:	00003097          	auipc	ra,0x3
    2f80:	c9a080e7          	jalr	-870(ra) # 5c16 <unlink>
  unlink("12345678901234/123456789012345");
    2f84:	00004517          	auipc	a0,0x4
    2f88:	1a450513          	addi	a0,a0,420 # 7128 <malloc+0x111c>
    2f8c:	00003097          	auipc	ra,0x3
    2f90:	c8a080e7          	jalr	-886(ra) # 5c16 <unlink>
  unlink("12345678901234");
    2f94:	00004517          	auipc	a0,0x4
    2f98:	33c50513          	addi	a0,a0,828 # 72d0 <malloc+0x12c4>
    2f9c:	00003097          	auipc	ra,0x3
    2fa0:	c7a080e7          	jalr	-902(ra) # 5c16 <unlink>
}
    2fa4:	60e2                	ld	ra,24(sp)
    2fa6:	6442                	ld	s0,16(sp)
    2fa8:	64a2                	ld	s1,8(sp)
    2faa:	6105                	addi	sp,sp,32
    2fac:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2fae:	85a6                	mv	a1,s1
    2fb0:	00004517          	auipc	a0,0x4
    2fb4:	15050513          	addi	a0,a0,336 # 7100 <malloc+0x10f4>
    2fb8:	00003097          	auipc	ra,0x3
    2fbc:	f96080e7          	jalr	-106(ra) # 5f4e <printf>
    exit(1);
    2fc0:	4505                	li	a0,1
    2fc2:	00003097          	auipc	ra,0x3
    2fc6:	c04080e7          	jalr	-1020(ra) # 5bc6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2fca:	85a6                	mv	a1,s1
    2fcc:	00004517          	auipc	a0,0x4
    2fd0:	17c50513          	addi	a0,a0,380 # 7148 <malloc+0x113c>
    2fd4:	00003097          	auipc	ra,0x3
    2fd8:	f7a080e7          	jalr	-134(ra) # 5f4e <printf>
    exit(1);
    2fdc:	4505                	li	a0,1
    2fde:	00003097          	auipc	ra,0x3
    2fe2:	be8080e7          	jalr	-1048(ra) # 5bc6 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2fe6:	85a6                	mv	a1,s1
    2fe8:	00004517          	auipc	a0,0x4
    2fec:	1c850513          	addi	a0,a0,456 # 71b0 <malloc+0x11a4>
    2ff0:	00003097          	auipc	ra,0x3
    2ff4:	f5e080e7          	jalr	-162(ra) # 5f4e <printf>
    exit(1);
    2ff8:	4505                	li	a0,1
    2ffa:	00003097          	auipc	ra,0x3
    2ffe:	bcc080e7          	jalr	-1076(ra) # 5bc6 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3002:	85a6                	mv	a1,s1
    3004:	00004517          	auipc	a0,0x4
    3008:	22450513          	addi	a0,a0,548 # 7228 <malloc+0x121c>
    300c:	00003097          	auipc	ra,0x3
    3010:	f42080e7          	jalr	-190(ra) # 5f4e <printf>
    exit(1);
    3014:	4505                	li	a0,1
    3016:	00003097          	auipc	ra,0x3
    301a:	bb0080e7          	jalr	-1104(ra) # 5bc6 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    301e:	85a6                	mv	a1,s1
    3020:	00004517          	auipc	a0,0x4
    3024:	26850513          	addi	a0,a0,616 # 7288 <malloc+0x127c>
    3028:	00003097          	auipc	ra,0x3
    302c:	f26080e7          	jalr	-218(ra) # 5f4e <printf>
    exit(1);
    3030:	4505                	li	a0,1
    3032:	00003097          	auipc	ra,0x3
    3036:	b94080e7          	jalr	-1132(ra) # 5bc6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    303a:	85a6                	mv	a1,s1
    303c:	00004517          	auipc	a0,0x4
    3040:	2a450513          	addi	a0,a0,676 # 72e0 <malloc+0x12d4>
    3044:	00003097          	auipc	ra,0x3
    3048:	f0a080e7          	jalr	-246(ra) # 5f4e <printf>
    exit(1);
    304c:	4505                	li	a0,1
    304e:	00003097          	auipc	ra,0x3
    3052:	b78080e7          	jalr	-1160(ra) # 5bc6 <exit>

0000000000003056 <diskfull>:
{
    3056:	b9010113          	addi	sp,sp,-1136
    305a:	46113423          	sd	ra,1128(sp)
    305e:	46813023          	sd	s0,1120(sp)
    3062:	44913c23          	sd	s1,1112(sp)
    3066:	45213823          	sd	s2,1104(sp)
    306a:	45313423          	sd	s3,1096(sp)
    306e:	45413023          	sd	s4,1088(sp)
    3072:	43513c23          	sd	s5,1080(sp)
    3076:	43613823          	sd	s6,1072(sp)
    307a:	43713423          	sd	s7,1064(sp)
    307e:	43813023          	sd	s8,1056(sp)
    3082:	47010413          	addi	s0,sp,1136
    3086:	8c2a                	mv	s8,a0
  unlink("diskfulldir");
    3088:	00004517          	auipc	a0,0x4
    308c:	29050513          	addi	a0,a0,656 # 7318 <malloc+0x130c>
    3090:	00003097          	auipc	ra,0x3
    3094:	b86080e7          	jalr	-1146(ra) # 5c16 <unlink>
  for(fi = 0; done == 0; fi++){
    3098:	4a01                	li	s4,0
    name[0] = 'b';
    309a:	06200b13          	li	s6,98
    name[1] = 'i';
    309e:	06900a93          	li	s5,105
    name[2] = 'g';
    30a2:	06700993          	li	s3,103
    30a6:	10c00b93          	li	s7,268
    30aa:	aabd                	j	3228 <diskfull+0x1d2>
      printf("%s: could not create file %s\n", s, name);
    30ac:	b9040613          	addi	a2,s0,-1136
    30b0:	85e2                	mv	a1,s8
    30b2:	00004517          	auipc	a0,0x4
    30b6:	27650513          	addi	a0,a0,630 # 7328 <malloc+0x131c>
    30ba:	00003097          	auipc	ra,0x3
    30be:	e94080e7          	jalr	-364(ra) # 5f4e <printf>
      break;
    30c2:	a821                	j	30da <diskfull+0x84>
        close(fd);
    30c4:	854a                	mv	a0,s2
    30c6:	00003097          	auipc	ra,0x3
    30ca:	b28080e7          	jalr	-1240(ra) # 5bee <close>
    close(fd);
    30ce:	854a                	mv	a0,s2
    30d0:	00003097          	auipc	ra,0x3
    30d4:	b1e080e7          	jalr	-1250(ra) # 5bee <close>
  for(fi = 0; done == 0; fi++){
    30d8:	2a05                	addiw	s4,s4,1
  for(int i = 0; i < nzz; i++){
    30da:	4481                	li	s1,0
    name[0] = 'z';
    30dc:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    30e0:	08000993          	li	s3,128
    name[0] = 'z';
    30e4:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    30e8:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    30ec:	41f4d79b          	sraiw	a5,s1,0x1f
    30f0:	01b7d71b          	srliw	a4,a5,0x1b
    30f4:	009707bb          	addw	a5,a4,s1
    30f8:	4057d69b          	sraiw	a3,a5,0x5
    30fc:	0306869b          	addiw	a3,a3,48
    3100:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3104:	8bfd                	andi	a5,a5,31
    3106:	9f99                	subw	a5,a5,a4
    3108:	0307879b          	addiw	a5,a5,48
    310c:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3110:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3114:	bb040513          	addi	a0,s0,-1104
    3118:	00003097          	auipc	ra,0x3
    311c:	afe080e7          	jalr	-1282(ra) # 5c16 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3120:	60200593          	li	a1,1538
    3124:	bb040513          	addi	a0,s0,-1104
    3128:	00003097          	auipc	ra,0x3
    312c:	ade080e7          	jalr	-1314(ra) # 5c06 <open>
    if(fd < 0)
    3130:	00054963          	bltz	a0,3142 <diskfull+0xec>
    close(fd);
    3134:	00003097          	auipc	ra,0x3
    3138:	aba080e7          	jalr	-1350(ra) # 5bee <close>
  for(int i = 0; i < nzz; i++){
    313c:	2485                	addiw	s1,s1,1
    313e:	fb3493e3          	bne	s1,s3,30e4 <diskfull+0x8e>
  if(mkdir("diskfulldir") == 0)
    3142:	00004517          	auipc	a0,0x4
    3146:	1d650513          	addi	a0,a0,470 # 7318 <malloc+0x130c>
    314a:	00003097          	auipc	ra,0x3
    314e:	ae4080e7          	jalr	-1308(ra) # 5c2e <mkdir>
    3152:	12050963          	beqz	a0,3284 <diskfull+0x22e>
  unlink("diskfulldir");
    3156:	00004517          	auipc	a0,0x4
    315a:	1c250513          	addi	a0,a0,450 # 7318 <malloc+0x130c>
    315e:	00003097          	auipc	ra,0x3
    3162:	ab8080e7          	jalr	-1352(ra) # 5c16 <unlink>
  for(int i = 0; i < nzz; i++){
    3166:	4481                	li	s1,0
    name[0] = 'z';
    3168:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    316c:	08000993          	li	s3,128
    name[0] = 'z';
    3170:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    3174:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    3178:	41f4d79b          	sraiw	a5,s1,0x1f
    317c:	01b7d71b          	srliw	a4,a5,0x1b
    3180:	009707bb          	addw	a5,a4,s1
    3184:	4057d69b          	sraiw	a3,a5,0x5
    3188:	0306869b          	addiw	a3,a3,48
    318c:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3190:	8bfd                	andi	a5,a5,31
    3192:	9f99                	subw	a5,a5,a4
    3194:	0307879b          	addiw	a5,a5,48
    3198:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    319c:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    31a0:	bb040513          	addi	a0,s0,-1104
    31a4:	00003097          	auipc	ra,0x3
    31a8:	a72080e7          	jalr	-1422(ra) # 5c16 <unlink>
  for(int i = 0; i < nzz; i++){
    31ac:	2485                	addiw	s1,s1,1
    31ae:	fd3491e3          	bne	s1,s3,3170 <diskfull+0x11a>
  for(int i = 0; i < fi; i++){
    31b2:	03405e63          	blez	s4,31ee <diskfull+0x198>
    31b6:	4481                	li	s1,0
    name[0] = 'b';
    31b8:	06200a93          	li	s5,98
    name[1] = 'i';
    31bc:	06900993          	li	s3,105
    name[2] = 'g';
    31c0:	06700913          	li	s2,103
    name[0] = 'b';
    31c4:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    31c8:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    31cc:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    31d0:	0304879b          	addiw	a5,s1,48
    31d4:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    31d8:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    31dc:	bb040513          	addi	a0,s0,-1104
    31e0:	00003097          	auipc	ra,0x3
    31e4:	a36080e7          	jalr	-1482(ra) # 5c16 <unlink>
  for(int i = 0; i < fi; i++){
    31e8:	2485                	addiw	s1,s1,1
    31ea:	fd449de3          	bne	s1,s4,31c4 <diskfull+0x16e>
}
    31ee:	46813083          	ld	ra,1128(sp)
    31f2:	46013403          	ld	s0,1120(sp)
    31f6:	45813483          	ld	s1,1112(sp)
    31fa:	45013903          	ld	s2,1104(sp)
    31fe:	44813983          	ld	s3,1096(sp)
    3202:	44013a03          	ld	s4,1088(sp)
    3206:	43813a83          	ld	s5,1080(sp)
    320a:	43013b03          	ld	s6,1072(sp)
    320e:	42813b83          	ld	s7,1064(sp)
    3212:	42013c03          	ld	s8,1056(sp)
    3216:	47010113          	addi	sp,sp,1136
    321a:	8082                	ret
    close(fd);
    321c:	854a                	mv	a0,s2
    321e:	00003097          	auipc	ra,0x3
    3222:	9d0080e7          	jalr	-1584(ra) # 5bee <close>
  for(fi = 0; done == 0; fi++){
    3226:	2a05                	addiw	s4,s4,1
    name[0] = 'b';
    3228:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    322c:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    3230:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + fi;
    3234:	030a079b          	addiw	a5,s4,48
    3238:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    323c:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    3240:	b9040513          	addi	a0,s0,-1136
    3244:	00003097          	auipc	ra,0x3
    3248:	9d2080e7          	jalr	-1582(ra) # 5c16 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    324c:	60200593          	li	a1,1538
    3250:	b9040513          	addi	a0,s0,-1136
    3254:	00003097          	auipc	ra,0x3
    3258:	9b2080e7          	jalr	-1614(ra) # 5c06 <open>
    325c:	892a                	mv	s2,a0
    if(fd < 0){
    325e:	e40547e3          	bltz	a0,30ac <diskfull+0x56>
    3262:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    3264:	40000613          	li	a2,1024
    3268:	bb040593          	addi	a1,s0,-1104
    326c:	854a                	mv	a0,s2
    326e:	00003097          	auipc	ra,0x3
    3272:	978080e7          	jalr	-1672(ra) # 5be6 <write>
    3276:	40000793          	li	a5,1024
    327a:	e4f515e3          	bne	a0,a5,30c4 <diskfull+0x6e>
    for(int i = 0; i < MAXFILE; i++){
    327e:	34fd                	addiw	s1,s1,-1
    3280:	f0f5                	bnez	s1,3264 <diskfull+0x20e>
    3282:	bf69                	j	321c <diskfull+0x1c6>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    3284:	00004517          	auipc	a0,0x4
    3288:	0c450513          	addi	a0,a0,196 # 7348 <malloc+0x133c>
    328c:	00003097          	auipc	ra,0x3
    3290:	cc2080e7          	jalr	-830(ra) # 5f4e <printf>
    3294:	b5c9                	j	3156 <diskfull+0x100>

0000000000003296 <iputtest>:
{
    3296:	1101                	addi	sp,sp,-32
    3298:	ec06                	sd	ra,24(sp)
    329a:	e822                	sd	s0,16(sp)
    329c:	e426                	sd	s1,8(sp)
    329e:	1000                	addi	s0,sp,32
    32a0:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    32a2:	00004517          	auipc	a0,0x4
    32a6:	0d650513          	addi	a0,a0,214 # 7378 <malloc+0x136c>
    32aa:	00003097          	auipc	ra,0x3
    32ae:	984080e7          	jalr	-1660(ra) # 5c2e <mkdir>
    32b2:	04054563          	bltz	a0,32fc <iputtest+0x66>
  if(chdir("iputdir") < 0){
    32b6:	00004517          	auipc	a0,0x4
    32ba:	0c250513          	addi	a0,a0,194 # 7378 <malloc+0x136c>
    32be:	00003097          	auipc	ra,0x3
    32c2:	978080e7          	jalr	-1672(ra) # 5c36 <chdir>
    32c6:	04054963          	bltz	a0,3318 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    32ca:	00004517          	auipc	a0,0x4
    32ce:	0ee50513          	addi	a0,a0,238 # 73b8 <malloc+0x13ac>
    32d2:	00003097          	auipc	ra,0x3
    32d6:	944080e7          	jalr	-1724(ra) # 5c16 <unlink>
    32da:	04054d63          	bltz	a0,3334 <iputtest+0x9e>
  if(chdir("/") < 0){
    32de:	00004517          	auipc	a0,0x4
    32e2:	10a50513          	addi	a0,a0,266 # 73e8 <malloc+0x13dc>
    32e6:	00003097          	auipc	ra,0x3
    32ea:	950080e7          	jalr	-1712(ra) # 5c36 <chdir>
    32ee:	06054163          	bltz	a0,3350 <iputtest+0xba>
}
    32f2:	60e2                	ld	ra,24(sp)
    32f4:	6442                	ld	s0,16(sp)
    32f6:	64a2                	ld	s1,8(sp)
    32f8:	6105                	addi	sp,sp,32
    32fa:	8082                	ret
    printf("%s: mkdir failed\n", s);
    32fc:	85a6                	mv	a1,s1
    32fe:	00004517          	auipc	a0,0x4
    3302:	08250513          	addi	a0,a0,130 # 7380 <malloc+0x1374>
    3306:	00003097          	auipc	ra,0x3
    330a:	c48080e7          	jalr	-952(ra) # 5f4e <printf>
    exit(1);
    330e:	4505                	li	a0,1
    3310:	00003097          	auipc	ra,0x3
    3314:	8b6080e7          	jalr	-1866(ra) # 5bc6 <exit>
    printf("%s: chdir iputdir failed\n", s);
    3318:	85a6                	mv	a1,s1
    331a:	00004517          	auipc	a0,0x4
    331e:	07e50513          	addi	a0,a0,126 # 7398 <malloc+0x138c>
    3322:	00003097          	auipc	ra,0x3
    3326:	c2c080e7          	jalr	-980(ra) # 5f4e <printf>
    exit(1);
    332a:	4505                	li	a0,1
    332c:	00003097          	auipc	ra,0x3
    3330:	89a080e7          	jalr	-1894(ra) # 5bc6 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3334:	85a6                	mv	a1,s1
    3336:	00004517          	auipc	a0,0x4
    333a:	09250513          	addi	a0,a0,146 # 73c8 <malloc+0x13bc>
    333e:	00003097          	auipc	ra,0x3
    3342:	c10080e7          	jalr	-1008(ra) # 5f4e <printf>
    exit(1);
    3346:	4505                	li	a0,1
    3348:	00003097          	auipc	ra,0x3
    334c:	87e080e7          	jalr	-1922(ra) # 5bc6 <exit>
    printf("%s: chdir / failed\n", s);
    3350:	85a6                	mv	a1,s1
    3352:	00004517          	auipc	a0,0x4
    3356:	09e50513          	addi	a0,a0,158 # 73f0 <malloc+0x13e4>
    335a:	00003097          	auipc	ra,0x3
    335e:	bf4080e7          	jalr	-1036(ra) # 5f4e <printf>
    exit(1);
    3362:	4505                	li	a0,1
    3364:	00003097          	auipc	ra,0x3
    3368:	862080e7          	jalr	-1950(ra) # 5bc6 <exit>

000000000000336c <exitiputtest>:
{
    336c:	7179                	addi	sp,sp,-48
    336e:	f406                	sd	ra,40(sp)
    3370:	f022                	sd	s0,32(sp)
    3372:	ec26                	sd	s1,24(sp)
    3374:	1800                	addi	s0,sp,48
    3376:	84aa                	mv	s1,a0
  pid = fork();
    3378:	00003097          	auipc	ra,0x3
    337c:	846080e7          	jalr	-1978(ra) # 5bbe <fork>
  if(pid < 0){
    3380:	04054663          	bltz	a0,33cc <exitiputtest+0x60>
  if(pid == 0){
    3384:	ed45                	bnez	a0,343c <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    3386:	00004517          	auipc	a0,0x4
    338a:	ff250513          	addi	a0,a0,-14 # 7378 <malloc+0x136c>
    338e:	00003097          	auipc	ra,0x3
    3392:	8a0080e7          	jalr	-1888(ra) # 5c2e <mkdir>
    3396:	04054963          	bltz	a0,33e8 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    339a:	00004517          	auipc	a0,0x4
    339e:	fde50513          	addi	a0,a0,-34 # 7378 <malloc+0x136c>
    33a2:	00003097          	auipc	ra,0x3
    33a6:	894080e7          	jalr	-1900(ra) # 5c36 <chdir>
    33aa:	04054d63          	bltz	a0,3404 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    33ae:	00004517          	auipc	a0,0x4
    33b2:	00a50513          	addi	a0,a0,10 # 73b8 <malloc+0x13ac>
    33b6:	00003097          	auipc	ra,0x3
    33ba:	860080e7          	jalr	-1952(ra) # 5c16 <unlink>
    33be:	06054163          	bltz	a0,3420 <exitiputtest+0xb4>
    exit(0);
    33c2:	4501                	li	a0,0
    33c4:	00003097          	auipc	ra,0x3
    33c8:	802080e7          	jalr	-2046(ra) # 5bc6 <exit>
    printf("%s: fork failed\n", s);
    33cc:	85a6                	mv	a1,s1
    33ce:	00003517          	auipc	a0,0x3
    33d2:	60250513          	addi	a0,a0,1538 # 69d0 <malloc+0x9c4>
    33d6:	00003097          	auipc	ra,0x3
    33da:	b78080e7          	jalr	-1160(ra) # 5f4e <printf>
    exit(1);
    33de:	4505                	li	a0,1
    33e0:	00002097          	auipc	ra,0x2
    33e4:	7e6080e7          	jalr	2022(ra) # 5bc6 <exit>
      printf("%s: mkdir failed\n", s);
    33e8:	85a6                	mv	a1,s1
    33ea:	00004517          	auipc	a0,0x4
    33ee:	f9650513          	addi	a0,a0,-106 # 7380 <malloc+0x1374>
    33f2:	00003097          	auipc	ra,0x3
    33f6:	b5c080e7          	jalr	-1188(ra) # 5f4e <printf>
      exit(1);
    33fa:	4505                	li	a0,1
    33fc:	00002097          	auipc	ra,0x2
    3400:	7ca080e7          	jalr	1994(ra) # 5bc6 <exit>
      printf("%s: child chdir failed\n", s);
    3404:	85a6                	mv	a1,s1
    3406:	00004517          	auipc	a0,0x4
    340a:	00250513          	addi	a0,a0,2 # 7408 <malloc+0x13fc>
    340e:	00003097          	auipc	ra,0x3
    3412:	b40080e7          	jalr	-1216(ra) # 5f4e <printf>
      exit(1);
    3416:	4505                	li	a0,1
    3418:	00002097          	auipc	ra,0x2
    341c:	7ae080e7          	jalr	1966(ra) # 5bc6 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    3420:	85a6                	mv	a1,s1
    3422:	00004517          	auipc	a0,0x4
    3426:	fa650513          	addi	a0,a0,-90 # 73c8 <malloc+0x13bc>
    342a:	00003097          	auipc	ra,0x3
    342e:	b24080e7          	jalr	-1244(ra) # 5f4e <printf>
      exit(1);
    3432:	4505                	li	a0,1
    3434:	00002097          	auipc	ra,0x2
    3438:	792080e7          	jalr	1938(ra) # 5bc6 <exit>
  wait(&xstatus);
    343c:	fdc40513          	addi	a0,s0,-36
    3440:	00002097          	auipc	ra,0x2
    3444:	78e080e7          	jalr	1934(ra) # 5bce <wait>
  exit(xstatus);
    3448:	fdc42503          	lw	a0,-36(s0)
    344c:	00002097          	auipc	ra,0x2
    3450:	77a080e7          	jalr	1914(ra) # 5bc6 <exit>

0000000000003454 <dirtest>:
{
    3454:	1101                	addi	sp,sp,-32
    3456:	ec06                	sd	ra,24(sp)
    3458:	e822                	sd	s0,16(sp)
    345a:	e426                	sd	s1,8(sp)
    345c:	1000                	addi	s0,sp,32
    345e:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    3460:	00004517          	auipc	a0,0x4
    3464:	fc050513          	addi	a0,a0,-64 # 7420 <malloc+0x1414>
    3468:	00002097          	auipc	ra,0x2
    346c:	7c6080e7          	jalr	1990(ra) # 5c2e <mkdir>
    3470:	04054563          	bltz	a0,34ba <dirtest+0x66>
  if(chdir("dir0") < 0){
    3474:	00004517          	auipc	a0,0x4
    3478:	fac50513          	addi	a0,a0,-84 # 7420 <malloc+0x1414>
    347c:	00002097          	auipc	ra,0x2
    3480:	7ba080e7          	jalr	1978(ra) # 5c36 <chdir>
    3484:	04054963          	bltz	a0,34d6 <dirtest+0x82>
  if(chdir("..") < 0){
    3488:	00004517          	auipc	a0,0x4
    348c:	fb850513          	addi	a0,a0,-72 # 7440 <malloc+0x1434>
    3490:	00002097          	auipc	ra,0x2
    3494:	7a6080e7          	jalr	1958(ra) # 5c36 <chdir>
    3498:	04054d63          	bltz	a0,34f2 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    349c:	00004517          	auipc	a0,0x4
    34a0:	f8450513          	addi	a0,a0,-124 # 7420 <malloc+0x1414>
    34a4:	00002097          	auipc	ra,0x2
    34a8:	772080e7          	jalr	1906(ra) # 5c16 <unlink>
    34ac:	06054163          	bltz	a0,350e <dirtest+0xba>
}
    34b0:	60e2                	ld	ra,24(sp)
    34b2:	6442                	ld	s0,16(sp)
    34b4:	64a2                	ld	s1,8(sp)
    34b6:	6105                	addi	sp,sp,32
    34b8:	8082                	ret
    printf("%s: mkdir failed\n", s);
    34ba:	85a6                	mv	a1,s1
    34bc:	00004517          	auipc	a0,0x4
    34c0:	ec450513          	addi	a0,a0,-316 # 7380 <malloc+0x1374>
    34c4:	00003097          	auipc	ra,0x3
    34c8:	a8a080e7          	jalr	-1398(ra) # 5f4e <printf>
    exit(1);
    34cc:	4505                	li	a0,1
    34ce:	00002097          	auipc	ra,0x2
    34d2:	6f8080e7          	jalr	1784(ra) # 5bc6 <exit>
    printf("%s: chdir dir0 failed\n", s);
    34d6:	85a6                	mv	a1,s1
    34d8:	00004517          	auipc	a0,0x4
    34dc:	f5050513          	addi	a0,a0,-176 # 7428 <malloc+0x141c>
    34e0:	00003097          	auipc	ra,0x3
    34e4:	a6e080e7          	jalr	-1426(ra) # 5f4e <printf>
    exit(1);
    34e8:	4505                	li	a0,1
    34ea:	00002097          	auipc	ra,0x2
    34ee:	6dc080e7          	jalr	1756(ra) # 5bc6 <exit>
    printf("%s: chdir .. failed\n", s);
    34f2:	85a6                	mv	a1,s1
    34f4:	00004517          	auipc	a0,0x4
    34f8:	f5450513          	addi	a0,a0,-172 # 7448 <malloc+0x143c>
    34fc:	00003097          	auipc	ra,0x3
    3500:	a52080e7          	jalr	-1454(ra) # 5f4e <printf>
    exit(1);
    3504:	4505                	li	a0,1
    3506:	00002097          	auipc	ra,0x2
    350a:	6c0080e7          	jalr	1728(ra) # 5bc6 <exit>
    printf("%s: unlink dir0 failed\n", s);
    350e:	85a6                	mv	a1,s1
    3510:	00004517          	auipc	a0,0x4
    3514:	f5050513          	addi	a0,a0,-176 # 7460 <malloc+0x1454>
    3518:	00003097          	auipc	ra,0x3
    351c:	a36080e7          	jalr	-1482(ra) # 5f4e <printf>
    exit(1);
    3520:	4505                	li	a0,1
    3522:	00002097          	auipc	ra,0x2
    3526:	6a4080e7          	jalr	1700(ra) # 5bc6 <exit>

000000000000352a <subdir>:
{
    352a:	1101                	addi	sp,sp,-32
    352c:	ec06                	sd	ra,24(sp)
    352e:	e822                	sd	s0,16(sp)
    3530:	e426                	sd	s1,8(sp)
    3532:	e04a                	sd	s2,0(sp)
    3534:	1000                	addi	s0,sp,32
    3536:	892a                	mv	s2,a0
  unlink("ff");
    3538:	00004517          	auipc	a0,0x4
    353c:	07050513          	addi	a0,a0,112 # 75a8 <malloc+0x159c>
    3540:	00002097          	auipc	ra,0x2
    3544:	6d6080e7          	jalr	1750(ra) # 5c16 <unlink>
  if(mkdir("dd") != 0){
    3548:	00004517          	auipc	a0,0x4
    354c:	f3050513          	addi	a0,a0,-208 # 7478 <malloc+0x146c>
    3550:	00002097          	auipc	ra,0x2
    3554:	6de080e7          	jalr	1758(ra) # 5c2e <mkdir>
    3558:	38051663          	bnez	a0,38e4 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    355c:	20200593          	li	a1,514
    3560:	00004517          	auipc	a0,0x4
    3564:	f3850513          	addi	a0,a0,-200 # 7498 <malloc+0x148c>
    3568:	00002097          	auipc	ra,0x2
    356c:	69e080e7          	jalr	1694(ra) # 5c06 <open>
    3570:	84aa                	mv	s1,a0
  if(fd < 0){
    3572:	38054763          	bltz	a0,3900 <subdir+0x3d6>
  write(fd, "ff", 2);
    3576:	4609                	li	a2,2
    3578:	00004597          	auipc	a1,0x4
    357c:	03058593          	addi	a1,a1,48 # 75a8 <malloc+0x159c>
    3580:	00002097          	auipc	ra,0x2
    3584:	666080e7          	jalr	1638(ra) # 5be6 <write>
  close(fd);
    3588:	8526                	mv	a0,s1
    358a:	00002097          	auipc	ra,0x2
    358e:	664080e7          	jalr	1636(ra) # 5bee <close>
  if(unlink("dd") >= 0){
    3592:	00004517          	auipc	a0,0x4
    3596:	ee650513          	addi	a0,a0,-282 # 7478 <malloc+0x146c>
    359a:	00002097          	auipc	ra,0x2
    359e:	67c080e7          	jalr	1660(ra) # 5c16 <unlink>
    35a2:	36055d63          	bgez	a0,391c <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    35a6:	00004517          	auipc	a0,0x4
    35aa:	f4a50513          	addi	a0,a0,-182 # 74f0 <malloc+0x14e4>
    35ae:	00002097          	auipc	ra,0x2
    35b2:	680080e7          	jalr	1664(ra) # 5c2e <mkdir>
    35b6:	38051163          	bnez	a0,3938 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    35ba:	20200593          	li	a1,514
    35be:	00004517          	auipc	a0,0x4
    35c2:	f5a50513          	addi	a0,a0,-166 # 7518 <malloc+0x150c>
    35c6:	00002097          	auipc	ra,0x2
    35ca:	640080e7          	jalr	1600(ra) # 5c06 <open>
    35ce:	84aa                	mv	s1,a0
  if(fd < 0){
    35d0:	38054263          	bltz	a0,3954 <subdir+0x42a>
  write(fd, "FF", 2);
    35d4:	4609                	li	a2,2
    35d6:	00004597          	auipc	a1,0x4
    35da:	f7258593          	addi	a1,a1,-142 # 7548 <malloc+0x153c>
    35de:	00002097          	auipc	ra,0x2
    35e2:	608080e7          	jalr	1544(ra) # 5be6 <write>
  close(fd);
    35e6:	8526                	mv	a0,s1
    35e8:	00002097          	auipc	ra,0x2
    35ec:	606080e7          	jalr	1542(ra) # 5bee <close>
  fd = open("dd/dd/../ff", 0);
    35f0:	4581                	li	a1,0
    35f2:	00004517          	auipc	a0,0x4
    35f6:	f5e50513          	addi	a0,a0,-162 # 7550 <malloc+0x1544>
    35fa:	00002097          	auipc	ra,0x2
    35fe:	60c080e7          	jalr	1548(ra) # 5c06 <open>
    3602:	84aa                	mv	s1,a0
  if(fd < 0){
    3604:	36054663          	bltz	a0,3970 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3608:	660d                	lui	a2,0x3
    360a:	00009597          	auipc	a1,0x9
    360e:	64e58593          	addi	a1,a1,1614 # cc58 <buf>
    3612:	00002097          	auipc	ra,0x2
    3616:	5cc080e7          	jalr	1484(ra) # 5bde <read>
  if(cc != 2 || buf[0] != 'f'){
    361a:	4789                	li	a5,2
    361c:	36f51863          	bne	a0,a5,398c <subdir+0x462>
    3620:	00009717          	auipc	a4,0x9
    3624:	63874703          	lbu	a4,1592(a4) # cc58 <buf>
    3628:	06600793          	li	a5,102
    362c:	36f71063          	bne	a4,a5,398c <subdir+0x462>
  close(fd);
    3630:	8526                	mv	a0,s1
    3632:	00002097          	auipc	ra,0x2
    3636:	5bc080e7          	jalr	1468(ra) # 5bee <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    363a:	00004597          	auipc	a1,0x4
    363e:	f6658593          	addi	a1,a1,-154 # 75a0 <malloc+0x1594>
    3642:	00004517          	auipc	a0,0x4
    3646:	ed650513          	addi	a0,a0,-298 # 7518 <malloc+0x150c>
    364a:	00002097          	auipc	ra,0x2
    364e:	5dc080e7          	jalr	1500(ra) # 5c26 <link>
    3652:	34051b63          	bnez	a0,39a8 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3656:	00004517          	auipc	a0,0x4
    365a:	ec250513          	addi	a0,a0,-318 # 7518 <malloc+0x150c>
    365e:	00002097          	auipc	ra,0x2
    3662:	5b8080e7          	jalr	1464(ra) # 5c16 <unlink>
    3666:	34051f63          	bnez	a0,39c4 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    366a:	4581                	li	a1,0
    366c:	00004517          	auipc	a0,0x4
    3670:	eac50513          	addi	a0,a0,-340 # 7518 <malloc+0x150c>
    3674:	00002097          	auipc	ra,0x2
    3678:	592080e7          	jalr	1426(ra) # 5c06 <open>
    367c:	36055263          	bgez	a0,39e0 <subdir+0x4b6>
  if(chdir("dd") != 0){
    3680:	00004517          	auipc	a0,0x4
    3684:	df850513          	addi	a0,a0,-520 # 7478 <malloc+0x146c>
    3688:	00002097          	auipc	ra,0x2
    368c:	5ae080e7          	jalr	1454(ra) # 5c36 <chdir>
    3690:	36051663          	bnez	a0,39fc <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    3694:	00004517          	auipc	a0,0x4
    3698:	fa450513          	addi	a0,a0,-92 # 7638 <malloc+0x162c>
    369c:	00002097          	auipc	ra,0x2
    36a0:	59a080e7          	jalr	1434(ra) # 5c36 <chdir>
    36a4:	36051a63          	bnez	a0,3a18 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    36a8:	00004517          	auipc	a0,0x4
    36ac:	fc050513          	addi	a0,a0,-64 # 7668 <malloc+0x165c>
    36b0:	00002097          	auipc	ra,0x2
    36b4:	586080e7          	jalr	1414(ra) # 5c36 <chdir>
    36b8:	36051e63          	bnez	a0,3a34 <subdir+0x50a>
  if(chdir("./..") != 0){
    36bc:	00004517          	auipc	a0,0x4
    36c0:	fdc50513          	addi	a0,a0,-36 # 7698 <malloc+0x168c>
    36c4:	00002097          	auipc	ra,0x2
    36c8:	572080e7          	jalr	1394(ra) # 5c36 <chdir>
    36cc:	38051263          	bnez	a0,3a50 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    36d0:	4581                	li	a1,0
    36d2:	00004517          	auipc	a0,0x4
    36d6:	ece50513          	addi	a0,a0,-306 # 75a0 <malloc+0x1594>
    36da:	00002097          	auipc	ra,0x2
    36de:	52c080e7          	jalr	1324(ra) # 5c06 <open>
    36e2:	84aa                	mv	s1,a0
  if(fd < 0){
    36e4:	38054463          	bltz	a0,3a6c <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    36e8:	660d                	lui	a2,0x3
    36ea:	00009597          	auipc	a1,0x9
    36ee:	56e58593          	addi	a1,a1,1390 # cc58 <buf>
    36f2:	00002097          	auipc	ra,0x2
    36f6:	4ec080e7          	jalr	1260(ra) # 5bde <read>
    36fa:	4789                	li	a5,2
    36fc:	38f51663          	bne	a0,a5,3a88 <subdir+0x55e>
  close(fd);
    3700:	8526                	mv	a0,s1
    3702:	00002097          	auipc	ra,0x2
    3706:	4ec080e7          	jalr	1260(ra) # 5bee <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    370a:	4581                	li	a1,0
    370c:	00004517          	auipc	a0,0x4
    3710:	e0c50513          	addi	a0,a0,-500 # 7518 <malloc+0x150c>
    3714:	00002097          	auipc	ra,0x2
    3718:	4f2080e7          	jalr	1266(ra) # 5c06 <open>
    371c:	38055463          	bgez	a0,3aa4 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3720:	20200593          	li	a1,514
    3724:	00004517          	auipc	a0,0x4
    3728:	00450513          	addi	a0,a0,4 # 7728 <malloc+0x171c>
    372c:	00002097          	auipc	ra,0x2
    3730:	4da080e7          	jalr	1242(ra) # 5c06 <open>
    3734:	38055663          	bgez	a0,3ac0 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3738:	20200593          	li	a1,514
    373c:	00004517          	auipc	a0,0x4
    3740:	01c50513          	addi	a0,a0,28 # 7758 <malloc+0x174c>
    3744:	00002097          	auipc	ra,0x2
    3748:	4c2080e7          	jalr	1218(ra) # 5c06 <open>
    374c:	38055863          	bgez	a0,3adc <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    3750:	20000593          	li	a1,512
    3754:	00004517          	auipc	a0,0x4
    3758:	d2450513          	addi	a0,a0,-732 # 7478 <malloc+0x146c>
    375c:	00002097          	auipc	ra,0x2
    3760:	4aa080e7          	jalr	1194(ra) # 5c06 <open>
    3764:	38055a63          	bgez	a0,3af8 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3768:	4589                	li	a1,2
    376a:	00004517          	auipc	a0,0x4
    376e:	d0e50513          	addi	a0,a0,-754 # 7478 <malloc+0x146c>
    3772:	00002097          	auipc	ra,0x2
    3776:	494080e7          	jalr	1172(ra) # 5c06 <open>
    377a:	38055d63          	bgez	a0,3b14 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    377e:	4585                	li	a1,1
    3780:	00004517          	auipc	a0,0x4
    3784:	cf850513          	addi	a0,a0,-776 # 7478 <malloc+0x146c>
    3788:	00002097          	auipc	ra,0x2
    378c:	47e080e7          	jalr	1150(ra) # 5c06 <open>
    3790:	3a055063          	bgez	a0,3b30 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3794:	00004597          	auipc	a1,0x4
    3798:	05458593          	addi	a1,a1,84 # 77e8 <malloc+0x17dc>
    379c:	00004517          	auipc	a0,0x4
    37a0:	f8c50513          	addi	a0,a0,-116 # 7728 <malloc+0x171c>
    37a4:	00002097          	auipc	ra,0x2
    37a8:	482080e7          	jalr	1154(ra) # 5c26 <link>
    37ac:	3a050063          	beqz	a0,3b4c <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    37b0:	00004597          	auipc	a1,0x4
    37b4:	03858593          	addi	a1,a1,56 # 77e8 <malloc+0x17dc>
    37b8:	00004517          	auipc	a0,0x4
    37bc:	fa050513          	addi	a0,a0,-96 # 7758 <malloc+0x174c>
    37c0:	00002097          	auipc	ra,0x2
    37c4:	466080e7          	jalr	1126(ra) # 5c26 <link>
    37c8:	3a050063          	beqz	a0,3b68 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    37cc:	00004597          	auipc	a1,0x4
    37d0:	dd458593          	addi	a1,a1,-556 # 75a0 <malloc+0x1594>
    37d4:	00004517          	auipc	a0,0x4
    37d8:	cc450513          	addi	a0,a0,-828 # 7498 <malloc+0x148c>
    37dc:	00002097          	auipc	ra,0x2
    37e0:	44a080e7          	jalr	1098(ra) # 5c26 <link>
    37e4:	3a050063          	beqz	a0,3b84 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    37e8:	00004517          	auipc	a0,0x4
    37ec:	f4050513          	addi	a0,a0,-192 # 7728 <malloc+0x171c>
    37f0:	00002097          	auipc	ra,0x2
    37f4:	43e080e7          	jalr	1086(ra) # 5c2e <mkdir>
    37f8:	3a050463          	beqz	a0,3ba0 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    37fc:	00004517          	auipc	a0,0x4
    3800:	f5c50513          	addi	a0,a0,-164 # 7758 <malloc+0x174c>
    3804:	00002097          	auipc	ra,0x2
    3808:	42a080e7          	jalr	1066(ra) # 5c2e <mkdir>
    380c:	3a050863          	beqz	a0,3bbc <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3810:	00004517          	auipc	a0,0x4
    3814:	d9050513          	addi	a0,a0,-624 # 75a0 <malloc+0x1594>
    3818:	00002097          	auipc	ra,0x2
    381c:	416080e7          	jalr	1046(ra) # 5c2e <mkdir>
    3820:	3a050c63          	beqz	a0,3bd8 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3824:	00004517          	auipc	a0,0x4
    3828:	f3450513          	addi	a0,a0,-204 # 7758 <malloc+0x174c>
    382c:	00002097          	auipc	ra,0x2
    3830:	3ea080e7          	jalr	1002(ra) # 5c16 <unlink>
    3834:	3c050063          	beqz	a0,3bf4 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3838:	00004517          	auipc	a0,0x4
    383c:	ef050513          	addi	a0,a0,-272 # 7728 <malloc+0x171c>
    3840:	00002097          	auipc	ra,0x2
    3844:	3d6080e7          	jalr	982(ra) # 5c16 <unlink>
    3848:	3c050463          	beqz	a0,3c10 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    384c:	00004517          	auipc	a0,0x4
    3850:	c4c50513          	addi	a0,a0,-948 # 7498 <malloc+0x148c>
    3854:	00002097          	auipc	ra,0x2
    3858:	3e2080e7          	jalr	994(ra) # 5c36 <chdir>
    385c:	3c050863          	beqz	a0,3c2c <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3860:	00004517          	auipc	a0,0x4
    3864:	0d850513          	addi	a0,a0,216 # 7938 <malloc+0x192c>
    3868:	00002097          	auipc	ra,0x2
    386c:	3ce080e7          	jalr	974(ra) # 5c36 <chdir>
    3870:	3c050c63          	beqz	a0,3c48 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3874:	00004517          	auipc	a0,0x4
    3878:	d2c50513          	addi	a0,a0,-724 # 75a0 <malloc+0x1594>
    387c:	00002097          	auipc	ra,0x2
    3880:	39a080e7          	jalr	922(ra) # 5c16 <unlink>
    3884:	3e051063          	bnez	a0,3c64 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3888:	00004517          	auipc	a0,0x4
    388c:	c1050513          	addi	a0,a0,-1008 # 7498 <malloc+0x148c>
    3890:	00002097          	auipc	ra,0x2
    3894:	386080e7          	jalr	902(ra) # 5c16 <unlink>
    3898:	3e051463          	bnez	a0,3c80 <subdir+0x756>
  if(unlink("dd") == 0){
    389c:	00004517          	auipc	a0,0x4
    38a0:	bdc50513          	addi	a0,a0,-1060 # 7478 <malloc+0x146c>
    38a4:	00002097          	auipc	ra,0x2
    38a8:	372080e7          	jalr	882(ra) # 5c16 <unlink>
    38ac:	3e050863          	beqz	a0,3c9c <subdir+0x772>
  if(unlink("dd/dd") < 0){
    38b0:	00004517          	auipc	a0,0x4
    38b4:	0f850513          	addi	a0,a0,248 # 79a8 <malloc+0x199c>
    38b8:	00002097          	auipc	ra,0x2
    38bc:	35e080e7          	jalr	862(ra) # 5c16 <unlink>
    38c0:	3e054c63          	bltz	a0,3cb8 <subdir+0x78e>
  if(unlink("dd") < 0){
    38c4:	00004517          	auipc	a0,0x4
    38c8:	bb450513          	addi	a0,a0,-1100 # 7478 <malloc+0x146c>
    38cc:	00002097          	auipc	ra,0x2
    38d0:	34a080e7          	jalr	842(ra) # 5c16 <unlink>
    38d4:	40054063          	bltz	a0,3cd4 <subdir+0x7aa>
}
    38d8:	60e2                	ld	ra,24(sp)
    38da:	6442                	ld	s0,16(sp)
    38dc:	64a2                	ld	s1,8(sp)
    38de:	6902                	ld	s2,0(sp)
    38e0:	6105                	addi	sp,sp,32
    38e2:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    38e4:	85ca                	mv	a1,s2
    38e6:	00004517          	auipc	a0,0x4
    38ea:	b9a50513          	addi	a0,a0,-1126 # 7480 <malloc+0x1474>
    38ee:	00002097          	auipc	ra,0x2
    38f2:	660080e7          	jalr	1632(ra) # 5f4e <printf>
    exit(1);
    38f6:	4505                	li	a0,1
    38f8:	00002097          	auipc	ra,0x2
    38fc:	2ce080e7          	jalr	718(ra) # 5bc6 <exit>
    printf("%s: create dd/ff failed\n", s);
    3900:	85ca                	mv	a1,s2
    3902:	00004517          	auipc	a0,0x4
    3906:	b9e50513          	addi	a0,a0,-1122 # 74a0 <malloc+0x1494>
    390a:	00002097          	auipc	ra,0x2
    390e:	644080e7          	jalr	1604(ra) # 5f4e <printf>
    exit(1);
    3912:	4505                	li	a0,1
    3914:	00002097          	auipc	ra,0x2
    3918:	2b2080e7          	jalr	690(ra) # 5bc6 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    391c:	85ca                	mv	a1,s2
    391e:	00004517          	auipc	a0,0x4
    3922:	ba250513          	addi	a0,a0,-1118 # 74c0 <malloc+0x14b4>
    3926:	00002097          	auipc	ra,0x2
    392a:	628080e7          	jalr	1576(ra) # 5f4e <printf>
    exit(1);
    392e:	4505                	li	a0,1
    3930:	00002097          	auipc	ra,0x2
    3934:	296080e7          	jalr	662(ra) # 5bc6 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3938:	85ca                	mv	a1,s2
    393a:	00004517          	auipc	a0,0x4
    393e:	bbe50513          	addi	a0,a0,-1090 # 74f8 <malloc+0x14ec>
    3942:	00002097          	auipc	ra,0x2
    3946:	60c080e7          	jalr	1548(ra) # 5f4e <printf>
    exit(1);
    394a:	4505                	li	a0,1
    394c:	00002097          	auipc	ra,0x2
    3950:	27a080e7          	jalr	634(ra) # 5bc6 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3954:	85ca                	mv	a1,s2
    3956:	00004517          	auipc	a0,0x4
    395a:	bd250513          	addi	a0,a0,-1070 # 7528 <malloc+0x151c>
    395e:	00002097          	auipc	ra,0x2
    3962:	5f0080e7          	jalr	1520(ra) # 5f4e <printf>
    exit(1);
    3966:	4505                	li	a0,1
    3968:	00002097          	auipc	ra,0x2
    396c:	25e080e7          	jalr	606(ra) # 5bc6 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3970:	85ca                	mv	a1,s2
    3972:	00004517          	auipc	a0,0x4
    3976:	bee50513          	addi	a0,a0,-1042 # 7560 <malloc+0x1554>
    397a:	00002097          	auipc	ra,0x2
    397e:	5d4080e7          	jalr	1492(ra) # 5f4e <printf>
    exit(1);
    3982:	4505                	li	a0,1
    3984:	00002097          	auipc	ra,0x2
    3988:	242080e7          	jalr	578(ra) # 5bc6 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    398c:	85ca                	mv	a1,s2
    398e:	00004517          	auipc	a0,0x4
    3992:	bf250513          	addi	a0,a0,-1038 # 7580 <malloc+0x1574>
    3996:	00002097          	auipc	ra,0x2
    399a:	5b8080e7          	jalr	1464(ra) # 5f4e <printf>
    exit(1);
    399e:	4505                	li	a0,1
    39a0:	00002097          	auipc	ra,0x2
    39a4:	226080e7          	jalr	550(ra) # 5bc6 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    39a8:	85ca                	mv	a1,s2
    39aa:	00004517          	auipc	a0,0x4
    39ae:	c0650513          	addi	a0,a0,-1018 # 75b0 <malloc+0x15a4>
    39b2:	00002097          	auipc	ra,0x2
    39b6:	59c080e7          	jalr	1436(ra) # 5f4e <printf>
    exit(1);
    39ba:	4505                	li	a0,1
    39bc:	00002097          	auipc	ra,0x2
    39c0:	20a080e7          	jalr	522(ra) # 5bc6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    39c4:	85ca                	mv	a1,s2
    39c6:	00004517          	auipc	a0,0x4
    39ca:	c1250513          	addi	a0,a0,-1006 # 75d8 <malloc+0x15cc>
    39ce:	00002097          	auipc	ra,0x2
    39d2:	580080e7          	jalr	1408(ra) # 5f4e <printf>
    exit(1);
    39d6:	4505                	li	a0,1
    39d8:	00002097          	auipc	ra,0x2
    39dc:	1ee080e7          	jalr	494(ra) # 5bc6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    39e0:	85ca                	mv	a1,s2
    39e2:	00004517          	auipc	a0,0x4
    39e6:	c1650513          	addi	a0,a0,-1002 # 75f8 <malloc+0x15ec>
    39ea:	00002097          	auipc	ra,0x2
    39ee:	564080e7          	jalr	1380(ra) # 5f4e <printf>
    exit(1);
    39f2:	4505                	li	a0,1
    39f4:	00002097          	auipc	ra,0x2
    39f8:	1d2080e7          	jalr	466(ra) # 5bc6 <exit>
    printf("%s: chdir dd failed\n", s);
    39fc:	85ca                	mv	a1,s2
    39fe:	00004517          	auipc	a0,0x4
    3a02:	c2250513          	addi	a0,a0,-990 # 7620 <malloc+0x1614>
    3a06:	00002097          	auipc	ra,0x2
    3a0a:	548080e7          	jalr	1352(ra) # 5f4e <printf>
    exit(1);
    3a0e:	4505                	li	a0,1
    3a10:	00002097          	auipc	ra,0x2
    3a14:	1b6080e7          	jalr	438(ra) # 5bc6 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3a18:	85ca                	mv	a1,s2
    3a1a:	00004517          	auipc	a0,0x4
    3a1e:	c2e50513          	addi	a0,a0,-978 # 7648 <malloc+0x163c>
    3a22:	00002097          	auipc	ra,0x2
    3a26:	52c080e7          	jalr	1324(ra) # 5f4e <printf>
    exit(1);
    3a2a:	4505                	li	a0,1
    3a2c:	00002097          	auipc	ra,0x2
    3a30:	19a080e7          	jalr	410(ra) # 5bc6 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3a34:	85ca                	mv	a1,s2
    3a36:	00004517          	auipc	a0,0x4
    3a3a:	c4250513          	addi	a0,a0,-958 # 7678 <malloc+0x166c>
    3a3e:	00002097          	auipc	ra,0x2
    3a42:	510080e7          	jalr	1296(ra) # 5f4e <printf>
    exit(1);
    3a46:	4505                	li	a0,1
    3a48:	00002097          	auipc	ra,0x2
    3a4c:	17e080e7          	jalr	382(ra) # 5bc6 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3a50:	85ca                	mv	a1,s2
    3a52:	00004517          	auipc	a0,0x4
    3a56:	c4e50513          	addi	a0,a0,-946 # 76a0 <malloc+0x1694>
    3a5a:	00002097          	auipc	ra,0x2
    3a5e:	4f4080e7          	jalr	1268(ra) # 5f4e <printf>
    exit(1);
    3a62:	4505                	li	a0,1
    3a64:	00002097          	auipc	ra,0x2
    3a68:	162080e7          	jalr	354(ra) # 5bc6 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3a6c:	85ca                	mv	a1,s2
    3a6e:	00004517          	auipc	a0,0x4
    3a72:	c4a50513          	addi	a0,a0,-950 # 76b8 <malloc+0x16ac>
    3a76:	00002097          	auipc	ra,0x2
    3a7a:	4d8080e7          	jalr	1240(ra) # 5f4e <printf>
    exit(1);
    3a7e:	4505                	li	a0,1
    3a80:	00002097          	auipc	ra,0x2
    3a84:	146080e7          	jalr	326(ra) # 5bc6 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3a88:	85ca                	mv	a1,s2
    3a8a:	00004517          	auipc	a0,0x4
    3a8e:	c4e50513          	addi	a0,a0,-946 # 76d8 <malloc+0x16cc>
    3a92:	00002097          	auipc	ra,0x2
    3a96:	4bc080e7          	jalr	1212(ra) # 5f4e <printf>
    exit(1);
    3a9a:	4505                	li	a0,1
    3a9c:	00002097          	auipc	ra,0x2
    3aa0:	12a080e7          	jalr	298(ra) # 5bc6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3aa4:	85ca                	mv	a1,s2
    3aa6:	00004517          	auipc	a0,0x4
    3aaa:	c5250513          	addi	a0,a0,-942 # 76f8 <malloc+0x16ec>
    3aae:	00002097          	auipc	ra,0x2
    3ab2:	4a0080e7          	jalr	1184(ra) # 5f4e <printf>
    exit(1);
    3ab6:	4505                	li	a0,1
    3ab8:	00002097          	auipc	ra,0x2
    3abc:	10e080e7          	jalr	270(ra) # 5bc6 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3ac0:	85ca                	mv	a1,s2
    3ac2:	00004517          	auipc	a0,0x4
    3ac6:	c7650513          	addi	a0,a0,-906 # 7738 <malloc+0x172c>
    3aca:	00002097          	auipc	ra,0x2
    3ace:	484080e7          	jalr	1156(ra) # 5f4e <printf>
    exit(1);
    3ad2:	4505                	li	a0,1
    3ad4:	00002097          	auipc	ra,0x2
    3ad8:	0f2080e7          	jalr	242(ra) # 5bc6 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3adc:	85ca                	mv	a1,s2
    3ade:	00004517          	auipc	a0,0x4
    3ae2:	c8a50513          	addi	a0,a0,-886 # 7768 <malloc+0x175c>
    3ae6:	00002097          	auipc	ra,0x2
    3aea:	468080e7          	jalr	1128(ra) # 5f4e <printf>
    exit(1);
    3aee:	4505                	li	a0,1
    3af0:	00002097          	auipc	ra,0x2
    3af4:	0d6080e7          	jalr	214(ra) # 5bc6 <exit>
    printf("%s: create dd succeeded!\n", s);
    3af8:	85ca                	mv	a1,s2
    3afa:	00004517          	auipc	a0,0x4
    3afe:	c8e50513          	addi	a0,a0,-882 # 7788 <malloc+0x177c>
    3b02:	00002097          	auipc	ra,0x2
    3b06:	44c080e7          	jalr	1100(ra) # 5f4e <printf>
    exit(1);
    3b0a:	4505                	li	a0,1
    3b0c:	00002097          	auipc	ra,0x2
    3b10:	0ba080e7          	jalr	186(ra) # 5bc6 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3b14:	85ca                	mv	a1,s2
    3b16:	00004517          	auipc	a0,0x4
    3b1a:	c9250513          	addi	a0,a0,-878 # 77a8 <malloc+0x179c>
    3b1e:	00002097          	auipc	ra,0x2
    3b22:	430080e7          	jalr	1072(ra) # 5f4e <printf>
    exit(1);
    3b26:	4505                	li	a0,1
    3b28:	00002097          	auipc	ra,0x2
    3b2c:	09e080e7          	jalr	158(ra) # 5bc6 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3b30:	85ca                	mv	a1,s2
    3b32:	00004517          	auipc	a0,0x4
    3b36:	c9650513          	addi	a0,a0,-874 # 77c8 <malloc+0x17bc>
    3b3a:	00002097          	auipc	ra,0x2
    3b3e:	414080e7          	jalr	1044(ra) # 5f4e <printf>
    exit(1);
    3b42:	4505                	li	a0,1
    3b44:	00002097          	auipc	ra,0x2
    3b48:	082080e7          	jalr	130(ra) # 5bc6 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3b4c:	85ca                	mv	a1,s2
    3b4e:	00004517          	auipc	a0,0x4
    3b52:	caa50513          	addi	a0,a0,-854 # 77f8 <malloc+0x17ec>
    3b56:	00002097          	auipc	ra,0x2
    3b5a:	3f8080e7          	jalr	1016(ra) # 5f4e <printf>
    exit(1);
    3b5e:	4505                	li	a0,1
    3b60:	00002097          	auipc	ra,0x2
    3b64:	066080e7          	jalr	102(ra) # 5bc6 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3b68:	85ca                	mv	a1,s2
    3b6a:	00004517          	auipc	a0,0x4
    3b6e:	cb650513          	addi	a0,a0,-842 # 7820 <malloc+0x1814>
    3b72:	00002097          	auipc	ra,0x2
    3b76:	3dc080e7          	jalr	988(ra) # 5f4e <printf>
    exit(1);
    3b7a:	4505                	li	a0,1
    3b7c:	00002097          	auipc	ra,0x2
    3b80:	04a080e7          	jalr	74(ra) # 5bc6 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3b84:	85ca                	mv	a1,s2
    3b86:	00004517          	auipc	a0,0x4
    3b8a:	cc250513          	addi	a0,a0,-830 # 7848 <malloc+0x183c>
    3b8e:	00002097          	auipc	ra,0x2
    3b92:	3c0080e7          	jalr	960(ra) # 5f4e <printf>
    exit(1);
    3b96:	4505                	li	a0,1
    3b98:	00002097          	auipc	ra,0x2
    3b9c:	02e080e7          	jalr	46(ra) # 5bc6 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3ba0:	85ca                	mv	a1,s2
    3ba2:	00004517          	auipc	a0,0x4
    3ba6:	cce50513          	addi	a0,a0,-818 # 7870 <malloc+0x1864>
    3baa:	00002097          	auipc	ra,0x2
    3bae:	3a4080e7          	jalr	932(ra) # 5f4e <printf>
    exit(1);
    3bb2:	4505                	li	a0,1
    3bb4:	00002097          	auipc	ra,0x2
    3bb8:	012080e7          	jalr	18(ra) # 5bc6 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3bbc:	85ca                	mv	a1,s2
    3bbe:	00004517          	auipc	a0,0x4
    3bc2:	cd250513          	addi	a0,a0,-814 # 7890 <malloc+0x1884>
    3bc6:	00002097          	auipc	ra,0x2
    3bca:	388080e7          	jalr	904(ra) # 5f4e <printf>
    exit(1);
    3bce:	4505                	li	a0,1
    3bd0:	00002097          	auipc	ra,0x2
    3bd4:	ff6080e7          	jalr	-10(ra) # 5bc6 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3bd8:	85ca                	mv	a1,s2
    3bda:	00004517          	auipc	a0,0x4
    3bde:	cd650513          	addi	a0,a0,-810 # 78b0 <malloc+0x18a4>
    3be2:	00002097          	auipc	ra,0x2
    3be6:	36c080e7          	jalr	876(ra) # 5f4e <printf>
    exit(1);
    3bea:	4505                	li	a0,1
    3bec:	00002097          	auipc	ra,0x2
    3bf0:	fda080e7          	jalr	-38(ra) # 5bc6 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3bf4:	85ca                	mv	a1,s2
    3bf6:	00004517          	auipc	a0,0x4
    3bfa:	ce250513          	addi	a0,a0,-798 # 78d8 <malloc+0x18cc>
    3bfe:	00002097          	auipc	ra,0x2
    3c02:	350080e7          	jalr	848(ra) # 5f4e <printf>
    exit(1);
    3c06:	4505                	li	a0,1
    3c08:	00002097          	auipc	ra,0x2
    3c0c:	fbe080e7          	jalr	-66(ra) # 5bc6 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3c10:	85ca                	mv	a1,s2
    3c12:	00004517          	auipc	a0,0x4
    3c16:	ce650513          	addi	a0,a0,-794 # 78f8 <malloc+0x18ec>
    3c1a:	00002097          	auipc	ra,0x2
    3c1e:	334080e7          	jalr	820(ra) # 5f4e <printf>
    exit(1);
    3c22:	4505                	li	a0,1
    3c24:	00002097          	auipc	ra,0x2
    3c28:	fa2080e7          	jalr	-94(ra) # 5bc6 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3c2c:	85ca                	mv	a1,s2
    3c2e:	00004517          	auipc	a0,0x4
    3c32:	cea50513          	addi	a0,a0,-790 # 7918 <malloc+0x190c>
    3c36:	00002097          	auipc	ra,0x2
    3c3a:	318080e7          	jalr	792(ra) # 5f4e <printf>
    exit(1);
    3c3e:	4505                	li	a0,1
    3c40:	00002097          	auipc	ra,0x2
    3c44:	f86080e7          	jalr	-122(ra) # 5bc6 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3c48:	85ca                	mv	a1,s2
    3c4a:	00004517          	auipc	a0,0x4
    3c4e:	cf650513          	addi	a0,a0,-778 # 7940 <malloc+0x1934>
    3c52:	00002097          	auipc	ra,0x2
    3c56:	2fc080e7          	jalr	764(ra) # 5f4e <printf>
    exit(1);
    3c5a:	4505                	li	a0,1
    3c5c:	00002097          	auipc	ra,0x2
    3c60:	f6a080e7          	jalr	-150(ra) # 5bc6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3c64:	85ca                	mv	a1,s2
    3c66:	00004517          	auipc	a0,0x4
    3c6a:	97250513          	addi	a0,a0,-1678 # 75d8 <malloc+0x15cc>
    3c6e:	00002097          	auipc	ra,0x2
    3c72:	2e0080e7          	jalr	736(ra) # 5f4e <printf>
    exit(1);
    3c76:	4505                	li	a0,1
    3c78:	00002097          	auipc	ra,0x2
    3c7c:	f4e080e7          	jalr	-178(ra) # 5bc6 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3c80:	85ca                	mv	a1,s2
    3c82:	00004517          	auipc	a0,0x4
    3c86:	cde50513          	addi	a0,a0,-802 # 7960 <malloc+0x1954>
    3c8a:	00002097          	auipc	ra,0x2
    3c8e:	2c4080e7          	jalr	708(ra) # 5f4e <printf>
    exit(1);
    3c92:	4505                	li	a0,1
    3c94:	00002097          	auipc	ra,0x2
    3c98:	f32080e7          	jalr	-206(ra) # 5bc6 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3c9c:	85ca                	mv	a1,s2
    3c9e:	00004517          	auipc	a0,0x4
    3ca2:	ce250513          	addi	a0,a0,-798 # 7980 <malloc+0x1974>
    3ca6:	00002097          	auipc	ra,0x2
    3caa:	2a8080e7          	jalr	680(ra) # 5f4e <printf>
    exit(1);
    3cae:	4505                	li	a0,1
    3cb0:	00002097          	auipc	ra,0x2
    3cb4:	f16080e7          	jalr	-234(ra) # 5bc6 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3cb8:	85ca                	mv	a1,s2
    3cba:	00004517          	auipc	a0,0x4
    3cbe:	cf650513          	addi	a0,a0,-778 # 79b0 <malloc+0x19a4>
    3cc2:	00002097          	auipc	ra,0x2
    3cc6:	28c080e7          	jalr	652(ra) # 5f4e <printf>
    exit(1);
    3cca:	4505                	li	a0,1
    3ccc:	00002097          	auipc	ra,0x2
    3cd0:	efa080e7          	jalr	-262(ra) # 5bc6 <exit>
    printf("%s: unlink dd failed\n", s);
    3cd4:	85ca                	mv	a1,s2
    3cd6:	00004517          	auipc	a0,0x4
    3cda:	cfa50513          	addi	a0,a0,-774 # 79d0 <malloc+0x19c4>
    3cde:	00002097          	auipc	ra,0x2
    3ce2:	270080e7          	jalr	624(ra) # 5f4e <printf>
    exit(1);
    3ce6:	4505                	li	a0,1
    3ce8:	00002097          	auipc	ra,0x2
    3cec:	ede080e7          	jalr	-290(ra) # 5bc6 <exit>

0000000000003cf0 <rmdot>:
{
    3cf0:	1101                	addi	sp,sp,-32
    3cf2:	ec06                	sd	ra,24(sp)
    3cf4:	e822                	sd	s0,16(sp)
    3cf6:	e426                	sd	s1,8(sp)
    3cf8:	1000                	addi	s0,sp,32
    3cfa:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3cfc:	00004517          	auipc	a0,0x4
    3d00:	cec50513          	addi	a0,a0,-788 # 79e8 <malloc+0x19dc>
    3d04:	00002097          	auipc	ra,0x2
    3d08:	f2a080e7          	jalr	-214(ra) # 5c2e <mkdir>
    3d0c:	e549                	bnez	a0,3d96 <rmdot+0xa6>
  if(chdir("dots") != 0){
    3d0e:	00004517          	auipc	a0,0x4
    3d12:	cda50513          	addi	a0,a0,-806 # 79e8 <malloc+0x19dc>
    3d16:	00002097          	auipc	ra,0x2
    3d1a:	f20080e7          	jalr	-224(ra) # 5c36 <chdir>
    3d1e:	e951                	bnez	a0,3db2 <rmdot+0xc2>
  if(unlink(".") == 0){
    3d20:	00003517          	auipc	a0,0x3
    3d24:	b1050513          	addi	a0,a0,-1264 # 6830 <malloc+0x824>
    3d28:	00002097          	auipc	ra,0x2
    3d2c:	eee080e7          	jalr	-274(ra) # 5c16 <unlink>
    3d30:	cd59                	beqz	a0,3dce <rmdot+0xde>
  if(unlink("..") == 0){
    3d32:	00003517          	auipc	a0,0x3
    3d36:	70e50513          	addi	a0,a0,1806 # 7440 <malloc+0x1434>
    3d3a:	00002097          	auipc	ra,0x2
    3d3e:	edc080e7          	jalr	-292(ra) # 5c16 <unlink>
    3d42:	c545                	beqz	a0,3dea <rmdot+0xfa>
  if(chdir("/") != 0){
    3d44:	00003517          	auipc	a0,0x3
    3d48:	6a450513          	addi	a0,a0,1700 # 73e8 <malloc+0x13dc>
    3d4c:	00002097          	auipc	ra,0x2
    3d50:	eea080e7          	jalr	-278(ra) # 5c36 <chdir>
    3d54:	e94d                	bnez	a0,3e06 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3d56:	00004517          	auipc	a0,0x4
    3d5a:	cfa50513          	addi	a0,a0,-774 # 7a50 <malloc+0x1a44>
    3d5e:	00002097          	auipc	ra,0x2
    3d62:	eb8080e7          	jalr	-328(ra) # 5c16 <unlink>
    3d66:	cd55                	beqz	a0,3e22 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3d68:	00004517          	auipc	a0,0x4
    3d6c:	d1050513          	addi	a0,a0,-752 # 7a78 <malloc+0x1a6c>
    3d70:	00002097          	auipc	ra,0x2
    3d74:	ea6080e7          	jalr	-346(ra) # 5c16 <unlink>
    3d78:	c179                	beqz	a0,3e3e <rmdot+0x14e>
  if(unlink("dots") != 0){
    3d7a:	00004517          	auipc	a0,0x4
    3d7e:	c6e50513          	addi	a0,a0,-914 # 79e8 <malloc+0x19dc>
    3d82:	00002097          	auipc	ra,0x2
    3d86:	e94080e7          	jalr	-364(ra) # 5c16 <unlink>
    3d8a:	e961                	bnez	a0,3e5a <rmdot+0x16a>
}
    3d8c:	60e2                	ld	ra,24(sp)
    3d8e:	6442                	ld	s0,16(sp)
    3d90:	64a2                	ld	s1,8(sp)
    3d92:	6105                	addi	sp,sp,32
    3d94:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3d96:	85a6                	mv	a1,s1
    3d98:	00004517          	auipc	a0,0x4
    3d9c:	c5850513          	addi	a0,a0,-936 # 79f0 <malloc+0x19e4>
    3da0:	00002097          	auipc	ra,0x2
    3da4:	1ae080e7          	jalr	430(ra) # 5f4e <printf>
    exit(1);
    3da8:	4505                	li	a0,1
    3daa:	00002097          	auipc	ra,0x2
    3dae:	e1c080e7          	jalr	-484(ra) # 5bc6 <exit>
    printf("%s: chdir dots failed\n", s);
    3db2:	85a6                	mv	a1,s1
    3db4:	00004517          	auipc	a0,0x4
    3db8:	c5450513          	addi	a0,a0,-940 # 7a08 <malloc+0x19fc>
    3dbc:	00002097          	auipc	ra,0x2
    3dc0:	192080e7          	jalr	402(ra) # 5f4e <printf>
    exit(1);
    3dc4:	4505                	li	a0,1
    3dc6:	00002097          	auipc	ra,0x2
    3dca:	e00080e7          	jalr	-512(ra) # 5bc6 <exit>
    printf("%s: rm . worked!\n", s);
    3dce:	85a6                	mv	a1,s1
    3dd0:	00004517          	auipc	a0,0x4
    3dd4:	c5050513          	addi	a0,a0,-944 # 7a20 <malloc+0x1a14>
    3dd8:	00002097          	auipc	ra,0x2
    3ddc:	176080e7          	jalr	374(ra) # 5f4e <printf>
    exit(1);
    3de0:	4505                	li	a0,1
    3de2:	00002097          	auipc	ra,0x2
    3de6:	de4080e7          	jalr	-540(ra) # 5bc6 <exit>
    printf("%s: rm .. worked!\n", s);
    3dea:	85a6                	mv	a1,s1
    3dec:	00004517          	auipc	a0,0x4
    3df0:	c4c50513          	addi	a0,a0,-948 # 7a38 <malloc+0x1a2c>
    3df4:	00002097          	auipc	ra,0x2
    3df8:	15a080e7          	jalr	346(ra) # 5f4e <printf>
    exit(1);
    3dfc:	4505                	li	a0,1
    3dfe:	00002097          	auipc	ra,0x2
    3e02:	dc8080e7          	jalr	-568(ra) # 5bc6 <exit>
    printf("%s: chdir / failed\n", s);
    3e06:	85a6                	mv	a1,s1
    3e08:	00003517          	auipc	a0,0x3
    3e0c:	5e850513          	addi	a0,a0,1512 # 73f0 <malloc+0x13e4>
    3e10:	00002097          	auipc	ra,0x2
    3e14:	13e080e7          	jalr	318(ra) # 5f4e <printf>
    exit(1);
    3e18:	4505                	li	a0,1
    3e1a:	00002097          	auipc	ra,0x2
    3e1e:	dac080e7          	jalr	-596(ra) # 5bc6 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3e22:	85a6                	mv	a1,s1
    3e24:	00004517          	auipc	a0,0x4
    3e28:	c3450513          	addi	a0,a0,-972 # 7a58 <malloc+0x1a4c>
    3e2c:	00002097          	auipc	ra,0x2
    3e30:	122080e7          	jalr	290(ra) # 5f4e <printf>
    exit(1);
    3e34:	4505                	li	a0,1
    3e36:	00002097          	auipc	ra,0x2
    3e3a:	d90080e7          	jalr	-624(ra) # 5bc6 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3e3e:	85a6                	mv	a1,s1
    3e40:	00004517          	auipc	a0,0x4
    3e44:	c4050513          	addi	a0,a0,-960 # 7a80 <malloc+0x1a74>
    3e48:	00002097          	auipc	ra,0x2
    3e4c:	106080e7          	jalr	262(ra) # 5f4e <printf>
    exit(1);
    3e50:	4505                	li	a0,1
    3e52:	00002097          	auipc	ra,0x2
    3e56:	d74080e7          	jalr	-652(ra) # 5bc6 <exit>
    printf("%s: unlink dots failed!\n", s);
    3e5a:	85a6                	mv	a1,s1
    3e5c:	00004517          	auipc	a0,0x4
    3e60:	c4450513          	addi	a0,a0,-956 # 7aa0 <malloc+0x1a94>
    3e64:	00002097          	auipc	ra,0x2
    3e68:	0ea080e7          	jalr	234(ra) # 5f4e <printf>
    exit(1);
    3e6c:	4505                	li	a0,1
    3e6e:	00002097          	auipc	ra,0x2
    3e72:	d58080e7          	jalr	-680(ra) # 5bc6 <exit>

0000000000003e76 <dirfile>:
{
    3e76:	1101                	addi	sp,sp,-32
    3e78:	ec06                	sd	ra,24(sp)
    3e7a:	e822                	sd	s0,16(sp)
    3e7c:	e426                	sd	s1,8(sp)
    3e7e:	e04a                	sd	s2,0(sp)
    3e80:	1000                	addi	s0,sp,32
    3e82:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3e84:	20000593          	li	a1,512
    3e88:	00004517          	auipc	a0,0x4
    3e8c:	c3850513          	addi	a0,a0,-968 # 7ac0 <malloc+0x1ab4>
    3e90:	00002097          	auipc	ra,0x2
    3e94:	d76080e7          	jalr	-650(ra) # 5c06 <open>
  if(fd < 0){
    3e98:	0e054d63          	bltz	a0,3f92 <dirfile+0x11c>
  close(fd);
    3e9c:	00002097          	auipc	ra,0x2
    3ea0:	d52080e7          	jalr	-686(ra) # 5bee <close>
  if(chdir("dirfile") == 0){
    3ea4:	00004517          	auipc	a0,0x4
    3ea8:	c1c50513          	addi	a0,a0,-996 # 7ac0 <malloc+0x1ab4>
    3eac:	00002097          	auipc	ra,0x2
    3eb0:	d8a080e7          	jalr	-630(ra) # 5c36 <chdir>
    3eb4:	cd6d                	beqz	a0,3fae <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3eb6:	4581                	li	a1,0
    3eb8:	00004517          	auipc	a0,0x4
    3ebc:	c5050513          	addi	a0,a0,-944 # 7b08 <malloc+0x1afc>
    3ec0:	00002097          	auipc	ra,0x2
    3ec4:	d46080e7          	jalr	-698(ra) # 5c06 <open>
  if(fd >= 0){
    3ec8:	10055163          	bgez	a0,3fca <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3ecc:	20000593          	li	a1,512
    3ed0:	00004517          	auipc	a0,0x4
    3ed4:	c3850513          	addi	a0,a0,-968 # 7b08 <malloc+0x1afc>
    3ed8:	00002097          	auipc	ra,0x2
    3edc:	d2e080e7          	jalr	-722(ra) # 5c06 <open>
  if(fd >= 0){
    3ee0:	10055363          	bgez	a0,3fe6 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3ee4:	00004517          	auipc	a0,0x4
    3ee8:	c2450513          	addi	a0,a0,-988 # 7b08 <malloc+0x1afc>
    3eec:	00002097          	auipc	ra,0x2
    3ef0:	d42080e7          	jalr	-702(ra) # 5c2e <mkdir>
    3ef4:	10050763          	beqz	a0,4002 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3ef8:	00004517          	auipc	a0,0x4
    3efc:	c1050513          	addi	a0,a0,-1008 # 7b08 <malloc+0x1afc>
    3f00:	00002097          	auipc	ra,0x2
    3f04:	d16080e7          	jalr	-746(ra) # 5c16 <unlink>
    3f08:	10050b63          	beqz	a0,401e <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3f0c:	00004597          	auipc	a1,0x4
    3f10:	bfc58593          	addi	a1,a1,-1028 # 7b08 <malloc+0x1afc>
    3f14:	00002517          	auipc	a0,0x2
    3f18:	40c50513          	addi	a0,a0,1036 # 6320 <malloc+0x314>
    3f1c:	00002097          	auipc	ra,0x2
    3f20:	d0a080e7          	jalr	-758(ra) # 5c26 <link>
    3f24:	10050b63          	beqz	a0,403a <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3f28:	00004517          	auipc	a0,0x4
    3f2c:	b9850513          	addi	a0,a0,-1128 # 7ac0 <malloc+0x1ab4>
    3f30:	00002097          	auipc	ra,0x2
    3f34:	ce6080e7          	jalr	-794(ra) # 5c16 <unlink>
    3f38:	10051f63          	bnez	a0,4056 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3f3c:	4589                	li	a1,2
    3f3e:	00003517          	auipc	a0,0x3
    3f42:	8f250513          	addi	a0,a0,-1806 # 6830 <malloc+0x824>
    3f46:	00002097          	auipc	ra,0x2
    3f4a:	cc0080e7          	jalr	-832(ra) # 5c06 <open>
  if(fd >= 0){
    3f4e:	12055263          	bgez	a0,4072 <dirfile+0x1fc>
  fd = open(".", 0);
    3f52:	4581                	li	a1,0
    3f54:	00003517          	auipc	a0,0x3
    3f58:	8dc50513          	addi	a0,a0,-1828 # 6830 <malloc+0x824>
    3f5c:	00002097          	auipc	ra,0x2
    3f60:	caa080e7          	jalr	-854(ra) # 5c06 <open>
    3f64:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3f66:	4605                	li	a2,1
    3f68:	00002597          	auipc	a1,0x2
    3f6c:	25058593          	addi	a1,a1,592 # 61b8 <malloc+0x1ac>
    3f70:	00002097          	auipc	ra,0x2
    3f74:	c76080e7          	jalr	-906(ra) # 5be6 <write>
    3f78:	10a04b63          	bgtz	a0,408e <dirfile+0x218>
  close(fd);
    3f7c:	8526                	mv	a0,s1
    3f7e:	00002097          	auipc	ra,0x2
    3f82:	c70080e7          	jalr	-912(ra) # 5bee <close>
}
    3f86:	60e2                	ld	ra,24(sp)
    3f88:	6442                	ld	s0,16(sp)
    3f8a:	64a2                	ld	s1,8(sp)
    3f8c:	6902                	ld	s2,0(sp)
    3f8e:	6105                	addi	sp,sp,32
    3f90:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3f92:	85ca                	mv	a1,s2
    3f94:	00004517          	auipc	a0,0x4
    3f98:	b3450513          	addi	a0,a0,-1228 # 7ac8 <malloc+0x1abc>
    3f9c:	00002097          	auipc	ra,0x2
    3fa0:	fb2080e7          	jalr	-78(ra) # 5f4e <printf>
    exit(1);
    3fa4:	4505                	li	a0,1
    3fa6:	00002097          	auipc	ra,0x2
    3faa:	c20080e7          	jalr	-992(ra) # 5bc6 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3fae:	85ca                	mv	a1,s2
    3fb0:	00004517          	auipc	a0,0x4
    3fb4:	b3850513          	addi	a0,a0,-1224 # 7ae8 <malloc+0x1adc>
    3fb8:	00002097          	auipc	ra,0x2
    3fbc:	f96080e7          	jalr	-106(ra) # 5f4e <printf>
    exit(1);
    3fc0:	4505                	li	a0,1
    3fc2:	00002097          	auipc	ra,0x2
    3fc6:	c04080e7          	jalr	-1020(ra) # 5bc6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3fca:	85ca                	mv	a1,s2
    3fcc:	00004517          	auipc	a0,0x4
    3fd0:	b4c50513          	addi	a0,a0,-1204 # 7b18 <malloc+0x1b0c>
    3fd4:	00002097          	auipc	ra,0x2
    3fd8:	f7a080e7          	jalr	-134(ra) # 5f4e <printf>
    exit(1);
    3fdc:	4505                	li	a0,1
    3fde:	00002097          	auipc	ra,0x2
    3fe2:	be8080e7          	jalr	-1048(ra) # 5bc6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3fe6:	85ca                	mv	a1,s2
    3fe8:	00004517          	auipc	a0,0x4
    3fec:	b3050513          	addi	a0,a0,-1232 # 7b18 <malloc+0x1b0c>
    3ff0:	00002097          	auipc	ra,0x2
    3ff4:	f5e080e7          	jalr	-162(ra) # 5f4e <printf>
    exit(1);
    3ff8:	4505                	li	a0,1
    3ffa:	00002097          	auipc	ra,0x2
    3ffe:	bcc080e7          	jalr	-1076(ra) # 5bc6 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4002:	85ca                	mv	a1,s2
    4004:	00004517          	auipc	a0,0x4
    4008:	b3c50513          	addi	a0,a0,-1220 # 7b40 <malloc+0x1b34>
    400c:	00002097          	auipc	ra,0x2
    4010:	f42080e7          	jalr	-190(ra) # 5f4e <printf>
    exit(1);
    4014:	4505                	li	a0,1
    4016:	00002097          	auipc	ra,0x2
    401a:	bb0080e7          	jalr	-1104(ra) # 5bc6 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    401e:	85ca                	mv	a1,s2
    4020:	00004517          	auipc	a0,0x4
    4024:	b4850513          	addi	a0,a0,-1208 # 7b68 <malloc+0x1b5c>
    4028:	00002097          	auipc	ra,0x2
    402c:	f26080e7          	jalr	-218(ra) # 5f4e <printf>
    exit(1);
    4030:	4505                	li	a0,1
    4032:	00002097          	auipc	ra,0x2
    4036:	b94080e7          	jalr	-1132(ra) # 5bc6 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    403a:	85ca                	mv	a1,s2
    403c:	00004517          	auipc	a0,0x4
    4040:	b5450513          	addi	a0,a0,-1196 # 7b90 <malloc+0x1b84>
    4044:	00002097          	auipc	ra,0x2
    4048:	f0a080e7          	jalr	-246(ra) # 5f4e <printf>
    exit(1);
    404c:	4505                	li	a0,1
    404e:	00002097          	auipc	ra,0x2
    4052:	b78080e7          	jalr	-1160(ra) # 5bc6 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    4056:	85ca                	mv	a1,s2
    4058:	00004517          	auipc	a0,0x4
    405c:	b6050513          	addi	a0,a0,-1184 # 7bb8 <malloc+0x1bac>
    4060:	00002097          	auipc	ra,0x2
    4064:	eee080e7          	jalr	-274(ra) # 5f4e <printf>
    exit(1);
    4068:	4505                	li	a0,1
    406a:	00002097          	auipc	ra,0x2
    406e:	b5c080e7          	jalr	-1188(ra) # 5bc6 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    4072:	85ca                	mv	a1,s2
    4074:	00004517          	auipc	a0,0x4
    4078:	b6450513          	addi	a0,a0,-1180 # 7bd8 <malloc+0x1bcc>
    407c:	00002097          	auipc	ra,0x2
    4080:	ed2080e7          	jalr	-302(ra) # 5f4e <printf>
    exit(1);
    4084:	4505                	li	a0,1
    4086:	00002097          	auipc	ra,0x2
    408a:	b40080e7          	jalr	-1216(ra) # 5bc6 <exit>
    printf("%s: write . succeeded!\n", s);
    408e:	85ca                	mv	a1,s2
    4090:	00004517          	auipc	a0,0x4
    4094:	b7050513          	addi	a0,a0,-1168 # 7c00 <malloc+0x1bf4>
    4098:	00002097          	auipc	ra,0x2
    409c:	eb6080e7          	jalr	-330(ra) # 5f4e <printf>
    exit(1);
    40a0:	4505                	li	a0,1
    40a2:	00002097          	auipc	ra,0x2
    40a6:	b24080e7          	jalr	-1244(ra) # 5bc6 <exit>

00000000000040aa <iref>:
{
    40aa:	7139                	addi	sp,sp,-64
    40ac:	fc06                	sd	ra,56(sp)
    40ae:	f822                	sd	s0,48(sp)
    40b0:	f426                	sd	s1,40(sp)
    40b2:	f04a                	sd	s2,32(sp)
    40b4:	ec4e                	sd	s3,24(sp)
    40b6:	e852                	sd	s4,16(sp)
    40b8:	e456                	sd	s5,8(sp)
    40ba:	e05a                	sd	s6,0(sp)
    40bc:	0080                	addi	s0,sp,64
    40be:	8b2a                	mv	s6,a0
    40c0:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    40c4:	00004a17          	auipc	s4,0x4
    40c8:	b54a0a13          	addi	s4,s4,-1196 # 7c18 <malloc+0x1c0c>
    mkdir("");
    40cc:	00003497          	auipc	s1,0x3
    40d0:	65448493          	addi	s1,s1,1620 # 7720 <malloc+0x1714>
    link("README", "");
    40d4:	00002a97          	auipc	s5,0x2
    40d8:	24ca8a93          	addi	s5,s5,588 # 6320 <malloc+0x314>
    fd = open("xx", O_CREATE);
    40dc:	00004997          	auipc	s3,0x4
    40e0:	a3498993          	addi	s3,s3,-1484 # 7b10 <malloc+0x1b04>
    40e4:	a891                	j	4138 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    40e6:	85da                	mv	a1,s6
    40e8:	00004517          	auipc	a0,0x4
    40ec:	b3850513          	addi	a0,a0,-1224 # 7c20 <malloc+0x1c14>
    40f0:	00002097          	auipc	ra,0x2
    40f4:	e5e080e7          	jalr	-418(ra) # 5f4e <printf>
      exit(1);
    40f8:	4505                	li	a0,1
    40fa:	00002097          	auipc	ra,0x2
    40fe:	acc080e7          	jalr	-1332(ra) # 5bc6 <exit>
      printf("%s: chdir irefd failed\n", s);
    4102:	85da                	mv	a1,s6
    4104:	00004517          	auipc	a0,0x4
    4108:	b3450513          	addi	a0,a0,-1228 # 7c38 <malloc+0x1c2c>
    410c:	00002097          	auipc	ra,0x2
    4110:	e42080e7          	jalr	-446(ra) # 5f4e <printf>
      exit(1);
    4114:	4505                	li	a0,1
    4116:	00002097          	auipc	ra,0x2
    411a:	ab0080e7          	jalr	-1360(ra) # 5bc6 <exit>
      close(fd);
    411e:	00002097          	auipc	ra,0x2
    4122:	ad0080e7          	jalr	-1328(ra) # 5bee <close>
    4126:	a889                	j	4178 <iref+0xce>
    unlink("xx");
    4128:	854e                	mv	a0,s3
    412a:	00002097          	auipc	ra,0x2
    412e:	aec080e7          	jalr	-1300(ra) # 5c16 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4132:	397d                	addiw	s2,s2,-1
    4134:	06090063          	beqz	s2,4194 <iref+0xea>
    if(mkdir("irefd") != 0){
    4138:	8552                	mv	a0,s4
    413a:	00002097          	auipc	ra,0x2
    413e:	af4080e7          	jalr	-1292(ra) # 5c2e <mkdir>
    4142:	f155                	bnez	a0,40e6 <iref+0x3c>
    if(chdir("irefd") != 0){
    4144:	8552                	mv	a0,s4
    4146:	00002097          	auipc	ra,0x2
    414a:	af0080e7          	jalr	-1296(ra) # 5c36 <chdir>
    414e:	f955                	bnez	a0,4102 <iref+0x58>
    mkdir("");
    4150:	8526                	mv	a0,s1
    4152:	00002097          	auipc	ra,0x2
    4156:	adc080e7          	jalr	-1316(ra) # 5c2e <mkdir>
    link("README", "");
    415a:	85a6                	mv	a1,s1
    415c:	8556                	mv	a0,s5
    415e:	00002097          	auipc	ra,0x2
    4162:	ac8080e7          	jalr	-1336(ra) # 5c26 <link>
    fd = open("", O_CREATE);
    4166:	20000593          	li	a1,512
    416a:	8526                	mv	a0,s1
    416c:	00002097          	auipc	ra,0x2
    4170:	a9a080e7          	jalr	-1382(ra) # 5c06 <open>
    if(fd >= 0)
    4174:	fa0555e3          	bgez	a0,411e <iref+0x74>
    fd = open("xx", O_CREATE);
    4178:	20000593          	li	a1,512
    417c:	854e                	mv	a0,s3
    417e:	00002097          	auipc	ra,0x2
    4182:	a88080e7          	jalr	-1400(ra) # 5c06 <open>
    if(fd >= 0)
    4186:	fa0541e3          	bltz	a0,4128 <iref+0x7e>
      close(fd);
    418a:	00002097          	auipc	ra,0x2
    418e:	a64080e7          	jalr	-1436(ra) # 5bee <close>
    4192:	bf59                	j	4128 <iref+0x7e>
    4194:	03300493          	li	s1,51
    chdir("..");
    4198:	00003997          	auipc	s3,0x3
    419c:	2a898993          	addi	s3,s3,680 # 7440 <malloc+0x1434>
    unlink("irefd");
    41a0:	00004917          	auipc	s2,0x4
    41a4:	a7890913          	addi	s2,s2,-1416 # 7c18 <malloc+0x1c0c>
    chdir("..");
    41a8:	854e                	mv	a0,s3
    41aa:	00002097          	auipc	ra,0x2
    41ae:	a8c080e7          	jalr	-1396(ra) # 5c36 <chdir>
    unlink("irefd");
    41b2:	854a                	mv	a0,s2
    41b4:	00002097          	auipc	ra,0x2
    41b8:	a62080e7          	jalr	-1438(ra) # 5c16 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    41bc:	34fd                	addiw	s1,s1,-1
    41be:	f4ed                	bnez	s1,41a8 <iref+0xfe>
  chdir("/");
    41c0:	00003517          	auipc	a0,0x3
    41c4:	22850513          	addi	a0,a0,552 # 73e8 <malloc+0x13dc>
    41c8:	00002097          	auipc	ra,0x2
    41cc:	a6e080e7          	jalr	-1426(ra) # 5c36 <chdir>
}
    41d0:	70e2                	ld	ra,56(sp)
    41d2:	7442                	ld	s0,48(sp)
    41d4:	74a2                	ld	s1,40(sp)
    41d6:	7902                	ld	s2,32(sp)
    41d8:	69e2                	ld	s3,24(sp)
    41da:	6a42                	ld	s4,16(sp)
    41dc:	6aa2                	ld	s5,8(sp)
    41de:	6b02                	ld	s6,0(sp)
    41e0:	6121                	addi	sp,sp,64
    41e2:	8082                	ret

00000000000041e4 <openiputtest>:
{
    41e4:	7179                	addi	sp,sp,-48
    41e6:	f406                	sd	ra,40(sp)
    41e8:	f022                	sd	s0,32(sp)
    41ea:	ec26                	sd	s1,24(sp)
    41ec:	1800                	addi	s0,sp,48
    41ee:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    41f0:	00004517          	auipc	a0,0x4
    41f4:	a6050513          	addi	a0,a0,-1440 # 7c50 <malloc+0x1c44>
    41f8:	00002097          	auipc	ra,0x2
    41fc:	a36080e7          	jalr	-1482(ra) # 5c2e <mkdir>
    4200:	04054263          	bltz	a0,4244 <openiputtest+0x60>
  pid = fork();
    4204:	00002097          	auipc	ra,0x2
    4208:	9ba080e7          	jalr	-1606(ra) # 5bbe <fork>
  if(pid < 0){
    420c:	04054a63          	bltz	a0,4260 <openiputtest+0x7c>
  if(pid == 0){
    4210:	e93d                	bnez	a0,4286 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    4212:	4589                	li	a1,2
    4214:	00004517          	auipc	a0,0x4
    4218:	a3c50513          	addi	a0,a0,-1476 # 7c50 <malloc+0x1c44>
    421c:	00002097          	auipc	ra,0x2
    4220:	9ea080e7          	jalr	-1558(ra) # 5c06 <open>
    if(fd >= 0){
    4224:	04054c63          	bltz	a0,427c <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    4228:	85a6                	mv	a1,s1
    422a:	00004517          	auipc	a0,0x4
    422e:	a4650513          	addi	a0,a0,-1466 # 7c70 <malloc+0x1c64>
    4232:	00002097          	auipc	ra,0x2
    4236:	d1c080e7          	jalr	-740(ra) # 5f4e <printf>
      exit(1);
    423a:	4505                	li	a0,1
    423c:	00002097          	auipc	ra,0x2
    4240:	98a080e7          	jalr	-1654(ra) # 5bc6 <exit>
    printf("%s: mkdir oidir failed\n", s);
    4244:	85a6                	mv	a1,s1
    4246:	00004517          	auipc	a0,0x4
    424a:	a1250513          	addi	a0,a0,-1518 # 7c58 <malloc+0x1c4c>
    424e:	00002097          	auipc	ra,0x2
    4252:	d00080e7          	jalr	-768(ra) # 5f4e <printf>
    exit(1);
    4256:	4505                	li	a0,1
    4258:	00002097          	auipc	ra,0x2
    425c:	96e080e7          	jalr	-1682(ra) # 5bc6 <exit>
    printf("%s: fork failed\n", s);
    4260:	85a6                	mv	a1,s1
    4262:	00002517          	auipc	a0,0x2
    4266:	76e50513          	addi	a0,a0,1902 # 69d0 <malloc+0x9c4>
    426a:	00002097          	auipc	ra,0x2
    426e:	ce4080e7          	jalr	-796(ra) # 5f4e <printf>
    exit(1);
    4272:	4505                	li	a0,1
    4274:	00002097          	auipc	ra,0x2
    4278:	952080e7          	jalr	-1710(ra) # 5bc6 <exit>
    exit(0);
    427c:	4501                	li	a0,0
    427e:	00002097          	auipc	ra,0x2
    4282:	948080e7          	jalr	-1720(ra) # 5bc6 <exit>
  sleep(1);
    4286:	4505                	li	a0,1
    4288:	00002097          	auipc	ra,0x2
    428c:	9ce080e7          	jalr	-1586(ra) # 5c56 <sleep>
  if(unlink("oidir") != 0){
    4290:	00004517          	auipc	a0,0x4
    4294:	9c050513          	addi	a0,a0,-1600 # 7c50 <malloc+0x1c44>
    4298:	00002097          	auipc	ra,0x2
    429c:	97e080e7          	jalr	-1666(ra) # 5c16 <unlink>
    42a0:	cd19                	beqz	a0,42be <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    42a2:	85a6                	mv	a1,s1
    42a4:	00003517          	auipc	a0,0x3
    42a8:	91c50513          	addi	a0,a0,-1764 # 6bc0 <malloc+0xbb4>
    42ac:	00002097          	auipc	ra,0x2
    42b0:	ca2080e7          	jalr	-862(ra) # 5f4e <printf>
    exit(1);
    42b4:	4505                	li	a0,1
    42b6:	00002097          	auipc	ra,0x2
    42ba:	910080e7          	jalr	-1776(ra) # 5bc6 <exit>
  wait(&xstatus);
    42be:	fdc40513          	addi	a0,s0,-36
    42c2:	00002097          	auipc	ra,0x2
    42c6:	90c080e7          	jalr	-1780(ra) # 5bce <wait>
  exit(xstatus);
    42ca:	fdc42503          	lw	a0,-36(s0)
    42ce:	00002097          	auipc	ra,0x2
    42d2:	8f8080e7          	jalr	-1800(ra) # 5bc6 <exit>

00000000000042d6 <forkforkfork>:
{
    42d6:	1101                	addi	sp,sp,-32
    42d8:	ec06                	sd	ra,24(sp)
    42da:	e822                	sd	s0,16(sp)
    42dc:	e426                	sd	s1,8(sp)
    42de:	1000                	addi	s0,sp,32
    42e0:	84aa                	mv	s1,a0
  unlink("stopforking");
    42e2:	00004517          	auipc	a0,0x4
    42e6:	9b650513          	addi	a0,a0,-1610 # 7c98 <malloc+0x1c8c>
    42ea:	00002097          	auipc	ra,0x2
    42ee:	92c080e7          	jalr	-1748(ra) # 5c16 <unlink>
  int pid = fork();
    42f2:	00002097          	auipc	ra,0x2
    42f6:	8cc080e7          	jalr	-1844(ra) # 5bbe <fork>
  if(pid < 0){
    42fa:	04054563          	bltz	a0,4344 <forkforkfork+0x6e>
  if(pid == 0){
    42fe:	c12d                	beqz	a0,4360 <forkforkfork+0x8a>
  sleep(20); // two seconds
    4300:	4551                	li	a0,20
    4302:	00002097          	auipc	ra,0x2
    4306:	954080e7          	jalr	-1708(ra) # 5c56 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    430a:	20200593          	li	a1,514
    430e:	00004517          	auipc	a0,0x4
    4312:	98a50513          	addi	a0,a0,-1654 # 7c98 <malloc+0x1c8c>
    4316:	00002097          	auipc	ra,0x2
    431a:	8f0080e7          	jalr	-1808(ra) # 5c06 <open>
    431e:	00002097          	auipc	ra,0x2
    4322:	8d0080e7          	jalr	-1840(ra) # 5bee <close>
  wait(0);
    4326:	4501                	li	a0,0
    4328:	00002097          	auipc	ra,0x2
    432c:	8a6080e7          	jalr	-1882(ra) # 5bce <wait>
  sleep(10); // one second
    4330:	4529                	li	a0,10
    4332:	00002097          	auipc	ra,0x2
    4336:	924080e7          	jalr	-1756(ra) # 5c56 <sleep>
}
    433a:	60e2                	ld	ra,24(sp)
    433c:	6442                	ld	s0,16(sp)
    433e:	64a2                	ld	s1,8(sp)
    4340:	6105                	addi	sp,sp,32
    4342:	8082                	ret
    printf("%s: fork failed", s);
    4344:	85a6                	mv	a1,s1
    4346:	00003517          	auipc	a0,0x3
    434a:	84a50513          	addi	a0,a0,-1974 # 6b90 <malloc+0xb84>
    434e:	00002097          	auipc	ra,0x2
    4352:	c00080e7          	jalr	-1024(ra) # 5f4e <printf>
    exit(1);
    4356:	4505                	li	a0,1
    4358:	00002097          	auipc	ra,0x2
    435c:	86e080e7          	jalr	-1938(ra) # 5bc6 <exit>
      int fd = open("stopforking", 0);
    4360:	00004497          	auipc	s1,0x4
    4364:	93848493          	addi	s1,s1,-1736 # 7c98 <malloc+0x1c8c>
    4368:	4581                	li	a1,0
    436a:	8526                	mv	a0,s1
    436c:	00002097          	auipc	ra,0x2
    4370:	89a080e7          	jalr	-1894(ra) # 5c06 <open>
      if(fd >= 0){
    4374:	02055463          	bgez	a0,439c <forkforkfork+0xc6>
      if(fork() < 0){
    4378:	00002097          	auipc	ra,0x2
    437c:	846080e7          	jalr	-1978(ra) # 5bbe <fork>
    4380:	fe0554e3          	bgez	a0,4368 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    4384:	20200593          	li	a1,514
    4388:	8526                	mv	a0,s1
    438a:	00002097          	auipc	ra,0x2
    438e:	87c080e7          	jalr	-1924(ra) # 5c06 <open>
    4392:	00002097          	auipc	ra,0x2
    4396:	85c080e7          	jalr	-1956(ra) # 5bee <close>
    439a:	b7f9                	j	4368 <forkforkfork+0x92>
        exit(0);
    439c:	4501                	li	a0,0
    439e:	00002097          	auipc	ra,0x2
    43a2:	828080e7          	jalr	-2008(ra) # 5bc6 <exit>

00000000000043a6 <killstatus>:
{
    43a6:	7139                	addi	sp,sp,-64
    43a8:	fc06                	sd	ra,56(sp)
    43aa:	f822                	sd	s0,48(sp)
    43ac:	f426                	sd	s1,40(sp)
    43ae:	f04a                	sd	s2,32(sp)
    43b0:	ec4e                	sd	s3,24(sp)
    43b2:	e852                	sd	s4,16(sp)
    43b4:	0080                	addi	s0,sp,64
    43b6:	8a2a                	mv	s4,a0
    43b8:	06400913          	li	s2,100
    if(xst != -1) {
    43bc:	59fd                	li	s3,-1
    int pid1 = fork();
    43be:	00002097          	auipc	ra,0x2
    43c2:	800080e7          	jalr	-2048(ra) # 5bbe <fork>
    43c6:	84aa                	mv	s1,a0
    if(pid1 < 0){
    43c8:	02054f63          	bltz	a0,4406 <killstatus+0x60>
    if(pid1 == 0){
    43cc:	c939                	beqz	a0,4422 <killstatus+0x7c>
    sleep(1);
    43ce:	4505                	li	a0,1
    43d0:	00002097          	auipc	ra,0x2
    43d4:	886080e7          	jalr	-1914(ra) # 5c56 <sleep>
    kill(pid1);
    43d8:	8526                	mv	a0,s1
    43da:	00002097          	auipc	ra,0x2
    43de:	81c080e7          	jalr	-2020(ra) # 5bf6 <kill>
    wait(&xst);
    43e2:	fcc40513          	addi	a0,s0,-52
    43e6:	00001097          	auipc	ra,0x1
    43ea:	7e8080e7          	jalr	2024(ra) # 5bce <wait>
    if(xst != -1) {
    43ee:	fcc42783          	lw	a5,-52(s0)
    43f2:	03379d63          	bne	a5,s3,442c <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    43f6:	397d                	addiw	s2,s2,-1
    43f8:	fc0913e3          	bnez	s2,43be <killstatus+0x18>
  exit(0);
    43fc:	4501                	li	a0,0
    43fe:	00001097          	auipc	ra,0x1
    4402:	7c8080e7          	jalr	1992(ra) # 5bc6 <exit>
      printf("%s: fork failed\n", s);
    4406:	85d2                	mv	a1,s4
    4408:	00002517          	auipc	a0,0x2
    440c:	5c850513          	addi	a0,a0,1480 # 69d0 <malloc+0x9c4>
    4410:	00002097          	auipc	ra,0x2
    4414:	b3e080e7          	jalr	-1218(ra) # 5f4e <printf>
      exit(1);
    4418:	4505                	li	a0,1
    441a:	00001097          	auipc	ra,0x1
    441e:	7ac080e7          	jalr	1964(ra) # 5bc6 <exit>
        getpid();
    4422:	00002097          	auipc	ra,0x2
    4426:	824080e7          	jalr	-2012(ra) # 5c46 <getpid>
      while(1) {
    442a:	bfe5                	j	4422 <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    442c:	85d2                	mv	a1,s4
    442e:	00004517          	auipc	a0,0x4
    4432:	87a50513          	addi	a0,a0,-1926 # 7ca8 <malloc+0x1c9c>
    4436:	00002097          	auipc	ra,0x2
    443a:	b18080e7          	jalr	-1256(ra) # 5f4e <printf>
       exit(1);
    443e:	4505                	li	a0,1
    4440:	00001097          	auipc	ra,0x1
    4444:	786080e7          	jalr	1926(ra) # 5bc6 <exit>

0000000000004448 <preempt>:
{
    4448:	7139                	addi	sp,sp,-64
    444a:	fc06                	sd	ra,56(sp)
    444c:	f822                	sd	s0,48(sp)
    444e:	f426                	sd	s1,40(sp)
    4450:	f04a                	sd	s2,32(sp)
    4452:	ec4e                	sd	s3,24(sp)
    4454:	e852                	sd	s4,16(sp)
    4456:	0080                	addi	s0,sp,64
    4458:	892a                	mv	s2,a0
  pid1 = fork();
    445a:	00001097          	auipc	ra,0x1
    445e:	764080e7          	jalr	1892(ra) # 5bbe <fork>
  if(pid1 < 0) {
    4462:	00054563          	bltz	a0,446c <preempt+0x24>
    4466:	84aa                	mv	s1,a0
  if(pid1 == 0)
    4468:	e105                	bnez	a0,4488 <preempt+0x40>
    for(;;)
    446a:	a001                	j	446a <preempt+0x22>
    printf("%s: fork failed", s);
    446c:	85ca                	mv	a1,s2
    446e:	00002517          	auipc	a0,0x2
    4472:	72250513          	addi	a0,a0,1826 # 6b90 <malloc+0xb84>
    4476:	00002097          	auipc	ra,0x2
    447a:	ad8080e7          	jalr	-1320(ra) # 5f4e <printf>
    exit(1);
    447e:	4505                	li	a0,1
    4480:	00001097          	auipc	ra,0x1
    4484:	746080e7          	jalr	1862(ra) # 5bc6 <exit>
  pid2 = fork();
    4488:	00001097          	auipc	ra,0x1
    448c:	736080e7          	jalr	1846(ra) # 5bbe <fork>
    4490:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    4492:	00054463          	bltz	a0,449a <preempt+0x52>
  if(pid2 == 0)
    4496:	e105                	bnez	a0,44b6 <preempt+0x6e>
    for(;;)
    4498:	a001                	j	4498 <preempt+0x50>
    printf("%s: fork failed\n", s);
    449a:	85ca                	mv	a1,s2
    449c:	00002517          	auipc	a0,0x2
    44a0:	53450513          	addi	a0,a0,1332 # 69d0 <malloc+0x9c4>
    44a4:	00002097          	auipc	ra,0x2
    44a8:	aaa080e7          	jalr	-1366(ra) # 5f4e <printf>
    exit(1);
    44ac:	4505                	li	a0,1
    44ae:	00001097          	auipc	ra,0x1
    44b2:	718080e7          	jalr	1816(ra) # 5bc6 <exit>
  pipe(pfds);
    44b6:	fc840513          	addi	a0,s0,-56
    44ba:	00001097          	auipc	ra,0x1
    44be:	71c080e7          	jalr	1820(ra) # 5bd6 <pipe>
  pid3 = fork();
    44c2:	00001097          	auipc	ra,0x1
    44c6:	6fc080e7          	jalr	1788(ra) # 5bbe <fork>
    44ca:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    44cc:	02054e63          	bltz	a0,4508 <preempt+0xc0>
  if(pid3 == 0){
    44d0:	e525                	bnez	a0,4538 <preempt+0xf0>
    close(pfds[0]);
    44d2:	fc842503          	lw	a0,-56(s0)
    44d6:	00001097          	auipc	ra,0x1
    44da:	718080e7          	jalr	1816(ra) # 5bee <close>
    if(write(pfds[1], "x", 1) != 1)
    44de:	4605                	li	a2,1
    44e0:	00002597          	auipc	a1,0x2
    44e4:	cd858593          	addi	a1,a1,-808 # 61b8 <malloc+0x1ac>
    44e8:	fcc42503          	lw	a0,-52(s0)
    44ec:	00001097          	auipc	ra,0x1
    44f0:	6fa080e7          	jalr	1786(ra) # 5be6 <write>
    44f4:	4785                	li	a5,1
    44f6:	02f51763          	bne	a0,a5,4524 <preempt+0xdc>
    close(pfds[1]);
    44fa:	fcc42503          	lw	a0,-52(s0)
    44fe:	00001097          	auipc	ra,0x1
    4502:	6f0080e7          	jalr	1776(ra) # 5bee <close>
    for(;;)
    4506:	a001                	j	4506 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4508:	85ca                	mv	a1,s2
    450a:	00002517          	auipc	a0,0x2
    450e:	4c650513          	addi	a0,a0,1222 # 69d0 <malloc+0x9c4>
    4512:	00002097          	auipc	ra,0x2
    4516:	a3c080e7          	jalr	-1476(ra) # 5f4e <printf>
     exit(1);
    451a:	4505                	li	a0,1
    451c:	00001097          	auipc	ra,0x1
    4520:	6aa080e7          	jalr	1706(ra) # 5bc6 <exit>
      printf("%s: preempt write error", s);
    4524:	85ca                	mv	a1,s2
    4526:	00003517          	auipc	a0,0x3
    452a:	7a250513          	addi	a0,a0,1954 # 7cc8 <malloc+0x1cbc>
    452e:	00002097          	auipc	ra,0x2
    4532:	a20080e7          	jalr	-1504(ra) # 5f4e <printf>
    4536:	b7d1                	j	44fa <preempt+0xb2>
  close(pfds[1]);
    4538:	fcc42503          	lw	a0,-52(s0)
    453c:	00001097          	auipc	ra,0x1
    4540:	6b2080e7          	jalr	1714(ra) # 5bee <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4544:	660d                	lui	a2,0x3
    4546:	00008597          	auipc	a1,0x8
    454a:	71258593          	addi	a1,a1,1810 # cc58 <buf>
    454e:	fc842503          	lw	a0,-56(s0)
    4552:	00001097          	auipc	ra,0x1
    4556:	68c080e7          	jalr	1676(ra) # 5bde <read>
    455a:	4785                	li	a5,1
    455c:	02f50363          	beq	a0,a5,4582 <preempt+0x13a>
    printf("%s: preempt read error", s);
    4560:	85ca                	mv	a1,s2
    4562:	00003517          	auipc	a0,0x3
    4566:	77e50513          	addi	a0,a0,1918 # 7ce0 <malloc+0x1cd4>
    456a:	00002097          	auipc	ra,0x2
    456e:	9e4080e7          	jalr	-1564(ra) # 5f4e <printf>
}
    4572:	70e2                	ld	ra,56(sp)
    4574:	7442                	ld	s0,48(sp)
    4576:	74a2                	ld	s1,40(sp)
    4578:	7902                	ld	s2,32(sp)
    457a:	69e2                	ld	s3,24(sp)
    457c:	6a42                	ld	s4,16(sp)
    457e:	6121                	addi	sp,sp,64
    4580:	8082                	ret
  close(pfds[0]);
    4582:	fc842503          	lw	a0,-56(s0)
    4586:	00001097          	auipc	ra,0x1
    458a:	668080e7          	jalr	1640(ra) # 5bee <close>
  printf("kill... ");
    458e:	00003517          	auipc	a0,0x3
    4592:	76a50513          	addi	a0,a0,1898 # 7cf8 <malloc+0x1cec>
    4596:	00002097          	auipc	ra,0x2
    459a:	9b8080e7          	jalr	-1608(ra) # 5f4e <printf>
  kill(pid1);
    459e:	8526                	mv	a0,s1
    45a0:	00001097          	auipc	ra,0x1
    45a4:	656080e7          	jalr	1622(ra) # 5bf6 <kill>
  kill(pid2);
    45a8:	854e                	mv	a0,s3
    45aa:	00001097          	auipc	ra,0x1
    45ae:	64c080e7          	jalr	1612(ra) # 5bf6 <kill>
  kill(pid3);
    45b2:	8552                	mv	a0,s4
    45b4:	00001097          	auipc	ra,0x1
    45b8:	642080e7          	jalr	1602(ra) # 5bf6 <kill>
  printf("wait... ");
    45bc:	00003517          	auipc	a0,0x3
    45c0:	74c50513          	addi	a0,a0,1868 # 7d08 <malloc+0x1cfc>
    45c4:	00002097          	auipc	ra,0x2
    45c8:	98a080e7          	jalr	-1654(ra) # 5f4e <printf>
  wait(0);
    45cc:	4501                	li	a0,0
    45ce:	00001097          	auipc	ra,0x1
    45d2:	600080e7          	jalr	1536(ra) # 5bce <wait>
  wait(0);
    45d6:	4501                	li	a0,0
    45d8:	00001097          	auipc	ra,0x1
    45dc:	5f6080e7          	jalr	1526(ra) # 5bce <wait>
  wait(0);
    45e0:	4501                	li	a0,0
    45e2:	00001097          	auipc	ra,0x1
    45e6:	5ec080e7          	jalr	1516(ra) # 5bce <wait>
    45ea:	b761                	j	4572 <preempt+0x12a>

00000000000045ec <reparent>:
{
    45ec:	7179                	addi	sp,sp,-48
    45ee:	f406                	sd	ra,40(sp)
    45f0:	f022                	sd	s0,32(sp)
    45f2:	ec26                	sd	s1,24(sp)
    45f4:	e84a                	sd	s2,16(sp)
    45f6:	e44e                	sd	s3,8(sp)
    45f8:	e052                	sd	s4,0(sp)
    45fa:	1800                	addi	s0,sp,48
    45fc:	89aa                	mv	s3,a0
  int master_pid = getpid();
    45fe:	00001097          	auipc	ra,0x1
    4602:	648080e7          	jalr	1608(ra) # 5c46 <getpid>
    4606:	8a2a                	mv	s4,a0
    4608:	0c800913          	li	s2,200
    int pid = fork();
    460c:	00001097          	auipc	ra,0x1
    4610:	5b2080e7          	jalr	1458(ra) # 5bbe <fork>
    4614:	84aa                	mv	s1,a0
    if(pid < 0){
    4616:	02054263          	bltz	a0,463a <reparent+0x4e>
    if(pid){
    461a:	cd21                	beqz	a0,4672 <reparent+0x86>
      if(wait(0) != pid){
    461c:	4501                	li	a0,0
    461e:	00001097          	auipc	ra,0x1
    4622:	5b0080e7          	jalr	1456(ra) # 5bce <wait>
    4626:	02951863          	bne	a0,s1,4656 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    462a:	397d                	addiw	s2,s2,-1
    462c:	fe0910e3          	bnez	s2,460c <reparent+0x20>
  exit(0);
    4630:	4501                	li	a0,0
    4632:	00001097          	auipc	ra,0x1
    4636:	594080e7          	jalr	1428(ra) # 5bc6 <exit>
      printf("%s: fork failed\n", s);
    463a:	85ce                	mv	a1,s3
    463c:	00002517          	auipc	a0,0x2
    4640:	39450513          	addi	a0,a0,916 # 69d0 <malloc+0x9c4>
    4644:	00002097          	auipc	ra,0x2
    4648:	90a080e7          	jalr	-1782(ra) # 5f4e <printf>
      exit(1);
    464c:	4505                	li	a0,1
    464e:	00001097          	auipc	ra,0x1
    4652:	578080e7          	jalr	1400(ra) # 5bc6 <exit>
        printf("%s: wait wrong pid\n", s);
    4656:	85ce                	mv	a1,s3
    4658:	00002517          	auipc	a0,0x2
    465c:	50050513          	addi	a0,a0,1280 # 6b58 <malloc+0xb4c>
    4660:	00002097          	auipc	ra,0x2
    4664:	8ee080e7          	jalr	-1810(ra) # 5f4e <printf>
        exit(1);
    4668:	4505                	li	a0,1
    466a:	00001097          	auipc	ra,0x1
    466e:	55c080e7          	jalr	1372(ra) # 5bc6 <exit>
      int pid2 = fork();
    4672:	00001097          	auipc	ra,0x1
    4676:	54c080e7          	jalr	1356(ra) # 5bbe <fork>
      if(pid2 < 0){
    467a:	00054763          	bltz	a0,4688 <reparent+0x9c>
      exit(0);
    467e:	4501                	li	a0,0
    4680:	00001097          	auipc	ra,0x1
    4684:	546080e7          	jalr	1350(ra) # 5bc6 <exit>
        kill(master_pid);
    4688:	8552                	mv	a0,s4
    468a:	00001097          	auipc	ra,0x1
    468e:	56c080e7          	jalr	1388(ra) # 5bf6 <kill>
        exit(1);
    4692:	4505                	li	a0,1
    4694:	00001097          	auipc	ra,0x1
    4698:	532080e7          	jalr	1330(ra) # 5bc6 <exit>

000000000000469c <sbrkfail>:
{
    469c:	7119                	addi	sp,sp,-128
    469e:	fc86                	sd	ra,120(sp)
    46a0:	f8a2                	sd	s0,112(sp)
    46a2:	f4a6                	sd	s1,104(sp)
    46a4:	f0ca                	sd	s2,96(sp)
    46a6:	ecce                	sd	s3,88(sp)
    46a8:	e8d2                	sd	s4,80(sp)
    46aa:	e4d6                	sd	s5,72(sp)
    46ac:	0100                	addi	s0,sp,128
    46ae:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    46b0:	fb040513          	addi	a0,s0,-80
    46b4:	00001097          	auipc	ra,0x1
    46b8:	522080e7          	jalr	1314(ra) # 5bd6 <pipe>
    46bc:	e901                	bnez	a0,46cc <sbrkfail+0x30>
    46be:	f8040493          	addi	s1,s0,-128
    46c2:	fa840993          	addi	s3,s0,-88
    46c6:	8926                	mv	s2,s1
    if(pids[i] != -1)
    46c8:	5a7d                	li	s4,-1
    46ca:	a085                	j	472a <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    46cc:	85d6                	mv	a1,s5
    46ce:	00002517          	auipc	a0,0x2
    46d2:	40a50513          	addi	a0,a0,1034 # 6ad8 <malloc+0xacc>
    46d6:	00002097          	auipc	ra,0x2
    46da:	878080e7          	jalr	-1928(ra) # 5f4e <printf>
    exit(1);
    46de:	4505                	li	a0,1
    46e0:	00001097          	auipc	ra,0x1
    46e4:	4e6080e7          	jalr	1254(ra) # 5bc6 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    46e8:	00001097          	auipc	ra,0x1
    46ec:	566080e7          	jalr	1382(ra) # 5c4e <sbrk>
    46f0:	064007b7          	lui	a5,0x6400
    46f4:	40a7853b          	subw	a0,a5,a0
    46f8:	00001097          	auipc	ra,0x1
    46fc:	556080e7          	jalr	1366(ra) # 5c4e <sbrk>
      write(fds[1], "x", 1);
    4700:	4605                	li	a2,1
    4702:	00002597          	auipc	a1,0x2
    4706:	ab658593          	addi	a1,a1,-1354 # 61b8 <malloc+0x1ac>
    470a:	fb442503          	lw	a0,-76(s0)
    470e:	00001097          	auipc	ra,0x1
    4712:	4d8080e7          	jalr	1240(ra) # 5be6 <write>
      for(;;) sleep(1000);
    4716:	3e800513          	li	a0,1000
    471a:	00001097          	auipc	ra,0x1
    471e:	53c080e7          	jalr	1340(ra) # 5c56 <sleep>
    4722:	bfd5                	j	4716 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4724:	0911                	addi	s2,s2,4
    4726:	03390563          	beq	s2,s3,4750 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    472a:	00001097          	auipc	ra,0x1
    472e:	494080e7          	jalr	1172(ra) # 5bbe <fork>
    4732:	00a92023          	sw	a0,0(s2)
    4736:	d94d                	beqz	a0,46e8 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4738:	ff4506e3          	beq	a0,s4,4724 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    473c:	4605                	li	a2,1
    473e:	faf40593          	addi	a1,s0,-81
    4742:	fb042503          	lw	a0,-80(s0)
    4746:	00001097          	auipc	ra,0x1
    474a:	498080e7          	jalr	1176(ra) # 5bde <read>
    474e:	bfd9                	j	4724 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    4750:	6505                	lui	a0,0x1
    4752:	00001097          	auipc	ra,0x1
    4756:	4fc080e7          	jalr	1276(ra) # 5c4e <sbrk>
    475a:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    475c:	597d                	li	s2,-1
    475e:	a021                	j	4766 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4760:	0491                	addi	s1,s1,4
    4762:	01348f63          	beq	s1,s3,4780 <sbrkfail+0xe4>
    if(pids[i] == -1)
    4766:	4088                	lw	a0,0(s1)
    4768:	ff250ce3          	beq	a0,s2,4760 <sbrkfail+0xc4>
    kill(pids[i]);
    476c:	00001097          	auipc	ra,0x1
    4770:	48a080e7          	jalr	1162(ra) # 5bf6 <kill>
    wait(0);
    4774:	4501                	li	a0,0
    4776:	00001097          	auipc	ra,0x1
    477a:	458080e7          	jalr	1112(ra) # 5bce <wait>
    477e:	b7cd                	j	4760 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    4780:	57fd                	li	a5,-1
    4782:	04fa0163          	beq	s4,a5,47c4 <sbrkfail+0x128>
  pid = fork();
    4786:	00001097          	auipc	ra,0x1
    478a:	438080e7          	jalr	1080(ra) # 5bbe <fork>
    478e:	84aa                	mv	s1,a0
  if(pid < 0){
    4790:	04054863          	bltz	a0,47e0 <sbrkfail+0x144>
  if(pid == 0){
    4794:	c525                	beqz	a0,47fc <sbrkfail+0x160>
  wait(&xstatus);
    4796:	fbc40513          	addi	a0,s0,-68
    479a:	00001097          	auipc	ra,0x1
    479e:	434080e7          	jalr	1076(ra) # 5bce <wait>
  if(xstatus != -1 && xstatus != 2)
    47a2:	fbc42783          	lw	a5,-68(s0)
    47a6:	577d                	li	a4,-1
    47a8:	00e78563          	beq	a5,a4,47b2 <sbrkfail+0x116>
    47ac:	4709                	li	a4,2
    47ae:	08e79d63          	bne	a5,a4,4848 <sbrkfail+0x1ac>
}
    47b2:	70e6                	ld	ra,120(sp)
    47b4:	7446                	ld	s0,112(sp)
    47b6:	74a6                	ld	s1,104(sp)
    47b8:	7906                	ld	s2,96(sp)
    47ba:	69e6                	ld	s3,88(sp)
    47bc:	6a46                	ld	s4,80(sp)
    47be:	6aa6                	ld	s5,72(sp)
    47c0:	6109                	addi	sp,sp,128
    47c2:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    47c4:	85d6                	mv	a1,s5
    47c6:	00003517          	auipc	a0,0x3
    47ca:	55250513          	addi	a0,a0,1362 # 7d18 <malloc+0x1d0c>
    47ce:	00001097          	auipc	ra,0x1
    47d2:	780080e7          	jalr	1920(ra) # 5f4e <printf>
    exit(1);
    47d6:	4505                	li	a0,1
    47d8:	00001097          	auipc	ra,0x1
    47dc:	3ee080e7          	jalr	1006(ra) # 5bc6 <exit>
    printf("%s: fork failed\n", s);
    47e0:	85d6                	mv	a1,s5
    47e2:	00002517          	auipc	a0,0x2
    47e6:	1ee50513          	addi	a0,a0,494 # 69d0 <malloc+0x9c4>
    47ea:	00001097          	auipc	ra,0x1
    47ee:	764080e7          	jalr	1892(ra) # 5f4e <printf>
    exit(1);
    47f2:	4505                	li	a0,1
    47f4:	00001097          	auipc	ra,0x1
    47f8:	3d2080e7          	jalr	978(ra) # 5bc6 <exit>
    a = sbrk(0);
    47fc:	4501                	li	a0,0
    47fe:	00001097          	auipc	ra,0x1
    4802:	450080e7          	jalr	1104(ra) # 5c4e <sbrk>
    4806:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4808:	3e800537          	lui	a0,0x3e800
    480c:	00001097          	auipc	ra,0x1
    4810:	442080e7          	jalr	1090(ra) # 5c4e <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4814:	87ca                	mv	a5,s2
    4816:	3e800737          	lui	a4,0x3e800
    481a:	993a                	add	s2,s2,a4
    481c:	6705                	lui	a4,0x1
      n += *(a+i);
    481e:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f03a8>
    4822:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4824:	97ba                	add	a5,a5,a4
    4826:	ff279ce3          	bne	a5,s2,481e <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    482a:	8626                	mv	a2,s1
    482c:	85d6                	mv	a1,s5
    482e:	00003517          	auipc	a0,0x3
    4832:	50a50513          	addi	a0,a0,1290 # 7d38 <malloc+0x1d2c>
    4836:	00001097          	auipc	ra,0x1
    483a:	718080e7          	jalr	1816(ra) # 5f4e <printf>
    exit(1);
    483e:	4505                	li	a0,1
    4840:	00001097          	auipc	ra,0x1
    4844:	386080e7          	jalr	902(ra) # 5bc6 <exit>
    exit(1);
    4848:	4505                	li	a0,1
    484a:	00001097          	auipc	ra,0x1
    484e:	37c080e7          	jalr	892(ra) # 5bc6 <exit>

0000000000004852 <mem>:
{
    4852:	7139                	addi	sp,sp,-64
    4854:	fc06                	sd	ra,56(sp)
    4856:	f822                	sd	s0,48(sp)
    4858:	f426                	sd	s1,40(sp)
    485a:	f04a                	sd	s2,32(sp)
    485c:	ec4e                	sd	s3,24(sp)
    485e:	0080                	addi	s0,sp,64
    4860:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    4862:	00001097          	auipc	ra,0x1
    4866:	35c080e7          	jalr	860(ra) # 5bbe <fork>
    m1 = 0;
    486a:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    486c:	6909                	lui	s2,0x2
    486e:	71190913          	addi	s2,s2,1809 # 2711 <rwsbrk+0x65>
  if((pid = fork()) == 0){
    4872:	c115                	beqz	a0,4896 <mem+0x44>
    wait(&xstatus);
    4874:	fcc40513          	addi	a0,s0,-52
    4878:	00001097          	auipc	ra,0x1
    487c:	356080e7          	jalr	854(ra) # 5bce <wait>
    if(xstatus == -1){
    4880:	fcc42503          	lw	a0,-52(s0)
    4884:	57fd                	li	a5,-1
    4886:	06f50363          	beq	a0,a5,48ec <mem+0x9a>
    exit(xstatus);
    488a:	00001097          	auipc	ra,0x1
    488e:	33c080e7          	jalr	828(ra) # 5bc6 <exit>
      *(char**)m2 = m1;
    4892:	e104                	sd	s1,0(a0)
      m1 = m2;
    4894:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4896:	854a                	mv	a0,s2
    4898:	00001097          	auipc	ra,0x1
    489c:	774080e7          	jalr	1908(ra) # 600c <malloc>
    48a0:	f96d                	bnez	a0,4892 <mem+0x40>
    while(m1){
    48a2:	c881                	beqz	s1,48b2 <mem+0x60>
      m2 = *(char**)m1;
    48a4:	8526                	mv	a0,s1
    48a6:	6084                	ld	s1,0(s1)
      free(m1);
    48a8:	00001097          	auipc	ra,0x1
    48ac:	6dc080e7          	jalr	1756(ra) # 5f84 <free>
    while(m1){
    48b0:	f8f5                	bnez	s1,48a4 <mem+0x52>
    m1 = malloc(1024*20);
    48b2:	6515                	lui	a0,0x5
    48b4:	00001097          	auipc	ra,0x1
    48b8:	758080e7          	jalr	1880(ra) # 600c <malloc>
    if(m1 == 0){
    48bc:	c911                	beqz	a0,48d0 <mem+0x7e>
    free(m1);
    48be:	00001097          	auipc	ra,0x1
    48c2:	6c6080e7          	jalr	1734(ra) # 5f84 <free>
    exit(0);
    48c6:	4501                	li	a0,0
    48c8:	00001097          	auipc	ra,0x1
    48cc:	2fe080e7          	jalr	766(ra) # 5bc6 <exit>
      printf("couldn't allocate mem?!!\n", s);
    48d0:	85ce                	mv	a1,s3
    48d2:	00003517          	auipc	a0,0x3
    48d6:	49650513          	addi	a0,a0,1174 # 7d68 <malloc+0x1d5c>
    48da:	00001097          	auipc	ra,0x1
    48de:	674080e7          	jalr	1652(ra) # 5f4e <printf>
      exit(1);
    48e2:	4505                	li	a0,1
    48e4:	00001097          	auipc	ra,0x1
    48e8:	2e2080e7          	jalr	738(ra) # 5bc6 <exit>
      exit(0);
    48ec:	4501                	li	a0,0
    48ee:	00001097          	auipc	ra,0x1
    48f2:	2d8080e7          	jalr	728(ra) # 5bc6 <exit>

00000000000048f6 <sharedfd>:
{
    48f6:	7159                	addi	sp,sp,-112
    48f8:	f486                	sd	ra,104(sp)
    48fa:	f0a2                	sd	s0,96(sp)
    48fc:	eca6                	sd	s1,88(sp)
    48fe:	e8ca                	sd	s2,80(sp)
    4900:	e4ce                	sd	s3,72(sp)
    4902:	e0d2                	sd	s4,64(sp)
    4904:	fc56                	sd	s5,56(sp)
    4906:	f85a                	sd	s6,48(sp)
    4908:	f45e                	sd	s7,40(sp)
    490a:	1880                	addi	s0,sp,112
    490c:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    490e:	00003517          	auipc	a0,0x3
    4912:	47a50513          	addi	a0,a0,1146 # 7d88 <malloc+0x1d7c>
    4916:	00001097          	auipc	ra,0x1
    491a:	300080e7          	jalr	768(ra) # 5c16 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    491e:	20200593          	li	a1,514
    4922:	00003517          	auipc	a0,0x3
    4926:	46650513          	addi	a0,a0,1126 # 7d88 <malloc+0x1d7c>
    492a:	00001097          	auipc	ra,0x1
    492e:	2dc080e7          	jalr	732(ra) # 5c06 <open>
  if(fd < 0){
    4932:	04054a63          	bltz	a0,4986 <sharedfd+0x90>
    4936:	892a                	mv	s2,a0
  pid = fork();
    4938:	00001097          	auipc	ra,0x1
    493c:	286080e7          	jalr	646(ra) # 5bbe <fork>
    4940:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4942:	06300593          	li	a1,99
    4946:	c119                	beqz	a0,494c <sharedfd+0x56>
    4948:	07000593          	li	a1,112
    494c:	4629                	li	a2,10
    494e:	fa040513          	addi	a0,s0,-96
    4952:	00001097          	auipc	ra,0x1
    4956:	078080e7          	jalr	120(ra) # 59ca <memset>
    495a:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    495e:	4629                	li	a2,10
    4960:	fa040593          	addi	a1,s0,-96
    4964:	854a                	mv	a0,s2
    4966:	00001097          	auipc	ra,0x1
    496a:	280080e7          	jalr	640(ra) # 5be6 <write>
    496e:	47a9                	li	a5,10
    4970:	02f51963          	bne	a0,a5,49a2 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4974:	34fd                	addiw	s1,s1,-1
    4976:	f4e5                	bnez	s1,495e <sharedfd+0x68>
  if(pid == 0) {
    4978:	04099363          	bnez	s3,49be <sharedfd+0xc8>
    exit(0);
    497c:	4501                	li	a0,0
    497e:	00001097          	auipc	ra,0x1
    4982:	248080e7          	jalr	584(ra) # 5bc6 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4986:	85d2                	mv	a1,s4
    4988:	00003517          	auipc	a0,0x3
    498c:	41050513          	addi	a0,a0,1040 # 7d98 <malloc+0x1d8c>
    4990:	00001097          	auipc	ra,0x1
    4994:	5be080e7          	jalr	1470(ra) # 5f4e <printf>
    exit(1);
    4998:	4505                	li	a0,1
    499a:	00001097          	auipc	ra,0x1
    499e:	22c080e7          	jalr	556(ra) # 5bc6 <exit>
      printf("%s: write sharedfd failed\n", s);
    49a2:	85d2                	mv	a1,s4
    49a4:	00003517          	auipc	a0,0x3
    49a8:	41c50513          	addi	a0,a0,1052 # 7dc0 <malloc+0x1db4>
    49ac:	00001097          	auipc	ra,0x1
    49b0:	5a2080e7          	jalr	1442(ra) # 5f4e <printf>
      exit(1);
    49b4:	4505                	li	a0,1
    49b6:	00001097          	auipc	ra,0x1
    49ba:	210080e7          	jalr	528(ra) # 5bc6 <exit>
    wait(&xstatus);
    49be:	f9c40513          	addi	a0,s0,-100
    49c2:	00001097          	auipc	ra,0x1
    49c6:	20c080e7          	jalr	524(ra) # 5bce <wait>
    if(xstatus != 0)
    49ca:	f9c42983          	lw	s3,-100(s0)
    49ce:	00098763          	beqz	s3,49dc <sharedfd+0xe6>
      exit(xstatus);
    49d2:	854e                	mv	a0,s3
    49d4:	00001097          	auipc	ra,0x1
    49d8:	1f2080e7          	jalr	498(ra) # 5bc6 <exit>
  close(fd);
    49dc:	854a                	mv	a0,s2
    49de:	00001097          	auipc	ra,0x1
    49e2:	210080e7          	jalr	528(ra) # 5bee <close>
  fd = open("sharedfd", 0);
    49e6:	4581                	li	a1,0
    49e8:	00003517          	auipc	a0,0x3
    49ec:	3a050513          	addi	a0,a0,928 # 7d88 <malloc+0x1d7c>
    49f0:	00001097          	auipc	ra,0x1
    49f4:	216080e7          	jalr	534(ra) # 5c06 <open>
    49f8:	8baa                	mv	s7,a0
  nc = np = 0;
    49fa:	8ace                	mv	s5,s3
  if(fd < 0){
    49fc:	02054563          	bltz	a0,4a26 <sharedfd+0x130>
    4a00:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4a04:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4a08:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4a0c:	4629                	li	a2,10
    4a0e:	fa040593          	addi	a1,s0,-96
    4a12:	855e                	mv	a0,s7
    4a14:	00001097          	auipc	ra,0x1
    4a18:	1ca080e7          	jalr	458(ra) # 5bde <read>
    4a1c:	02a05f63          	blez	a0,4a5a <sharedfd+0x164>
    4a20:	fa040793          	addi	a5,s0,-96
    4a24:	a01d                	j	4a4a <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4a26:	85d2                	mv	a1,s4
    4a28:	00003517          	auipc	a0,0x3
    4a2c:	3b850513          	addi	a0,a0,952 # 7de0 <malloc+0x1dd4>
    4a30:	00001097          	auipc	ra,0x1
    4a34:	51e080e7          	jalr	1310(ra) # 5f4e <printf>
    exit(1);
    4a38:	4505                	li	a0,1
    4a3a:	00001097          	auipc	ra,0x1
    4a3e:	18c080e7          	jalr	396(ra) # 5bc6 <exit>
        nc++;
    4a42:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4a44:	0785                	addi	a5,a5,1
    4a46:	fd2783e3          	beq	a5,s2,4a0c <sharedfd+0x116>
      if(buf[i] == 'c')
    4a4a:	0007c703          	lbu	a4,0(a5)
    4a4e:	fe970ae3          	beq	a4,s1,4a42 <sharedfd+0x14c>
      if(buf[i] == 'p')
    4a52:	ff6719e3          	bne	a4,s6,4a44 <sharedfd+0x14e>
        np++;
    4a56:	2a85                	addiw	s5,s5,1
    4a58:	b7f5                	j	4a44 <sharedfd+0x14e>
  close(fd);
    4a5a:	855e                	mv	a0,s7
    4a5c:	00001097          	auipc	ra,0x1
    4a60:	192080e7          	jalr	402(ra) # 5bee <close>
  unlink("sharedfd");
    4a64:	00003517          	auipc	a0,0x3
    4a68:	32450513          	addi	a0,a0,804 # 7d88 <malloc+0x1d7c>
    4a6c:	00001097          	auipc	ra,0x1
    4a70:	1aa080e7          	jalr	426(ra) # 5c16 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4a74:	6789                	lui	a5,0x2
    4a76:	71078793          	addi	a5,a5,1808 # 2710 <rwsbrk+0x64>
    4a7a:	00f99763          	bne	s3,a5,4a88 <sharedfd+0x192>
    4a7e:	6789                	lui	a5,0x2
    4a80:	71078793          	addi	a5,a5,1808 # 2710 <rwsbrk+0x64>
    4a84:	02fa8063          	beq	s5,a5,4aa4 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4a88:	85d2                	mv	a1,s4
    4a8a:	00003517          	auipc	a0,0x3
    4a8e:	37e50513          	addi	a0,a0,894 # 7e08 <malloc+0x1dfc>
    4a92:	00001097          	auipc	ra,0x1
    4a96:	4bc080e7          	jalr	1212(ra) # 5f4e <printf>
    exit(1);
    4a9a:	4505                	li	a0,1
    4a9c:	00001097          	auipc	ra,0x1
    4aa0:	12a080e7          	jalr	298(ra) # 5bc6 <exit>
    exit(0);
    4aa4:	4501                	li	a0,0
    4aa6:	00001097          	auipc	ra,0x1
    4aaa:	120080e7          	jalr	288(ra) # 5bc6 <exit>

0000000000004aae <fourfiles>:
{
    4aae:	7171                	addi	sp,sp,-176
    4ab0:	f506                	sd	ra,168(sp)
    4ab2:	f122                	sd	s0,160(sp)
    4ab4:	ed26                	sd	s1,152(sp)
    4ab6:	e94a                	sd	s2,144(sp)
    4ab8:	e54e                	sd	s3,136(sp)
    4aba:	e152                	sd	s4,128(sp)
    4abc:	fcd6                	sd	s5,120(sp)
    4abe:	f8da                	sd	s6,112(sp)
    4ac0:	f4de                	sd	s7,104(sp)
    4ac2:	f0e2                	sd	s8,96(sp)
    4ac4:	ece6                	sd	s9,88(sp)
    4ac6:	e8ea                	sd	s10,80(sp)
    4ac8:	e4ee                	sd	s11,72(sp)
    4aca:	1900                	addi	s0,sp,176
    4acc:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    4ad0:	00001797          	auipc	a5,0x1
    4ad4:	62078793          	addi	a5,a5,1568 # 60f0 <malloc+0xe4>
    4ad8:	f6f43823          	sd	a5,-144(s0)
    4adc:	00001797          	auipc	a5,0x1
    4ae0:	61c78793          	addi	a5,a5,1564 # 60f8 <malloc+0xec>
    4ae4:	f6f43c23          	sd	a5,-136(s0)
    4ae8:	00001797          	auipc	a5,0x1
    4aec:	61878793          	addi	a5,a5,1560 # 6100 <malloc+0xf4>
    4af0:	f8f43023          	sd	a5,-128(s0)
    4af4:	00001797          	auipc	a5,0x1
    4af8:	61478793          	addi	a5,a5,1556 # 6108 <malloc+0xfc>
    4afc:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4b00:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4b04:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    4b06:	4481                	li	s1,0
    4b08:	4a11                	li	s4,4
    fname = names[pi];
    4b0a:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4b0e:	854e                	mv	a0,s3
    4b10:	00001097          	auipc	ra,0x1
    4b14:	106080e7          	jalr	262(ra) # 5c16 <unlink>
    pid = fork();
    4b18:	00001097          	auipc	ra,0x1
    4b1c:	0a6080e7          	jalr	166(ra) # 5bbe <fork>
    if(pid < 0){
    4b20:	04054463          	bltz	a0,4b68 <fourfiles+0xba>
    if(pid == 0){
    4b24:	c12d                	beqz	a0,4b86 <fourfiles+0xd8>
  for(pi = 0; pi < NCHILD; pi++){
    4b26:	2485                	addiw	s1,s1,1
    4b28:	0921                	addi	s2,s2,8
    4b2a:	ff4490e3          	bne	s1,s4,4b0a <fourfiles+0x5c>
    4b2e:	4491                	li	s1,4
    wait(&xstatus);
    4b30:	f6c40513          	addi	a0,s0,-148
    4b34:	00001097          	auipc	ra,0x1
    4b38:	09a080e7          	jalr	154(ra) # 5bce <wait>
    if(xstatus != 0)
    4b3c:	f6c42b03          	lw	s6,-148(s0)
    4b40:	0c0b1e63          	bnez	s6,4c1c <fourfiles+0x16e>
  for(pi = 0; pi < NCHILD; pi++){
    4b44:	34fd                	addiw	s1,s1,-1
    4b46:	f4ed                	bnez	s1,4b30 <fourfiles+0x82>
    4b48:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4b4c:	00008a17          	auipc	s4,0x8
    4b50:	10ca0a13          	addi	s4,s4,268 # cc58 <buf>
    4b54:	00008a97          	auipc	s5,0x8
    4b58:	105a8a93          	addi	s5,s5,261 # cc59 <buf+0x1>
    if(total != N*SZ){
    4b5c:	6d85                	lui	s11,0x1
    4b5e:	770d8d93          	addi	s11,s11,1904 # 1770 <exectest+0x2e>
  for(i = 0; i < NCHILD; i++){
    4b62:	03400d13          	li	s10,52
    4b66:	aa1d                	j	4c9c <fourfiles+0x1ee>
      printf("fork failed\n", s);
    4b68:	f5843583          	ld	a1,-168(s0)
    4b6c:	00002517          	auipc	a0,0x2
    4b70:	25450513          	addi	a0,a0,596 # 6dc0 <malloc+0xdb4>
    4b74:	00001097          	auipc	ra,0x1
    4b78:	3da080e7          	jalr	986(ra) # 5f4e <printf>
      exit(1);
    4b7c:	4505                	li	a0,1
    4b7e:	00001097          	auipc	ra,0x1
    4b82:	048080e7          	jalr	72(ra) # 5bc6 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4b86:	20200593          	li	a1,514
    4b8a:	854e                	mv	a0,s3
    4b8c:	00001097          	auipc	ra,0x1
    4b90:	07a080e7          	jalr	122(ra) # 5c06 <open>
    4b94:	892a                	mv	s2,a0
      if(fd < 0){
    4b96:	04054763          	bltz	a0,4be4 <fourfiles+0x136>
      memset(buf, '0'+pi, SZ);
    4b9a:	1f400613          	li	a2,500
    4b9e:	0304859b          	addiw	a1,s1,48
    4ba2:	00008517          	auipc	a0,0x8
    4ba6:	0b650513          	addi	a0,a0,182 # cc58 <buf>
    4baa:	00001097          	auipc	ra,0x1
    4bae:	e20080e7          	jalr	-480(ra) # 59ca <memset>
    4bb2:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4bb4:	00008997          	auipc	s3,0x8
    4bb8:	0a498993          	addi	s3,s3,164 # cc58 <buf>
    4bbc:	1f400613          	li	a2,500
    4bc0:	85ce                	mv	a1,s3
    4bc2:	854a                	mv	a0,s2
    4bc4:	00001097          	auipc	ra,0x1
    4bc8:	022080e7          	jalr	34(ra) # 5be6 <write>
    4bcc:	85aa                	mv	a1,a0
    4bce:	1f400793          	li	a5,500
    4bd2:	02f51863          	bne	a0,a5,4c02 <fourfiles+0x154>
      for(i = 0; i < N; i++){
    4bd6:	34fd                	addiw	s1,s1,-1
    4bd8:	f0f5                	bnez	s1,4bbc <fourfiles+0x10e>
      exit(0);
    4bda:	4501                	li	a0,0
    4bdc:	00001097          	auipc	ra,0x1
    4be0:	fea080e7          	jalr	-22(ra) # 5bc6 <exit>
        printf("create failed\n", s);
    4be4:	f5843583          	ld	a1,-168(s0)
    4be8:	00003517          	auipc	a0,0x3
    4bec:	23850513          	addi	a0,a0,568 # 7e20 <malloc+0x1e14>
    4bf0:	00001097          	auipc	ra,0x1
    4bf4:	35e080e7          	jalr	862(ra) # 5f4e <printf>
        exit(1);
    4bf8:	4505                	li	a0,1
    4bfa:	00001097          	auipc	ra,0x1
    4bfe:	fcc080e7          	jalr	-52(ra) # 5bc6 <exit>
          printf("write failed %d\n", n);
    4c02:	00003517          	auipc	a0,0x3
    4c06:	22e50513          	addi	a0,a0,558 # 7e30 <malloc+0x1e24>
    4c0a:	00001097          	auipc	ra,0x1
    4c0e:	344080e7          	jalr	836(ra) # 5f4e <printf>
          exit(1);
    4c12:	4505                	li	a0,1
    4c14:	00001097          	auipc	ra,0x1
    4c18:	fb2080e7          	jalr	-78(ra) # 5bc6 <exit>
      exit(xstatus);
    4c1c:	855a                	mv	a0,s6
    4c1e:	00001097          	auipc	ra,0x1
    4c22:	fa8080e7          	jalr	-88(ra) # 5bc6 <exit>
          printf("wrong char\n", s);
    4c26:	f5843583          	ld	a1,-168(s0)
    4c2a:	00003517          	auipc	a0,0x3
    4c2e:	21e50513          	addi	a0,a0,542 # 7e48 <malloc+0x1e3c>
    4c32:	00001097          	auipc	ra,0x1
    4c36:	31c080e7          	jalr	796(ra) # 5f4e <printf>
          exit(1);
    4c3a:	4505                	li	a0,1
    4c3c:	00001097          	auipc	ra,0x1
    4c40:	f8a080e7          	jalr	-118(ra) # 5bc6 <exit>
      total += n;
    4c44:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4c48:	660d                	lui	a2,0x3
    4c4a:	85d2                	mv	a1,s4
    4c4c:	854e                	mv	a0,s3
    4c4e:	00001097          	auipc	ra,0x1
    4c52:	f90080e7          	jalr	-112(ra) # 5bde <read>
    4c56:	02a05363          	blez	a0,4c7c <fourfiles+0x1ce>
    4c5a:	00008797          	auipc	a5,0x8
    4c5e:	ffe78793          	addi	a5,a5,-2 # cc58 <buf>
    4c62:	fff5069b          	addiw	a3,a0,-1
    4c66:	1682                	slli	a3,a3,0x20
    4c68:	9281                	srli	a3,a3,0x20
    4c6a:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    4c6c:	0007c703          	lbu	a4,0(a5)
    4c70:	fa971be3          	bne	a4,s1,4c26 <fourfiles+0x178>
      for(j = 0; j < n; j++){
    4c74:	0785                	addi	a5,a5,1
    4c76:	fed79be3          	bne	a5,a3,4c6c <fourfiles+0x1be>
    4c7a:	b7e9                	j	4c44 <fourfiles+0x196>
    close(fd);
    4c7c:	854e                	mv	a0,s3
    4c7e:	00001097          	auipc	ra,0x1
    4c82:	f70080e7          	jalr	-144(ra) # 5bee <close>
    if(total != N*SZ){
    4c86:	03b91863          	bne	s2,s11,4cb6 <fourfiles+0x208>
    unlink(fname);
    4c8a:	8566                	mv	a0,s9
    4c8c:	00001097          	auipc	ra,0x1
    4c90:	f8a080e7          	jalr	-118(ra) # 5c16 <unlink>
  for(i = 0; i < NCHILD; i++){
    4c94:	0c21                	addi	s8,s8,8
    4c96:	2b85                	addiw	s7,s7,1
    4c98:	03ab8d63          	beq	s7,s10,4cd2 <fourfiles+0x224>
    fname = names[i];
    4c9c:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    4ca0:	4581                	li	a1,0
    4ca2:	8566                	mv	a0,s9
    4ca4:	00001097          	auipc	ra,0x1
    4ca8:	f62080e7          	jalr	-158(ra) # 5c06 <open>
    4cac:	89aa                	mv	s3,a0
    total = 0;
    4cae:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    4cb0:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4cb4:	bf51                	j	4c48 <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    4cb6:	85ca                	mv	a1,s2
    4cb8:	00003517          	auipc	a0,0x3
    4cbc:	1a050513          	addi	a0,a0,416 # 7e58 <malloc+0x1e4c>
    4cc0:	00001097          	auipc	ra,0x1
    4cc4:	28e080e7          	jalr	654(ra) # 5f4e <printf>
      exit(1);
    4cc8:	4505                	li	a0,1
    4cca:	00001097          	auipc	ra,0x1
    4cce:	efc080e7          	jalr	-260(ra) # 5bc6 <exit>
}
    4cd2:	70aa                	ld	ra,168(sp)
    4cd4:	740a                	ld	s0,160(sp)
    4cd6:	64ea                	ld	s1,152(sp)
    4cd8:	694a                	ld	s2,144(sp)
    4cda:	69aa                	ld	s3,136(sp)
    4cdc:	6a0a                	ld	s4,128(sp)
    4cde:	7ae6                	ld	s5,120(sp)
    4ce0:	7b46                	ld	s6,112(sp)
    4ce2:	7ba6                	ld	s7,104(sp)
    4ce4:	7c06                	ld	s8,96(sp)
    4ce6:	6ce6                	ld	s9,88(sp)
    4ce8:	6d46                	ld	s10,80(sp)
    4cea:	6da6                	ld	s11,72(sp)
    4cec:	614d                	addi	sp,sp,176
    4cee:	8082                	ret

0000000000004cf0 <concreate>:
{
    4cf0:	7135                	addi	sp,sp,-160
    4cf2:	ed06                	sd	ra,152(sp)
    4cf4:	e922                	sd	s0,144(sp)
    4cf6:	e526                	sd	s1,136(sp)
    4cf8:	e14a                	sd	s2,128(sp)
    4cfa:	fcce                	sd	s3,120(sp)
    4cfc:	f8d2                	sd	s4,112(sp)
    4cfe:	f4d6                	sd	s5,104(sp)
    4d00:	f0da                	sd	s6,96(sp)
    4d02:	ecde                	sd	s7,88(sp)
    4d04:	1100                	addi	s0,sp,160
    4d06:	89aa                	mv	s3,a0
  file[0] = 'C';
    4d08:	04300793          	li	a5,67
    4d0c:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4d10:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4d14:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4d16:	4b0d                	li	s6,3
    4d18:	4a85                	li	s5,1
      link("C0", file);
    4d1a:	00003b97          	auipc	s7,0x3
    4d1e:	156b8b93          	addi	s7,s7,342 # 7e70 <malloc+0x1e64>
  for(i = 0; i < N; i++){
    4d22:	02800a13          	li	s4,40
    4d26:	acc1                	j	4ff6 <concreate+0x306>
      link("C0", file);
    4d28:	fa840593          	addi	a1,s0,-88
    4d2c:	855e                	mv	a0,s7
    4d2e:	00001097          	auipc	ra,0x1
    4d32:	ef8080e7          	jalr	-264(ra) # 5c26 <link>
    if(pid == 0) {
    4d36:	a45d                	j	4fdc <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    4d38:	4795                	li	a5,5
    4d3a:	02f9693b          	remw	s2,s2,a5
    4d3e:	4785                	li	a5,1
    4d40:	02f90b63          	beq	s2,a5,4d76 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4d44:	20200593          	li	a1,514
    4d48:	fa840513          	addi	a0,s0,-88
    4d4c:	00001097          	auipc	ra,0x1
    4d50:	eba080e7          	jalr	-326(ra) # 5c06 <open>
      if(fd < 0){
    4d54:	26055b63          	bgez	a0,4fca <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4d58:	fa840593          	addi	a1,s0,-88
    4d5c:	00003517          	auipc	a0,0x3
    4d60:	11c50513          	addi	a0,a0,284 # 7e78 <malloc+0x1e6c>
    4d64:	00001097          	auipc	ra,0x1
    4d68:	1ea080e7          	jalr	490(ra) # 5f4e <printf>
        exit(1);
    4d6c:	4505                	li	a0,1
    4d6e:	00001097          	auipc	ra,0x1
    4d72:	e58080e7          	jalr	-424(ra) # 5bc6 <exit>
      link("C0", file);
    4d76:	fa840593          	addi	a1,s0,-88
    4d7a:	00003517          	auipc	a0,0x3
    4d7e:	0f650513          	addi	a0,a0,246 # 7e70 <malloc+0x1e64>
    4d82:	00001097          	auipc	ra,0x1
    4d86:	ea4080e7          	jalr	-348(ra) # 5c26 <link>
      exit(0);
    4d8a:	4501                	li	a0,0
    4d8c:	00001097          	auipc	ra,0x1
    4d90:	e3a080e7          	jalr	-454(ra) # 5bc6 <exit>
        exit(1);
    4d94:	4505                	li	a0,1
    4d96:	00001097          	auipc	ra,0x1
    4d9a:	e30080e7          	jalr	-464(ra) # 5bc6 <exit>
  memset(fa, 0, sizeof(fa));
    4d9e:	02800613          	li	a2,40
    4da2:	4581                	li	a1,0
    4da4:	f8040513          	addi	a0,s0,-128
    4da8:	00001097          	auipc	ra,0x1
    4dac:	c22080e7          	jalr	-990(ra) # 59ca <memset>
  fd = open(".", 0);
    4db0:	4581                	li	a1,0
    4db2:	00002517          	auipc	a0,0x2
    4db6:	a7e50513          	addi	a0,a0,-1410 # 6830 <malloc+0x824>
    4dba:	00001097          	auipc	ra,0x1
    4dbe:	e4c080e7          	jalr	-436(ra) # 5c06 <open>
    4dc2:	892a                	mv	s2,a0
  n = 0;
    4dc4:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4dc6:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4dca:	02700b13          	li	s6,39
      fa[i] = 1;
    4dce:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4dd0:	4641                	li	a2,16
    4dd2:	f7040593          	addi	a1,s0,-144
    4dd6:	854a                	mv	a0,s2
    4dd8:	00001097          	auipc	ra,0x1
    4ddc:	e06080e7          	jalr	-506(ra) # 5bde <read>
    4de0:	08a05163          	blez	a0,4e62 <concreate+0x172>
    if(de.inum == 0)
    4de4:	f7045783          	lhu	a5,-144(s0)
    4de8:	d7e5                	beqz	a5,4dd0 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4dea:	f7244783          	lbu	a5,-142(s0)
    4dee:	ff4791e3          	bne	a5,s4,4dd0 <concreate+0xe0>
    4df2:	f7444783          	lbu	a5,-140(s0)
    4df6:	ffe9                	bnez	a5,4dd0 <concreate+0xe0>
      i = de.name[1] - '0';
    4df8:	f7344783          	lbu	a5,-141(s0)
    4dfc:	fd07879b          	addiw	a5,a5,-48
    4e00:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4e04:	00eb6f63          	bltu	s6,a4,4e22 <concreate+0x132>
      if(fa[i]){
    4e08:	fb040793          	addi	a5,s0,-80
    4e0c:	97ba                	add	a5,a5,a4
    4e0e:	fd07c783          	lbu	a5,-48(a5)
    4e12:	eb85                	bnez	a5,4e42 <concreate+0x152>
      fa[i] = 1;
    4e14:	fb040793          	addi	a5,s0,-80
    4e18:	973e                	add	a4,a4,a5
    4e1a:	fd770823          	sb	s7,-48(a4) # fd0 <linktest+0xda>
      n++;
    4e1e:	2a85                	addiw	s5,s5,1
    4e20:	bf45                	j	4dd0 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4e22:	f7240613          	addi	a2,s0,-142
    4e26:	85ce                	mv	a1,s3
    4e28:	00003517          	auipc	a0,0x3
    4e2c:	07050513          	addi	a0,a0,112 # 7e98 <malloc+0x1e8c>
    4e30:	00001097          	auipc	ra,0x1
    4e34:	11e080e7          	jalr	286(ra) # 5f4e <printf>
        exit(1);
    4e38:	4505                	li	a0,1
    4e3a:	00001097          	auipc	ra,0x1
    4e3e:	d8c080e7          	jalr	-628(ra) # 5bc6 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4e42:	f7240613          	addi	a2,s0,-142
    4e46:	85ce                	mv	a1,s3
    4e48:	00003517          	auipc	a0,0x3
    4e4c:	07050513          	addi	a0,a0,112 # 7eb8 <malloc+0x1eac>
    4e50:	00001097          	auipc	ra,0x1
    4e54:	0fe080e7          	jalr	254(ra) # 5f4e <printf>
        exit(1);
    4e58:	4505                	li	a0,1
    4e5a:	00001097          	auipc	ra,0x1
    4e5e:	d6c080e7          	jalr	-660(ra) # 5bc6 <exit>
  close(fd);
    4e62:	854a                	mv	a0,s2
    4e64:	00001097          	auipc	ra,0x1
    4e68:	d8a080e7          	jalr	-630(ra) # 5bee <close>
  if(n != N){
    4e6c:	02800793          	li	a5,40
    4e70:	00fa9763          	bne	s5,a5,4e7e <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    4e74:	4a8d                	li	s5,3
    4e76:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4e78:	02800a13          	li	s4,40
    4e7c:	a8c9                	j	4f4e <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    4e7e:	85ce                	mv	a1,s3
    4e80:	00003517          	auipc	a0,0x3
    4e84:	06050513          	addi	a0,a0,96 # 7ee0 <malloc+0x1ed4>
    4e88:	00001097          	auipc	ra,0x1
    4e8c:	0c6080e7          	jalr	198(ra) # 5f4e <printf>
    exit(1);
    4e90:	4505                	li	a0,1
    4e92:	00001097          	auipc	ra,0x1
    4e96:	d34080e7          	jalr	-716(ra) # 5bc6 <exit>
      printf("%s: fork failed\n", s);
    4e9a:	85ce                	mv	a1,s3
    4e9c:	00002517          	auipc	a0,0x2
    4ea0:	b3450513          	addi	a0,a0,-1228 # 69d0 <malloc+0x9c4>
    4ea4:	00001097          	auipc	ra,0x1
    4ea8:	0aa080e7          	jalr	170(ra) # 5f4e <printf>
      exit(1);
    4eac:	4505                	li	a0,1
    4eae:	00001097          	auipc	ra,0x1
    4eb2:	d18080e7          	jalr	-744(ra) # 5bc6 <exit>
      close(open(file, 0));
    4eb6:	4581                	li	a1,0
    4eb8:	fa840513          	addi	a0,s0,-88
    4ebc:	00001097          	auipc	ra,0x1
    4ec0:	d4a080e7          	jalr	-694(ra) # 5c06 <open>
    4ec4:	00001097          	auipc	ra,0x1
    4ec8:	d2a080e7          	jalr	-726(ra) # 5bee <close>
      close(open(file, 0));
    4ecc:	4581                	li	a1,0
    4ece:	fa840513          	addi	a0,s0,-88
    4ed2:	00001097          	auipc	ra,0x1
    4ed6:	d34080e7          	jalr	-716(ra) # 5c06 <open>
    4eda:	00001097          	auipc	ra,0x1
    4ede:	d14080e7          	jalr	-748(ra) # 5bee <close>
      close(open(file, 0));
    4ee2:	4581                	li	a1,0
    4ee4:	fa840513          	addi	a0,s0,-88
    4ee8:	00001097          	auipc	ra,0x1
    4eec:	d1e080e7          	jalr	-738(ra) # 5c06 <open>
    4ef0:	00001097          	auipc	ra,0x1
    4ef4:	cfe080e7          	jalr	-770(ra) # 5bee <close>
      close(open(file, 0));
    4ef8:	4581                	li	a1,0
    4efa:	fa840513          	addi	a0,s0,-88
    4efe:	00001097          	auipc	ra,0x1
    4f02:	d08080e7          	jalr	-760(ra) # 5c06 <open>
    4f06:	00001097          	auipc	ra,0x1
    4f0a:	ce8080e7          	jalr	-792(ra) # 5bee <close>
      close(open(file, 0));
    4f0e:	4581                	li	a1,0
    4f10:	fa840513          	addi	a0,s0,-88
    4f14:	00001097          	auipc	ra,0x1
    4f18:	cf2080e7          	jalr	-782(ra) # 5c06 <open>
    4f1c:	00001097          	auipc	ra,0x1
    4f20:	cd2080e7          	jalr	-814(ra) # 5bee <close>
      close(open(file, 0));
    4f24:	4581                	li	a1,0
    4f26:	fa840513          	addi	a0,s0,-88
    4f2a:	00001097          	auipc	ra,0x1
    4f2e:	cdc080e7          	jalr	-804(ra) # 5c06 <open>
    4f32:	00001097          	auipc	ra,0x1
    4f36:	cbc080e7          	jalr	-836(ra) # 5bee <close>
    if(pid == 0)
    4f3a:	08090363          	beqz	s2,4fc0 <concreate+0x2d0>
      wait(0);
    4f3e:	4501                	li	a0,0
    4f40:	00001097          	auipc	ra,0x1
    4f44:	c8e080e7          	jalr	-882(ra) # 5bce <wait>
  for(i = 0; i < N; i++){
    4f48:	2485                	addiw	s1,s1,1
    4f4a:	0f448563          	beq	s1,s4,5034 <concreate+0x344>
    file[1] = '0' + i;
    4f4e:	0304879b          	addiw	a5,s1,48
    4f52:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4f56:	00001097          	auipc	ra,0x1
    4f5a:	c68080e7          	jalr	-920(ra) # 5bbe <fork>
    4f5e:	892a                	mv	s2,a0
    if(pid < 0){
    4f60:	f2054de3          	bltz	a0,4e9a <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    4f64:	0354e73b          	remw	a4,s1,s5
    4f68:	00a767b3          	or	a5,a4,a0
    4f6c:	2781                	sext.w	a5,a5
    4f6e:	d7a1                	beqz	a5,4eb6 <concreate+0x1c6>
    4f70:	01671363          	bne	a4,s6,4f76 <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    4f74:	f129                	bnez	a0,4eb6 <concreate+0x1c6>
      unlink(file);
    4f76:	fa840513          	addi	a0,s0,-88
    4f7a:	00001097          	auipc	ra,0x1
    4f7e:	c9c080e7          	jalr	-868(ra) # 5c16 <unlink>
      unlink(file);
    4f82:	fa840513          	addi	a0,s0,-88
    4f86:	00001097          	auipc	ra,0x1
    4f8a:	c90080e7          	jalr	-880(ra) # 5c16 <unlink>
      unlink(file);
    4f8e:	fa840513          	addi	a0,s0,-88
    4f92:	00001097          	auipc	ra,0x1
    4f96:	c84080e7          	jalr	-892(ra) # 5c16 <unlink>
      unlink(file);
    4f9a:	fa840513          	addi	a0,s0,-88
    4f9e:	00001097          	auipc	ra,0x1
    4fa2:	c78080e7          	jalr	-904(ra) # 5c16 <unlink>
      unlink(file);
    4fa6:	fa840513          	addi	a0,s0,-88
    4faa:	00001097          	auipc	ra,0x1
    4fae:	c6c080e7          	jalr	-916(ra) # 5c16 <unlink>
      unlink(file);
    4fb2:	fa840513          	addi	a0,s0,-88
    4fb6:	00001097          	auipc	ra,0x1
    4fba:	c60080e7          	jalr	-928(ra) # 5c16 <unlink>
    4fbe:	bfb5                	j	4f3a <concreate+0x24a>
      exit(0);
    4fc0:	4501                	li	a0,0
    4fc2:	00001097          	auipc	ra,0x1
    4fc6:	c04080e7          	jalr	-1020(ra) # 5bc6 <exit>
      close(fd);
    4fca:	00001097          	auipc	ra,0x1
    4fce:	c24080e7          	jalr	-988(ra) # 5bee <close>
    if(pid == 0) {
    4fd2:	bb65                	j	4d8a <concreate+0x9a>
      close(fd);
    4fd4:	00001097          	auipc	ra,0x1
    4fd8:	c1a080e7          	jalr	-998(ra) # 5bee <close>
      wait(&xstatus);
    4fdc:	f6c40513          	addi	a0,s0,-148
    4fe0:	00001097          	auipc	ra,0x1
    4fe4:	bee080e7          	jalr	-1042(ra) # 5bce <wait>
      if(xstatus != 0)
    4fe8:	f6c42483          	lw	s1,-148(s0)
    4fec:	da0494e3          	bnez	s1,4d94 <concreate+0xa4>
  for(i = 0; i < N; i++){
    4ff0:	2905                	addiw	s2,s2,1
    4ff2:	db4906e3          	beq	s2,s4,4d9e <concreate+0xae>
    file[1] = '0' + i;
    4ff6:	0309079b          	addiw	a5,s2,48
    4ffa:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4ffe:	fa840513          	addi	a0,s0,-88
    5002:	00001097          	auipc	ra,0x1
    5006:	c14080e7          	jalr	-1004(ra) # 5c16 <unlink>
    pid = fork();
    500a:	00001097          	auipc	ra,0x1
    500e:	bb4080e7          	jalr	-1100(ra) # 5bbe <fork>
    if(pid && (i % 3) == 1){
    5012:	d20503e3          	beqz	a0,4d38 <concreate+0x48>
    5016:	036967bb          	remw	a5,s2,s6
    501a:	d15787e3          	beq	a5,s5,4d28 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    501e:	20200593          	li	a1,514
    5022:	fa840513          	addi	a0,s0,-88
    5026:	00001097          	auipc	ra,0x1
    502a:	be0080e7          	jalr	-1056(ra) # 5c06 <open>
      if(fd < 0){
    502e:	fa0553e3          	bgez	a0,4fd4 <concreate+0x2e4>
    5032:	b31d                	j	4d58 <concreate+0x68>
}
    5034:	60ea                	ld	ra,152(sp)
    5036:	644a                	ld	s0,144(sp)
    5038:	64aa                	ld	s1,136(sp)
    503a:	690a                	ld	s2,128(sp)
    503c:	79e6                	ld	s3,120(sp)
    503e:	7a46                	ld	s4,112(sp)
    5040:	7aa6                	ld	s5,104(sp)
    5042:	7b06                	ld	s6,96(sp)
    5044:	6be6                	ld	s7,88(sp)
    5046:	610d                	addi	sp,sp,160
    5048:	8082                	ret

000000000000504a <bigfile>:
{
    504a:	7139                	addi	sp,sp,-64
    504c:	fc06                	sd	ra,56(sp)
    504e:	f822                	sd	s0,48(sp)
    5050:	f426                	sd	s1,40(sp)
    5052:	f04a                	sd	s2,32(sp)
    5054:	ec4e                	sd	s3,24(sp)
    5056:	e852                	sd	s4,16(sp)
    5058:	e456                	sd	s5,8(sp)
    505a:	0080                	addi	s0,sp,64
    505c:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    505e:	00003517          	auipc	a0,0x3
    5062:	eba50513          	addi	a0,a0,-326 # 7f18 <malloc+0x1f0c>
    5066:	00001097          	auipc	ra,0x1
    506a:	bb0080e7          	jalr	-1104(ra) # 5c16 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    506e:	20200593          	li	a1,514
    5072:	00003517          	auipc	a0,0x3
    5076:	ea650513          	addi	a0,a0,-346 # 7f18 <malloc+0x1f0c>
    507a:	00001097          	auipc	ra,0x1
    507e:	b8c080e7          	jalr	-1140(ra) # 5c06 <open>
    5082:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    5084:	4481                	li	s1,0
    memset(buf, i, SZ);
    5086:	00008917          	auipc	s2,0x8
    508a:	bd290913          	addi	s2,s2,-1070 # cc58 <buf>
  for(i = 0; i < N; i++){
    508e:	4a51                	li	s4,20
  if(fd < 0){
    5090:	0a054063          	bltz	a0,5130 <bigfile+0xe6>
    memset(buf, i, SZ);
    5094:	25800613          	li	a2,600
    5098:	85a6                	mv	a1,s1
    509a:	854a                	mv	a0,s2
    509c:	00001097          	auipc	ra,0x1
    50a0:	92e080e7          	jalr	-1746(ra) # 59ca <memset>
    if(write(fd, buf, SZ) != SZ){
    50a4:	25800613          	li	a2,600
    50a8:	85ca                	mv	a1,s2
    50aa:	854e                	mv	a0,s3
    50ac:	00001097          	auipc	ra,0x1
    50b0:	b3a080e7          	jalr	-1222(ra) # 5be6 <write>
    50b4:	25800793          	li	a5,600
    50b8:	08f51a63          	bne	a0,a5,514c <bigfile+0x102>
  for(i = 0; i < N; i++){
    50bc:	2485                	addiw	s1,s1,1
    50be:	fd449be3          	bne	s1,s4,5094 <bigfile+0x4a>
  close(fd);
    50c2:	854e                	mv	a0,s3
    50c4:	00001097          	auipc	ra,0x1
    50c8:	b2a080e7          	jalr	-1238(ra) # 5bee <close>
  fd = open("bigfile.dat", 0);
    50cc:	4581                	li	a1,0
    50ce:	00003517          	auipc	a0,0x3
    50d2:	e4a50513          	addi	a0,a0,-438 # 7f18 <malloc+0x1f0c>
    50d6:	00001097          	auipc	ra,0x1
    50da:	b30080e7          	jalr	-1232(ra) # 5c06 <open>
    50de:	8a2a                	mv	s4,a0
  total = 0;
    50e0:	4981                	li	s3,0
  for(i = 0; ; i++){
    50e2:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    50e4:	00008917          	auipc	s2,0x8
    50e8:	b7490913          	addi	s2,s2,-1164 # cc58 <buf>
  if(fd < 0){
    50ec:	06054e63          	bltz	a0,5168 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    50f0:	12c00613          	li	a2,300
    50f4:	85ca                	mv	a1,s2
    50f6:	8552                	mv	a0,s4
    50f8:	00001097          	auipc	ra,0x1
    50fc:	ae6080e7          	jalr	-1306(ra) # 5bde <read>
    if(cc < 0){
    5100:	08054263          	bltz	a0,5184 <bigfile+0x13a>
    if(cc == 0)
    5104:	c971                	beqz	a0,51d8 <bigfile+0x18e>
    if(cc != SZ/2){
    5106:	12c00793          	li	a5,300
    510a:	08f51b63          	bne	a0,a5,51a0 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    510e:	01f4d79b          	srliw	a5,s1,0x1f
    5112:	9fa5                	addw	a5,a5,s1
    5114:	4017d79b          	sraiw	a5,a5,0x1
    5118:	00094703          	lbu	a4,0(s2)
    511c:	0af71063          	bne	a4,a5,51bc <bigfile+0x172>
    5120:	12b94703          	lbu	a4,299(s2)
    5124:	08f71c63          	bne	a4,a5,51bc <bigfile+0x172>
    total += cc;
    5128:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    512c:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    512e:	b7c9                	j	50f0 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    5130:	85d6                	mv	a1,s5
    5132:	00003517          	auipc	a0,0x3
    5136:	df650513          	addi	a0,a0,-522 # 7f28 <malloc+0x1f1c>
    513a:	00001097          	auipc	ra,0x1
    513e:	e14080e7          	jalr	-492(ra) # 5f4e <printf>
    exit(1);
    5142:	4505                	li	a0,1
    5144:	00001097          	auipc	ra,0x1
    5148:	a82080e7          	jalr	-1406(ra) # 5bc6 <exit>
      printf("%s: write bigfile failed\n", s);
    514c:	85d6                	mv	a1,s5
    514e:	00003517          	auipc	a0,0x3
    5152:	dfa50513          	addi	a0,a0,-518 # 7f48 <malloc+0x1f3c>
    5156:	00001097          	auipc	ra,0x1
    515a:	df8080e7          	jalr	-520(ra) # 5f4e <printf>
      exit(1);
    515e:	4505                	li	a0,1
    5160:	00001097          	auipc	ra,0x1
    5164:	a66080e7          	jalr	-1434(ra) # 5bc6 <exit>
    printf("%s: cannot open bigfile\n", s);
    5168:	85d6                	mv	a1,s5
    516a:	00003517          	auipc	a0,0x3
    516e:	dfe50513          	addi	a0,a0,-514 # 7f68 <malloc+0x1f5c>
    5172:	00001097          	auipc	ra,0x1
    5176:	ddc080e7          	jalr	-548(ra) # 5f4e <printf>
    exit(1);
    517a:	4505                	li	a0,1
    517c:	00001097          	auipc	ra,0x1
    5180:	a4a080e7          	jalr	-1462(ra) # 5bc6 <exit>
      printf("%s: read bigfile failed\n", s);
    5184:	85d6                	mv	a1,s5
    5186:	00003517          	auipc	a0,0x3
    518a:	e0250513          	addi	a0,a0,-510 # 7f88 <malloc+0x1f7c>
    518e:	00001097          	auipc	ra,0x1
    5192:	dc0080e7          	jalr	-576(ra) # 5f4e <printf>
      exit(1);
    5196:	4505                	li	a0,1
    5198:	00001097          	auipc	ra,0x1
    519c:	a2e080e7          	jalr	-1490(ra) # 5bc6 <exit>
      printf("%s: short read bigfile\n", s);
    51a0:	85d6                	mv	a1,s5
    51a2:	00003517          	auipc	a0,0x3
    51a6:	e0650513          	addi	a0,a0,-506 # 7fa8 <malloc+0x1f9c>
    51aa:	00001097          	auipc	ra,0x1
    51ae:	da4080e7          	jalr	-604(ra) # 5f4e <printf>
      exit(1);
    51b2:	4505                	li	a0,1
    51b4:	00001097          	auipc	ra,0x1
    51b8:	a12080e7          	jalr	-1518(ra) # 5bc6 <exit>
      printf("%s: read bigfile wrong data\n", s);
    51bc:	85d6                	mv	a1,s5
    51be:	00003517          	auipc	a0,0x3
    51c2:	e0250513          	addi	a0,a0,-510 # 7fc0 <malloc+0x1fb4>
    51c6:	00001097          	auipc	ra,0x1
    51ca:	d88080e7          	jalr	-632(ra) # 5f4e <printf>
      exit(1);
    51ce:	4505                	li	a0,1
    51d0:	00001097          	auipc	ra,0x1
    51d4:	9f6080e7          	jalr	-1546(ra) # 5bc6 <exit>
  close(fd);
    51d8:	8552                	mv	a0,s4
    51da:	00001097          	auipc	ra,0x1
    51de:	a14080e7          	jalr	-1516(ra) # 5bee <close>
  if(total != N*SZ){
    51e2:	678d                	lui	a5,0x3
    51e4:	ee078793          	addi	a5,a5,-288 # 2ee0 <fourteen+0x2e>
    51e8:	02f99363          	bne	s3,a5,520e <bigfile+0x1c4>
  unlink("bigfile.dat");
    51ec:	00003517          	auipc	a0,0x3
    51f0:	d2c50513          	addi	a0,a0,-724 # 7f18 <malloc+0x1f0c>
    51f4:	00001097          	auipc	ra,0x1
    51f8:	a22080e7          	jalr	-1502(ra) # 5c16 <unlink>
}
    51fc:	70e2                	ld	ra,56(sp)
    51fe:	7442                	ld	s0,48(sp)
    5200:	74a2                	ld	s1,40(sp)
    5202:	7902                	ld	s2,32(sp)
    5204:	69e2                	ld	s3,24(sp)
    5206:	6a42                	ld	s4,16(sp)
    5208:	6aa2                	ld	s5,8(sp)
    520a:	6121                	addi	sp,sp,64
    520c:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    520e:	85d6                	mv	a1,s5
    5210:	00003517          	auipc	a0,0x3
    5214:	dd050513          	addi	a0,a0,-560 # 7fe0 <malloc+0x1fd4>
    5218:	00001097          	auipc	ra,0x1
    521c:	d36080e7          	jalr	-714(ra) # 5f4e <printf>
    exit(1);
    5220:	4505                	li	a0,1
    5222:	00001097          	auipc	ra,0x1
    5226:	9a4080e7          	jalr	-1628(ra) # 5bc6 <exit>

000000000000522a <MAXVAplus>:
{
    522a:	7179                	addi	sp,sp,-48
    522c:	f406                	sd	ra,40(sp)
    522e:	f022                	sd	s0,32(sp)
    5230:	ec26                	sd	s1,24(sp)
    5232:	e84a                	sd	s2,16(sp)
    5234:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    5236:	4785                	li	a5,1
    5238:	179a                	slli	a5,a5,0x26
    523a:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    523e:	fd843783          	ld	a5,-40(s0)
    5242:	cf85                	beqz	a5,527a <MAXVAplus+0x50>
    5244:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    5246:	54fd                	li	s1,-1
    pid = fork();
    5248:	00001097          	auipc	ra,0x1
    524c:	976080e7          	jalr	-1674(ra) # 5bbe <fork>
    if(pid < 0){
    5250:	02054b63          	bltz	a0,5286 <MAXVAplus+0x5c>
    if(pid == 0){
    5254:	c539                	beqz	a0,52a2 <MAXVAplus+0x78>
    wait(&xstatus);
    5256:	fd440513          	addi	a0,s0,-44
    525a:	00001097          	auipc	ra,0x1
    525e:	974080e7          	jalr	-1676(ra) # 5bce <wait>
    if(xstatus != -1)  // did kernel kill child?
    5262:	fd442783          	lw	a5,-44(s0)
    5266:	06979463          	bne	a5,s1,52ce <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    526a:	fd843783          	ld	a5,-40(s0)
    526e:	0786                	slli	a5,a5,0x1
    5270:	fcf43c23          	sd	a5,-40(s0)
    5274:	fd843783          	ld	a5,-40(s0)
    5278:	fbe1                	bnez	a5,5248 <MAXVAplus+0x1e>
}
    527a:	70a2                	ld	ra,40(sp)
    527c:	7402                	ld	s0,32(sp)
    527e:	64e2                	ld	s1,24(sp)
    5280:	6942                	ld	s2,16(sp)
    5282:	6145                	addi	sp,sp,48
    5284:	8082                	ret
      printf("%s: fork failed\n", s);
    5286:	85ca                	mv	a1,s2
    5288:	00001517          	auipc	a0,0x1
    528c:	74850513          	addi	a0,a0,1864 # 69d0 <malloc+0x9c4>
    5290:	00001097          	auipc	ra,0x1
    5294:	cbe080e7          	jalr	-834(ra) # 5f4e <printf>
      exit(1);
    5298:	4505                	li	a0,1
    529a:	00001097          	auipc	ra,0x1
    529e:	92c080e7          	jalr	-1748(ra) # 5bc6 <exit>
      *(char*)a = 99;
    52a2:	fd843783          	ld	a5,-40(s0)
    52a6:	06300713          	li	a4,99
    52aa:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    52ae:	fd843603          	ld	a2,-40(s0)
    52b2:	85ca                	mv	a1,s2
    52b4:	00003517          	auipc	a0,0x3
    52b8:	d4c50513          	addi	a0,a0,-692 # 8000 <malloc+0x1ff4>
    52bc:	00001097          	auipc	ra,0x1
    52c0:	c92080e7          	jalr	-878(ra) # 5f4e <printf>
      exit(1);
    52c4:	4505                	li	a0,1
    52c6:	00001097          	auipc	ra,0x1
    52ca:	900080e7          	jalr	-1792(ra) # 5bc6 <exit>
      exit(1);
    52ce:	4505                	li	a0,1
    52d0:	00001097          	auipc	ra,0x1
    52d4:	8f6080e7          	jalr	-1802(ra) # 5bc6 <exit>

00000000000052d8 <fsfull>:
{
    52d8:	7171                	addi	sp,sp,-176
    52da:	f506                	sd	ra,168(sp)
    52dc:	f122                	sd	s0,160(sp)
    52de:	ed26                	sd	s1,152(sp)
    52e0:	e94a                	sd	s2,144(sp)
    52e2:	e54e                	sd	s3,136(sp)
    52e4:	e152                	sd	s4,128(sp)
    52e6:	fcd6                	sd	s5,120(sp)
    52e8:	f8da                	sd	s6,112(sp)
    52ea:	f4de                	sd	s7,104(sp)
    52ec:	f0e2                	sd	s8,96(sp)
    52ee:	ece6                	sd	s9,88(sp)
    52f0:	e8ea                	sd	s10,80(sp)
    52f2:	e4ee                	sd	s11,72(sp)
    52f4:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    52f6:	00003517          	auipc	a0,0x3
    52fa:	d2250513          	addi	a0,a0,-734 # 8018 <malloc+0x200c>
    52fe:	00001097          	auipc	ra,0x1
    5302:	c50080e7          	jalr	-944(ra) # 5f4e <printf>
  for(nfiles = 0; ; nfiles++){
    5306:	4481                	li	s1,0
    name[0] = 'f';
    5308:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    530c:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5310:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    5314:	4b29                	li	s6,10
    printf("writing %s\n", name);
    5316:	00003c97          	auipc	s9,0x3
    531a:	d12c8c93          	addi	s9,s9,-750 # 8028 <malloc+0x201c>
    int total = 0;
    531e:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    5320:	00008a17          	auipc	s4,0x8
    5324:	938a0a13          	addi	s4,s4,-1736 # cc58 <buf>
    name[0] = 'f';
    5328:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    532c:	0384c7bb          	divw	a5,s1,s8
    5330:	0307879b          	addiw	a5,a5,48
    5334:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5338:	0384e7bb          	remw	a5,s1,s8
    533c:	0377c7bb          	divw	a5,a5,s7
    5340:	0307879b          	addiw	a5,a5,48
    5344:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5348:	0374e7bb          	remw	a5,s1,s7
    534c:	0367c7bb          	divw	a5,a5,s6
    5350:	0307879b          	addiw	a5,a5,48
    5354:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    5358:	0364e7bb          	remw	a5,s1,s6
    535c:	0307879b          	addiw	a5,a5,48
    5360:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5364:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    5368:	f5040593          	addi	a1,s0,-176
    536c:	8566                	mv	a0,s9
    536e:	00001097          	auipc	ra,0x1
    5372:	be0080e7          	jalr	-1056(ra) # 5f4e <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    5376:	20200593          	li	a1,514
    537a:	f5040513          	addi	a0,s0,-176
    537e:	00001097          	auipc	ra,0x1
    5382:	888080e7          	jalr	-1912(ra) # 5c06 <open>
    5386:	892a                	mv	s2,a0
    if(fd < 0){
    5388:	0a055663          	bgez	a0,5434 <fsfull+0x15c>
      printf("open %s failed\n", name);
    538c:	f5040593          	addi	a1,s0,-176
    5390:	00003517          	auipc	a0,0x3
    5394:	ca850513          	addi	a0,a0,-856 # 8038 <malloc+0x202c>
    5398:	00001097          	auipc	ra,0x1
    539c:	bb6080e7          	jalr	-1098(ra) # 5f4e <printf>
  while(nfiles >= 0){
    53a0:	0604c363          	bltz	s1,5406 <fsfull+0x12e>
    name[0] = 'f';
    53a4:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    53a8:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    53ac:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    53b0:	4929                	li	s2,10
  while(nfiles >= 0){
    53b2:	5afd                	li	s5,-1
    name[0] = 'f';
    53b4:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    53b8:	0344c7bb          	divw	a5,s1,s4
    53bc:	0307879b          	addiw	a5,a5,48
    53c0:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    53c4:	0344e7bb          	remw	a5,s1,s4
    53c8:	0337c7bb          	divw	a5,a5,s3
    53cc:	0307879b          	addiw	a5,a5,48
    53d0:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    53d4:	0334e7bb          	remw	a5,s1,s3
    53d8:	0327c7bb          	divw	a5,a5,s2
    53dc:	0307879b          	addiw	a5,a5,48
    53e0:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    53e4:	0324e7bb          	remw	a5,s1,s2
    53e8:	0307879b          	addiw	a5,a5,48
    53ec:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    53f0:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    53f4:	f5040513          	addi	a0,s0,-176
    53f8:	00001097          	auipc	ra,0x1
    53fc:	81e080e7          	jalr	-2018(ra) # 5c16 <unlink>
    nfiles--;
    5400:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    5402:	fb5499e3          	bne	s1,s5,53b4 <fsfull+0xdc>
  printf("fsfull test finished\n");
    5406:	00003517          	auipc	a0,0x3
    540a:	c5250513          	addi	a0,a0,-942 # 8058 <malloc+0x204c>
    540e:	00001097          	auipc	ra,0x1
    5412:	b40080e7          	jalr	-1216(ra) # 5f4e <printf>
}
    5416:	70aa                	ld	ra,168(sp)
    5418:	740a                	ld	s0,160(sp)
    541a:	64ea                	ld	s1,152(sp)
    541c:	694a                	ld	s2,144(sp)
    541e:	69aa                	ld	s3,136(sp)
    5420:	6a0a                	ld	s4,128(sp)
    5422:	7ae6                	ld	s5,120(sp)
    5424:	7b46                	ld	s6,112(sp)
    5426:	7ba6                	ld	s7,104(sp)
    5428:	7c06                	ld	s8,96(sp)
    542a:	6ce6                	ld	s9,88(sp)
    542c:	6d46                	ld	s10,80(sp)
    542e:	6da6                	ld	s11,72(sp)
    5430:	614d                	addi	sp,sp,176
    5432:	8082                	ret
    int total = 0;
    5434:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    5436:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    543a:	40000613          	li	a2,1024
    543e:	85d2                	mv	a1,s4
    5440:	854a                	mv	a0,s2
    5442:	00000097          	auipc	ra,0x0
    5446:	7a4080e7          	jalr	1956(ra) # 5be6 <write>
      if(cc < BSIZE)
    544a:	00aad563          	bge	s5,a0,5454 <fsfull+0x17c>
      total += cc;
    544e:	00a989bb          	addw	s3,s3,a0
    while(1){
    5452:	b7e5                	j	543a <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    5454:	85ce                	mv	a1,s3
    5456:	00003517          	auipc	a0,0x3
    545a:	bf250513          	addi	a0,a0,-1038 # 8048 <malloc+0x203c>
    545e:	00001097          	auipc	ra,0x1
    5462:	af0080e7          	jalr	-1296(ra) # 5f4e <printf>
    close(fd);
    5466:	854a                	mv	a0,s2
    5468:	00000097          	auipc	ra,0x0
    546c:	786080e7          	jalr	1926(ra) # 5bee <close>
    if(total == 0)
    5470:	f20988e3          	beqz	s3,53a0 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    5474:	2485                	addiw	s1,s1,1
    5476:	bd4d                	j	5328 <fsfull+0x50>

0000000000005478 <execout>:
{
    5478:	715d                	addi	sp,sp,-80
    547a:	e486                	sd	ra,72(sp)
    547c:	e0a2                	sd	s0,64(sp)
    547e:	fc26                	sd	s1,56(sp)
    5480:	f84a                	sd	s2,48(sp)
    5482:	f44e                	sd	s3,40(sp)
    5484:	f052                	sd	s4,32(sp)
    5486:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    5488:	4901                	li	s2,0
    548a:	49bd                	li	s3,15
    int pid = fork();
    548c:	00000097          	auipc	ra,0x0
    5490:	732080e7          	jalr	1842(ra) # 5bbe <fork>
    5494:	84aa                	mv	s1,a0
    if(pid < 0){
    5496:	02054063          	bltz	a0,54b6 <execout+0x3e>
    } else if(pid == 0){
    549a:	c91d                	beqz	a0,54d0 <execout+0x58>
      wait((int*)0);
    549c:	4501                	li	a0,0
    549e:	00000097          	auipc	ra,0x0
    54a2:	730080e7          	jalr	1840(ra) # 5bce <wait>
  for(int avail = 0; avail < 15; avail++){
    54a6:	2905                	addiw	s2,s2,1
    54a8:	ff3912e3          	bne	s2,s3,548c <execout+0x14>
  exit(0);
    54ac:	4501                	li	a0,0
    54ae:	00000097          	auipc	ra,0x0
    54b2:	718080e7          	jalr	1816(ra) # 5bc6 <exit>
      printf("fork failed\n");
    54b6:	00002517          	auipc	a0,0x2
    54ba:	90a50513          	addi	a0,a0,-1782 # 6dc0 <malloc+0xdb4>
    54be:	00001097          	auipc	ra,0x1
    54c2:	a90080e7          	jalr	-1392(ra) # 5f4e <printf>
      exit(1);
    54c6:	4505                	li	a0,1
    54c8:	00000097          	auipc	ra,0x0
    54cc:	6fe080e7          	jalr	1790(ra) # 5bc6 <exit>
        if(a == 0xffffffffffffffffLL)
    54d0:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    54d2:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    54d4:	6505                	lui	a0,0x1
    54d6:	00000097          	auipc	ra,0x0
    54da:	778080e7          	jalr	1912(ra) # 5c4e <sbrk>
        if(a == 0xffffffffffffffffLL)
    54de:	01350763          	beq	a0,s3,54ec <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    54e2:	6785                	lui	a5,0x1
    54e4:	953e                	add	a0,a0,a5
    54e6:	ff450fa3          	sb	s4,-1(a0) # fff <linktest+0x109>
      while(1){
    54ea:	b7ed                	j	54d4 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    54ec:	01205a63          	blez	s2,5500 <execout+0x88>
        sbrk(-4096);
    54f0:	757d                	lui	a0,0xfffff
    54f2:	00000097          	auipc	ra,0x0
    54f6:	75c080e7          	jalr	1884(ra) # 5c4e <sbrk>
      for(int i = 0; i < avail; i++)
    54fa:	2485                	addiw	s1,s1,1
    54fc:	ff249ae3          	bne	s1,s2,54f0 <execout+0x78>
      close(1);
    5500:	4505                	li	a0,1
    5502:	00000097          	auipc	ra,0x0
    5506:	6ec080e7          	jalr	1772(ra) # 5bee <close>
      char *args[] = { "echo", "x", 0 };
    550a:	00001517          	auipc	a0,0x1
    550e:	c3e50513          	addi	a0,a0,-962 # 6148 <malloc+0x13c>
    5512:	faa43c23          	sd	a0,-72(s0)
    5516:	00001797          	auipc	a5,0x1
    551a:	ca278793          	addi	a5,a5,-862 # 61b8 <malloc+0x1ac>
    551e:	fcf43023          	sd	a5,-64(s0)
    5522:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    5526:	fb840593          	addi	a1,s0,-72
    552a:	00000097          	auipc	ra,0x0
    552e:	6d4080e7          	jalr	1748(ra) # 5bfe <exec>
      exit(0);
    5532:	4501                	li	a0,0
    5534:	00000097          	auipc	ra,0x0
    5538:	692080e7          	jalr	1682(ra) # 5bc6 <exit>

000000000000553c <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    553c:	7179                	addi	sp,sp,-48
    553e:	f406                	sd	ra,40(sp)
    5540:	f022                	sd	s0,32(sp)
    5542:	ec26                	sd	s1,24(sp)
    5544:	e84a                	sd	s2,16(sp)
    5546:	1800                	addi	s0,sp,48
    5548:	84aa                	mv	s1,a0
    554a:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    554c:	00003517          	auipc	a0,0x3
    5550:	b2450513          	addi	a0,a0,-1244 # 8070 <malloc+0x2064>
    5554:	00001097          	auipc	ra,0x1
    5558:	9fa080e7          	jalr	-1542(ra) # 5f4e <printf>
  if((pid = fork()) < 0) {
    555c:	00000097          	auipc	ra,0x0
    5560:	662080e7          	jalr	1634(ra) # 5bbe <fork>
    5564:	02054e63          	bltz	a0,55a0 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5568:	c929                	beqz	a0,55ba <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    556a:	fdc40513          	addi	a0,s0,-36
    556e:	00000097          	auipc	ra,0x0
    5572:	660080e7          	jalr	1632(ra) # 5bce <wait>
    if(xstatus != 0) 
    5576:	fdc42783          	lw	a5,-36(s0)
    557a:	c7b9                	beqz	a5,55c8 <run+0x8c>
      printf("FAILED\n");
    557c:	00003517          	auipc	a0,0x3
    5580:	b1c50513          	addi	a0,a0,-1252 # 8098 <malloc+0x208c>
    5584:	00001097          	auipc	ra,0x1
    5588:	9ca080e7          	jalr	-1590(ra) # 5f4e <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    558c:	fdc42503          	lw	a0,-36(s0)
  }
}
    5590:	00153513          	seqz	a0,a0
    5594:	70a2                	ld	ra,40(sp)
    5596:	7402                	ld	s0,32(sp)
    5598:	64e2                	ld	s1,24(sp)
    559a:	6942                	ld	s2,16(sp)
    559c:	6145                	addi	sp,sp,48
    559e:	8082                	ret
    printf("runtest: fork error\n");
    55a0:	00003517          	auipc	a0,0x3
    55a4:	ae050513          	addi	a0,a0,-1312 # 8080 <malloc+0x2074>
    55a8:	00001097          	auipc	ra,0x1
    55ac:	9a6080e7          	jalr	-1626(ra) # 5f4e <printf>
    exit(1);
    55b0:	4505                	li	a0,1
    55b2:	00000097          	auipc	ra,0x0
    55b6:	614080e7          	jalr	1556(ra) # 5bc6 <exit>
    f(s);
    55ba:	854a                	mv	a0,s2
    55bc:	9482                	jalr	s1
    exit(0);
    55be:	4501                	li	a0,0
    55c0:	00000097          	auipc	ra,0x0
    55c4:	606080e7          	jalr	1542(ra) # 5bc6 <exit>
      printf("OK\n");
    55c8:	00003517          	auipc	a0,0x3
    55cc:	ad850513          	addi	a0,a0,-1320 # 80a0 <malloc+0x2094>
    55d0:	00001097          	auipc	ra,0x1
    55d4:	97e080e7          	jalr	-1666(ra) # 5f4e <printf>
    55d8:	bf55                	j	558c <run+0x50>

00000000000055da <runtests>:

int
runtests(struct test *tests, char *justone) {
    55da:	1101                	addi	sp,sp,-32
    55dc:	ec06                	sd	ra,24(sp)
    55de:	e822                	sd	s0,16(sp)
    55e0:	e426                	sd	s1,8(sp)
    55e2:	e04a                	sd	s2,0(sp)
    55e4:	1000                	addi	s0,sp,32
    55e6:	84aa                	mv	s1,a0
    55e8:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    55ea:	6508                	ld	a0,8(a0)
    55ec:	ed09                	bnez	a0,5606 <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    55ee:	4501                	li	a0,0
    55f0:	a82d                	j	562a <runtests+0x50>
      if(!run(t->f, t->s)){
    55f2:	648c                	ld	a1,8(s1)
    55f4:	6088                	ld	a0,0(s1)
    55f6:	00000097          	auipc	ra,0x0
    55fa:	f46080e7          	jalr	-186(ra) # 553c <run>
    55fe:	cd09                	beqz	a0,5618 <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++) {
    5600:	04c1                	addi	s1,s1,16
    5602:	6488                	ld	a0,8(s1)
    5604:	c11d                	beqz	a0,562a <runtests+0x50>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5606:	fe0906e3          	beqz	s2,55f2 <runtests+0x18>
    560a:	85ca                	mv	a1,s2
    560c:	00000097          	auipc	ra,0x0
    5610:	368080e7          	jalr	872(ra) # 5974 <strcmp>
    5614:	f575                	bnez	a0,5600 <runtests+0x26>
    5616:	bff1                	j	55f2 <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    5618:	00003517          	auipc	a0,0x3
    561c:	a9050513          	addi	a0,a0,-1392 # 80a8 <malloc+0x209c>
    5620:	00001097          	auipc	ra,0x1
    5624:	92e080e7          	jalr	-1746(ra) # 5f4e <printf>
        return 1;
    5628:	4505                	li	a0,1
}
    562a:	60e2                	ld	ra,24(sp)
    562c:	6442                	ld	s0,16(sp)
    562e:	64a2                	ld	s1,8(sp)
    5630:	6902                	ld	s2,0(sp)
    5632:	6105                	addi	sp,sp,32
    5634:	8082                	ret

0000000000005636 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    5636:	7139                	addi	sp,sp,-64
    5638:	fc06                	sd	ra,56(sp)
    563a:	f822                	sd	s0,48(sp)
    563c:	f426                	sd	s1,40(sp)
    563e:	f04a                	sd	s2,32(sp)
    5640:	ec4e                	sd	s3,24(sp)
    5642:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    5644:	fc840513          	addi	a0,s0,-56
    5648:	00000097          	auipc	ra,0x0
    564c:	58e080e7          	jalr	1422(ra) # 5bd6 <pipe>
    5650:	06054763          	bltz	a0,56be <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5654:	00000097          	auipc	ra,0x0
    5658:	56a080e7          	jalr	1386(ra) # 5bbe <fork>

  if(pid < 0){
    565c:	06054e63          	bltz	a0,56d8 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5660:	ed51                	bnez	a0,56fc <countfree+0xc6>
    close(fds[0]);
    5662:	fc842503          	lw	a0,-56(s0)
    5666:	00000097          	auipc	ra,0x0
    566a:	588080e7          	jalr	1416(ra) # 5bee <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    566e:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5670:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    5672:	00001997          	auipc	s3,0x1
    5676:	b4698993          	addi	s3,s3,-1210 # 61b8 <malloc+0x1ac>
      uint64 a = (uint64) sbrk(4096);
    567a:	6505                	lui	a0,0x1
    567c:	00000097          	auipc	ra,0x0
    5680:	5d2080e7          	jalr	1490(ra) # 5c4e <sbrk>
      if(a == 0xffffffffffffffff){
    5684:	07250763          	beq	a0,s2,56f2 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    5688:	6785                	lui	a5,0x1
    568a:	953e                	add	a0,a0,a5
    568c:	fe950fa3          	sb	s1,-1(a0) # fff <linktest+0x109>
      if(write(fds[1], "x", 1) != 1){
    5690:	8626                	mv	a2,s1
    5692:	85ce                	mv	a1,s3
    5694:	fcc42503          	lw	a0,-52(s0)
    5698:	00000097          	auipc	ra,0x0
    569c:	54e080e7          	jalr	1358(ra) # 5be6 <write>
    56a0:	fc950de3          	beq	a0,s1,567a <countfree+0x44>
        printf("write() failed in countfree()\n");
    56a4:	00003517          	auipc	a0,0x3
    56a8:	a5c50513          	addi	a0,a0,-1444 # 8100 <malloc+0x20f4>
    56ac:	00001097          	auipc	ra,0x1
    56b0:	8a2080e7          	jalr	-1886(ra) # 5f4e <printf>
        exit(1);
    56b4:	4505                	li	a0,1
    56b6:	00000097          	auipc	ra,0x0
    56ba:	510080e7          	jalr	1296(ra) # 5bc6 <exit>
    printf("pipe() failed in countfree()\n");
    56be:	00003517          	auipc	a0,0x3
    56c2:	a0250513          	addi	a0,a0,-1534 # 80c0 <malloc+0x20b4>
    56c6:	00001097          	auipc	ra,0x1
    56ca:	888080e7          	jalr	-1912(ra) # 5f4e <printf>
    exit(1);
    56ce:	4505                	li	a0,1
    56d0:	00000097          	auipc	ra,0x0
    56d4:	4f6080e7          	jalr	1270(ra) # 5bc6 <exit>
    printf("fork failed in countfree()\n");
    56d8:	00003517          	auipc	a0,0x3
    56dc:	a0850513          	addi	a0,a0,-1528 # 80e0 <malloc+0x20d4>
    56e0:	00001097          	auipc	ra,0x1
    56e4:	86e080e7          	jalr	-1938(ra) # 5f4e <printf>
    exit(1);
    56e8:	4505                	li	a0,1
    56ea:	00000097          	auipc	ra,0x0
    56ee:	4dc080e7          	jalr	1244(ra) # 5bc6 <exit>
      }
    }

    exit(0);
    56f2:	4501                	li	a0,0
    56f4:	00000097          	auipc	ra,0x0
    56f8:	4d2080e7          	jalr	1234(ra) # 5bc6 <exit>
  }

  close(fds[1]);
    56fc:	fcc42503          	lw	a0,-52(s0)
    5700:	00000097          	auipc	ra,0x0
    5704:	4ee080e7          	jalr	1262(ra) # 5bee <close>

  int n = 0;
    5708:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    570a:	4605                	li	a2,1
    570c:	fc740593          	addi	a1,s0,-57
    5710:	fc842503          	lw	a0,-56(s0)
    5714:	00000097          	auipc	ra,0x0
    5718:	4ca080e7          	jalr	1226(ra) # 5bde <read>
    if(cc < 0){
    571c:	00054563          	bltz	a0,5726 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5720:	c105                	beqz	a0,5740 <countfree+0x10a>
      break;
    n += 1;
    5722:	2485                	addiw	s1,s1,1
  while(1){
    5724:	b7dd                	j	570a <countfree+0xd4>
      printf("read() failed in countfree()\n");
    5726:	00003517          	auipc	a0,0x3
    572a:	9fa50513          	addi	a0,a0,-1542 # 8120 <malloc+0x2114>
    572e:	00001097          	auipc	ra,0x1
    5732:	820080e7          	jalr	-2016(ra) # 5f4e <printf>
      exit(1);
    5736:	4505                	li	a0,1
    5738:	00000097          	auipc	ra,0x0
    573c:	48e080e7          	jalr	1166(ra) # 5bc6 <exit>
  }

  close(fds[0]);
    5740:	fc842503          	lw	a0,-56(s0)
    5744:	00000097          	auipc	ra,0x0
    5748:	4aa080e7          	jalr	1194(ra) # 5bee <close>
  wait((int*)0);
    574c:	4501                	li	a0,0
    574e:	00000097          	auipc	ra,0x0
    5752:	480080e7          	jalr	1152(ra) # 5bce <wait>
  
  return n;
}
    5756:	8526                	mv	a0,s1
    5758:	70e2                	ld	ra,56(sp)
    575a:	7442                	ld	s0,48(sp)
    575c:	74a2                	ld	s1,40(sp)
    575e:	7902                	ld	s2,32(sp)
    5760:	69e2                	ld	s3,24(sp)
    5762:	6121                	addi	sp,sp,64
    5764:	8082                	ret

0000000000005766 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    5766:	711d                	addi	sp,sp,-96
    5768:	ec86                	sd	ra,88(sp)
    576a:	e8a2                	sd	s0,80(sp)
    576c:	e4a6                	sd	s1,72(sp)
    576e:	e0ca                	sd	s2,64(sp)
    5770:	fc4e                	sd	s3,56(sp)
    5772:	f852                	sd	s4,48(sp)
    5774:	f456                	sd	s5,40(sp)
    5776:	f05a                	sd	s6,32(sp)
    5778:	ec5e                	sd	s7,24(sp)
    577a:	e862                	sd	s8,16(sp)
    577c:	e466                	sd	s9,8(sp)
    577e:	e06a                	sd	s10,0(sp)
    5780:	1080                	addi	s0,sp,96
    5782:	8a2a                	mv	s4,a0
    5784:	89ae                	mv	s3,a1
    5786:	8932                	mv	s2,a2
  do {
    printf("usertests starting\n");
    5788:	00003b97          	auipc	s7,0x3
    578c:	9b8b8b93          	addi	s7,s7,-1608 # 8140 <malloc+0x2134>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
    5790:	00004b17          	auipc	s6,0x4
    5794:	880b0b13          	addi	s6,s6,-1920 # 9010 <quicktests>
      if(continuous != 2) {
    5798:	4a89                	li	s5,2
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    579a:	00003c97          	auipc	s9,0x3
    579e:	9dec8c93          	addi	s9,s9,-1570 # 8178 <malloc+0x216c>
      if (runtests(slowtests, justone)) {
    57a2:	00004c17          	auipc	s8,0x4
    57a6:	c2ec0c13          	addi	s8,s8,-978 # 93d0 <slowtests>
        printf("usertests slow tests starting\n");
    57aa:	00003d17          	auipc	s10,0x3
    57ae:	9aed0d13          	addi	s10,s10,-1618 # 8158 <malloc+0x214c>
    57b2:	a839                	j	57d0 <drivetests+0x6a>
    57b4:	856a                	mv	a0,s10
    57b6:	00000097          	auipc	ra,0x0
    57ba:	798080e7          	jalr	1944(ra) # 5f4e <printf>
    57be:	a081                	j	57fe <drivetests+0x98>
    if((free1 = countfree()) < free0) {
    57c0:	00000097          	auipc	ra,0x0
    57c4:	e76080e7          	jalr	-394(ra) # 5636 <countfree>
    57c8:	06954263          	blt	a0,s1,582c <drivetests+0xc6>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    57cc:	06098f63          	beqz	s3,584a <drivetests+0xe4>
    printf("usertests starting\n");
    57d0:	855e                	mv	a0,s7
    57d2:	00000097          	auipc	ra,0x0
    57d6:	77c080e7          	jalr	1916(ra) # 5f4e <printf>
    int free0 = countfree();
    57da:	00000097          	auipc	ra,0x0
    57de:	e5c080e7          	jalr	-420(ra) # 5636 <countfree>
    57e2:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone)) {
    57e4:	85ca                	mv	a1,s2
    57e6:	855a                	mv	a0,s6
    57e8:	00000097          	auipc	ra,0x0
    57ec:	df2080e7          	jalr	-526(ra) # 55da <runtests>
    57f0:	c119                	beqz	a0,57f6 <drivetests+0x90>
      if(continuous != 2) {
    57f2:	05599863          	bne	s3,s5,5842 <drivetests+0xdc>
    if(!quick) {
    57f6:	fc0a15e3          	bnez	s4,57c0 <drivetests+0x5a>
      if (justone == 0)
    57fa:	fa090de3          	beqz	s2,57b4 <drivetests+0x4e>
      if (runtests(slowtests, justone)) {
    57fe:	85ca                	mv	a1,s2
    5800:	8562                	mv	a0,s8
    5802:	00000097          	auipc	ra,0x0
    5806:	dd8080e7          	jalr	-552(ra) # 55da <runtests>
    580a:	d95d                	beqz	a0,57c0 <drivetests+0x5a>
        if(continuous != 2) {
    580c:	03599d63          	bne	s3,s5,5846 <drivetests+0xe0>
    if((free1 = countfree()) < free0) {
    5810:	00000097          	auipc	ra,0x0
    5814:	e26080e7          	jalr	-474(ra) # 5636 <countfree>
    5818:	fa955ae3          	bge	a0,s1,57cc <drivetests+0x66>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    581c:	8626                	mv	a2,s1
    581e:	85aa                	mv	a1,a0
    5820:	8566                	mv	a0,s9
    5822:	00000097          	auipc	ra,0x0
    5826:	72c080e7          	jalr	1836(ra) # 5f4e <printf>
      if(continuous != 2) {
    582a:	b75d                	j	57d0 <drivetests+0x6a>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    582c:	8626                	mv	a2,s1
    582e:	85aa                	mv	a1,a0
    5830:	8566                	mv	a0,s9
    5832:	00000097          	auipc	ra,0x0
    5836:	71c080e7          	jalr	1820(ra) # 5f4e <printf>
      if(continuous != 2) {
    583a:	f9598be3          	beq	s3,s5,57d0 <drivetests+0x6a>
        return 1;
    583e:	4505                	li	a0,1
    5840:	a031                	j	584c <drivetests+0xe6>
        return 1;
    5842:	4505                	li	a0,1
    5844:	a021                	j	584c <drivetests+0xe6>
          return 1;
    5846:	4505                	li	a0,1
    5848:	a011                	j	584c <drivetests+0xe6>
  return 0;
    584a:	854e                	mv	a0,s3
}
    584c:	60e6                	ld	ra,88(sp)
    584e:	6446                	ld	s0,80(sp)
    5850:	64a6                	ld	s1,72(sp)
    5852:	6906                	ld	s2,64(sp)
    5854:	79e2                	ld	s3,56(sp)
    5856:	7a42                	ld	s4,48(sp)
    5858:	7aa2                	ld	s5,40(sp)
    585a:	7b02                	ld	s6,32(sp)
    585c:	6be2                	ld	s7,24(sp)
    585e:	6c42                	ld	s8,16(sp)
    5860:	6ca2                	ld	s9,8(sp)
    5862:	6d02                	ld	s10,0(sp)
    5864:	6125                	addi	sp,sp,96
    5866:	8082                	ret

0000000000005868 <main>:

int
main(int argc, char *argv[])
{
    5868:	1101                	addi	sp,sp,-32
    586a:	ec06                	sd	ra,24(sp)
    586c:	e822                	sd	s0,16(sp)
    586e:	e426                	sd	s1,8(sp)
    5870:	e04a                	sd	s2,0(sp)
    5872:	1000                	addi	s0,sp,32
    5874:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5876:	4789                	li	a5,2
    5878:	02f50363          	beq	a0,a5,589e <main+0x36>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    587c:	4785                	li	a5,1
    587e:	06a7cd63          	blt	a5,a0,58f8 <main+0x90>
  char *justone = 0;
    5882:	4601                	li	a2,0
  int quick = 0;
    5884:	4501                	li	a0,0
  int continuous = 0;
    5886:	4481                	li	s1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    5888:	85a6                	mv	a1,s1
    588a:	00000097          	auipc	ra,0x0
    588e:	edc080e7          	jalr	-292(ra) # 5766 <drivetests>
    5892:	c949                	beqz	a0,5924 <main+0xbc>
    exit(1);
    5894:	4505                	li	a0,1
    5896:	00000097          	auipc	ra,0x0
    589a:	330080e7          	jalr	816(ra) # 5bc6 <exit>
    589e:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    58a0:	00003597          	auipc	a1,0x3
    58a4:	90858593          	addi	a1,a1,-1784 # 81a8 <malloc+0x219c>
    58a8:	00893503          	ld	a0,8(s2)
    58ac:	00000097          	auipc	ra,0x0
    58b0:	0c8080e7          	jalr	200(ra) # 5974 <strcmp>
    58b4:	cd39                	beqz	a0,5912 <main+0xaa>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    58b6:	00003597          	auipc	a1,0x3
    58ba:	94a58593          	addi	a1,a1,-1718 # 8200 <malloc+0x21f4>
    58be:	00893503          	ld	a0,8(s2)
    58c2:	00000097          	auipc	ra,0x0
    58c6:	0b2080e7          	jalr	178(ra) # 5974 <strcmp>
    58ca:	c931                	beqz	a0,591e <main+0xb6>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    58cc:	00003597          	auipc	a1,0x3
    58d0:	92c58593          	addi	a1,a1,-1748 # 81f8 <malloc+0x21ec>
    58d4:	00893503          	ld	a0,8(s2)
    58d8:	00000097          	auipc	ra,0x0
    58dc:	09c080e7          	jalr	156(ra) # 5974 <strcmp>
    58e0:	cd0d                	beqz	a0,591a <main+0xb2>
  } else if(argc == 2 && argv[1][0] != '-'){
    58e2:	00893603          	ld	a2,8(s2)
    58e6:	00064703          	lbu	a4,0(a2) # 3000 <fourteen+0x14e>
    58ea:	02d00793          	li	a5,45
    58ee:	00f70563          	beq	a4,a5,58f8 <main+0x90>
  int quick = 0;
    58f2:	4501                	li	a0,0
  int continuous = 0;
    58f4:	4481                	li	s1,0
    58f6:	bf49                	j	5888 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    58f8:	00003517          	auipc	a0,0x3
    58fc:	8b850513          	addi	a0,a0,-1864 # 81b0 <malloc+0x21a4>
    5900:	00000097          	auipc	ra,0x0
    5904:	64e080e7          	jalr	1614(ra) # 5f4e <printf>
    exit(1);
    5908:	4505                	li	a0,1
    590a:	00000097          	auipc	ra,0x0
    590e:	2bc080e7          	jalr	700(ra) # 5bc6 <exit>
  int continuous = 0;
    5912:	84aa                	mv	s1,a0
  char *justone = 0;
    5914:	4601                	li	a2,0
    quick = 1;
    5916:	4505                	li	a0,1
    5918:	bf85                	j	5888 <main+0x20>
  char *justone = 0;
    591a:	4601                	li	a2,0
    591c:	b7b5                	j	5888 <main+0x20>
    591e:	4601                	li	a2,0
    continuous = 1;
    5920:	4485                	li	s1,1
    5922:	b79d                	j	5888 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    5924:	00003517          	auipc	a0,0x3
    5928:	8bc50513          	addi	a0,a0,-1860 # 81e0 <malloc+0x21d4>
    592c:	00000097          	auipc	ra,0x0
    5930:	622080e7          	jalr	1570(ra) # 5f4e <printf>
  exit(0);
    5934:	4501                	li	a0,0
    5936:	00000097          	auipc	ra,0x0
    593a:	290080e7          	jalr	656(ra) # 5bc6 <exit>

000000000000593e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    593e:	1141                	addi	sp,sp,-16
    5940:	e406                	sd	ra,8(sp)
    5942:	e022                	sd	s0,0(sp)
    5944:	0800                	addi	s0,sp,16
  extern int main();
  main();
    5946:	00000097          	auipc	ra,0x0
    594a:	f22080e7          	jalr	-222(ra) # 5868 <main>
  exit(0);
    594e:	4501                	li	a0,0
    5950:	00000097          	auipc	ra,0x0
    5954:	276080e7          	jalr	630(ra) # 5bc6 <exit>

0000000000005958 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    5958:	1141                	addi	sp,sp,-16
    595a:	e422                	sd	s0,8(sp)
    595c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    595e:	87aa                	mv	a5,a0
    5960:	0585                	addi	a1,a1,1
    5962:	0785                	addi	a5,a5,1
    5964:	fff5c703          	lbu	a4,-1(a1)
    5968:	fee78fa3          	sb	a4,-1(a5) # fff <linktest+0x109>
    596c:	fb75                	bnez	a4,5960 <strcpy+0x8>
    ;
  return os;
}
    596e:	6422                	ld	s0,8(sp)
    5970:	0141                	addi	sp,sp,16
    5972:	8082                	ret

0000000000005974 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5974:	1141                	addi	sp,sp,-16
    5976:	e422                	sd	s0,8(sp)
    5978:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    597a:	00054783          	lbu	a5,0(a0)
    597e:	cb91                	beqz	a5,5992 <strcmp+0x1e>
    5980:	0005c703          	lbu	a4,0(a1)
    5984:	00f71763          	bne	a4,a5,5992 <strcmp+0x1e>
    p++, q++;
    5988:	0505                	addi	a0,a0,1
    598a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    598c:	00054783          	lbu	a5,0(a0)
    5990:	fbe5                	bnez	a5,5980 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5992:	0005c503          	lbu	a0,0(a1)
}
    5996:	40a7853b          	subw	a0,a5,a0
    599a:	6422                	ld	s0,8(sp)
    599c:	0141                	addi	sp,sp,16
    599e:	8082                	ret

00000000000059a0 <strlen>:

uint
strlen(const char *s)
{
    59a0:	1141                	addi	sp,sp,-16
    59a2:	e422                	sd	s0,8(sp)
    59a4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    59a6:	00054783          	lbu	a5,0(a0)
    59aa:	cf91                	beqz	a5,59c6 <strlen+0x26>
    59ac:	0505                	addi	a0,a0,1
    59ae:	87aa                	mv	a5,a0
    59b0:	4685                	li	a3,1
    59b2:	9e89                	subw	a3,a3,a0
    59b4:	00f6853b          	addw	a0,a3,a5
    59b8:	0785                	addi	a5,a5,1
    59ba:	fff7c703          	lbu	a4,-1(a5)
    59be:	fb7d                	bnez	a4,59b4 <strlen+0x14>
    ;
  return n;
}
    59c0:	6422                	ld	s0,8(sp)
    59c2:	0141                	addi	sp,sp,16
    59c4:	8082                	ret
  for(n = 0; s[n]; n++)
    59c6:	4501                	li	a0,0
    59c8:	bfe5                	j	59c0 <strlen+0x20>

00000000000059ca <memset>:

void*
memset(void *dst, int c, uint n)
{
    59ca:	1141                	addi	sp,sp,-16
    59cc:	e422                	sd	s0,8(sp)
    59ce:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    59d0:	ca19                	beqz	a2,59e6 <memset+0x1c>
    59d2:	87aa                	mv	a5,a0
    59d4:	1602                	slli	a2,a2,0x20
    59d6:	9201                	srli	a2,a2,0x20
    59d8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    59dc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    59e0:	0785                	addi	a5,a5,1
    59e2:	fee79de3          	bne	a5,a4,59dc <memset+0x12>
  }
  return dst;
}
    59e6:	6422                	ld	s0,8(sp)
    59e8:	0141                	addi	sp,sp,16
    59ea:	8082                	ret

00000000000059ec <strchr>:

char*
strchr(const char *s, char c)
{
    59ec:	1141                	addi	sp,sp,-16
    59ee:	e422                	sd	s0,8(sp)
    59f0:	0800                	addi	s0,sp,16
  for(; *s; s++)
    59f2:	00054783          	lbu	a5,0(a0)
    59f6:	cb99                	beqz	a5,5a0c <strchr+0x20>
    if(*s == c)
    59f8:	00f58763          	beq	a1,a5,5a06 <strchr+0x1a>
  for(; *s; s++)
    59fc:	0505                	addi	a0,a0,1
    59fe:	00054783          	lbu	a5,0(a0)
    5a02:	fbfd                	bnez	a5,59f8 <strchr+0xc>
      return (char*)s;
  return 0;
    5a04:	4501                	li	a0,0
}
    5a06:	6422                	ld	s0,8(sp)
    5a08:	0141                	addi	sp,sp,16
    5a0a:	8082                	ret
  return 0;
    5a0c:	4501                	li	a0,0
    5a0e:	bfe5                	j	5a06 <strchr+0x1a>

0000000000005a10 <gets>:

char*
gets(char *buf, int max)
{
    5a10:	711d                	addi	sp,sp,-96
    5a12:	ec86                	sd	ra,88(sp)
    5a14:	e8a2                	sd	s0,80(sp)
    5a16:	e4a6                	sd	s1,72(sp)
    5a18:	e0ca                	sd	s2,64(sp)
    5a1a:	fc4e                	sd	s3,56(sp)
    5a1c:	f852                	sd	s4,48(sp)
    5a1e:	f456                	sd	s5,40(sp)
    5a20:	f05a                	sd	s6,32(sp)
    5a22:	ec5e                	sd	s7,24(sp)
    5a24:	1080                	addi	s0,sp,96
    5a26:	8baa                	mv	s7,a0
    5a28:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5a2a:	892a                	mv	s2,a0
    5a2c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5a2e:	4aa9                	li	s5,10
    5a30:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5a32:	89a6                	mv	s3,s1
    5a34:	2485                	addiw	s1,s1,1
    5a36:	0344d863          	bge	s1,s4,5a66 <gets+0x56>
    cc = read(0, &c, 1);
    5a3a:	4605                	li	a2,1
    5a3c:	faf40593          	addi	a1,s0,-81
    5a40:	4501                	li	a0,0
    5a42:	00000097          	auipc	ra,0x0
    5a46:	19c080e7          	jalr	412(ra) # 5bde <read>
    if(cc < 1)
    5a4a:	00a05e63          	blez	a0,5a66 <gets+0x56>
    buf[i++] = c;
    5a4e:	faf44783          	lbu	a5,-81(s0)
    5a52:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5a56:	01578763          	beq	a5,s5,5a64 <gets+0x54>
    5a5a:	0905                	addi	s2,s2,1
    5a5c:	fd679be3          	bne	a5,s6,5a32 <gets+0x22>
  for(i=0; i+1 < max; ){
    5a60:	89a6                	mv	s3,s1
    5a62:	a011                	j	5a66 <gets+0x56>
    5a64:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5a66:	99de                	add	s3,s3,s7
    5a68:	00098023          	sb	zero,0(s3)
  return buf;
}
    5a6c:	855e                	mv	a0,s7
    5a6e:	60e6                	ld	ra,88(sp)
    5a70:	6446                	ld	s0,80(sp)
    5a72:	64a6                	ld	s1,72(sp)
    5a74:	6906                	ld	s2,64(sp)
    5a76:	79e2                	ld	s3,56(sp)
    5a78:	7a42                	ld	s4,48(sp)
    5a7a:	7aa2                	ld	s5,40(sp)
    5a7c:	7b02                	ld	s6,32(sp)
    5a7e:	6be2                	ld	s7,24(sp)
    5a80:	6125                	addi	sp,sp,96
    5a82:	8082                	ret

0000000000005a84 <stat>:

int
stat(const char *n, struct stat *st)
{
    5a84:	1101                	addi	sp,sp,-32
    5a86:	ec06                	sd	ra,24(sp)
    5a88:	e822                	sd	s0,16(sp)
    5a8a:	e426                	sd	s1,8(sp)
    5a8c:	e04a                	sd	s2,0(sp)
    5a8e:	1000                	addi	s0,sp,32
    5a90:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5a92:	4581                	li	a1,0
    5a94:	00000097          	auipc	ra,0x0
    5a98:	172080e7          	jalr	370(ra) # 5c06 <open>
  if(fd < 0)
    5a9c:	02054563          	bltz	a0,5ac6 <stat+0x42>
    5aa0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5aa2:	85ca                	mv	a1,s2
    5aa4:	00000097          	auipc	ra,0x0
    5aa8:	17a080e7          	jalr	378(ra) # 5c1e <fstat>
    5aac:	892a                	mv	s2,a0
  close(fd);
    5aae:	8526                	mv	a0,s1
    5ab0:	00000097          	auipc	ra,0x0
    5ab4:	13e080e7          	jalr	318(ra) # 5bee <close>
  return r;
}
    5ab8:	854a                	mv	a0,s2
    5aba:	60e2                	ld	ra,24(sp)
    5abc:	6442                	ld	s0,16(sp)
    5abe:	64a2                	ld	s1,8(sp)
    5ac0:	6902                	ld	s2,0(sp)
    5ac2:	6105                	addi	sp,sp,32
    5ac4:	8082                	ret
    return -1;
    5ac6:	597d                	li	s2,-1
    5ac8:	bfc5                	j	5ab8 <stat+0x34>

0000000000005aca <atoi>:

int
atoi(const char *s)
{
    5aca:	1141                	addi	sp,sp,-16
    5acc:	e422                	sd	s0,8(sp)
    5ace:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5ad0:	00054603          	lbu	a2,0(a0)
    5ad4:	fd06079b          	addiw	a5,a2,-48
    5ad8:	0ff7f793          	andi	a5,a5,255
    5adc:	4725                	li	a4,9
    5ade:	02f76963          	bltu	a4,a5,5b10 <atoi+0x46>
    5ae2:	86aa                	mv	a3,a0
  n = 0;
    5ae4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    5ae6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    5ae8:	0685                	addi	a3,a3,1
    5aea:	0025179b          	slliw	a5,a0,0x2
    5aee:	9fa9                	addw	a5,a5,a0
    5af0:	0017979b          	slliw	a5,a5,0x1
    5af4:	9fb1                	addw	a5,a5,a2
    5af6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5afa:	0006c603          	lbu	a2,0(a3)
    5afe:	fd06071b          	addiw	a4,a2,-48
    5b02:	0ff77713          	andi	a4,a4,255
    5b06:	fee5f1e3          	bgeu	a1,a4,5ae8 <atoi+0x1e>
  return n;
}
    5b0a:	6422                	ld	s0,8(sp)
    5b0c:	0141                	addi	sp,sp,16
    5b0e:	8082                	ret
  n = 0;
    5b10:	4501                	li	a0,0
    5b12:	bfe5                	j	5b0a <atoi+0x40>

0000000000005b14 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5b14:	1141                	addi	sp,sp,-16
    5b16:	e422                	sd	s0,8(sp)
    5b18:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5b1a:	02b57463          	bgeu	a0,a1,5b42 <memmove+0x2e>
    while(n-- > 0)
    5b1e:	00c05f63          	blez	a2,5b3c <memmove+0x28>
    5b22:	1602                	slli	a2,a2,0x20
    5b24:	9201                	srli	a2,a2,0x20
    5b26:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5b2a:	872a                	mv	a4,a0
      *dst++ = *src++;
    5b2c:	0585                	addi	a1,a1,1
    5b2e:	0705                	addi	a4,a4,1
    5b30:	fff5c683          	lbu	a3,-1(a1)
    5b34:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5b38:	fee79ae3          	bne	a5,a4,5b2c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5b3c:	6422                	ld	s0,8(sp)
    5b3e:	0141                	addi	sp,sp,16
    5b40:	8082                	ret
    dst += n;
    5b42:	00c50733          	add	a4,a0,a2
    src += n;
    5b46:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5b48:	fec05ae3          	blez	a2,5b3c <memmove+0x28>
    5b4c:	fff6079b          	addiw	a5,a2,-1
    5b50:	1782                	slli	a5,a5,0x20
    5b52:	9381                	srli	a5,a5,0x20
    5b54:	fff7c793          	not	a5,a5
    5b58:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5b5a:	15fd                	addi	a1,a1,-1
    5b5c:	177d                	addi	a4,a4,-1
    5b5e:	0005c683          	lbu	a3,0(a1)
    5b62:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5b66:	fee79ae3          	bne	a5,a4,5b5a <memmove+0x46>
    5b6a:	bfc9                	j	5b3c <memmove+0x28>

0000000000005b6c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5b6c:	1141                	addi	sp,sp,-16
    5b6e:	e422                	sd	s0,8(sp)
    5b70:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5b72:	ca05                	beqz	a2,5ba2 <memcmp+0x36>
    5b74:	fff6069b          	addiw	a3,a2,-1
    5b78:	1682                	slli	a3,a3,0x20
    5b7a:	9281                	srli	a3,a3,0x20
    5b7c:	0685                	addi	a3,a3,1
    5b7e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5b80:	00054783          	lbu	a5,0(a0)
    5b84:	0005c703          	lbu	a4,0(a1)
    5b88:	00e79863          	bne	a5,a4,5b98 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5b8c:	0505                	addi	a0,a0,1
    p2++;
    5b8e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5b90:	fed518e3          	bne	a0,a3,5b80 <memcmp+0x14>
  }
  return 0;
    5b94:	4501                	li	a0,0
    5b96:	a019                	j	5b9c <memcmp+0x30>
      return *p1 - *p2;
    5b98:	40e7853b          	subw	a0,a5,a4
}
    5b9c:	6422                	ld	s0,8(sp)
    5b9e:	0141                	addi	sp,sp,16
    5ba0:	8082                	ret
  return 0;
    5ba2:	4501                	li	a0,0
    5ba4:	bfe5                	j	5b9c <memcmp+0x30>

0000000000005ba6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5ba6:	1141                	addi	sp,sp,-16
    5ba8:	e406                	sd	ra,8(sp)
    5baa:	e022                	sd	s0,0(sp)
    5bac:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5bae:	00000097          	auipc	ra,0x0
    5bb2:	f66080e7          	jalr	-154(ra) # 5b14 <memmove>
}
    5bb6:	60a2                	ld	ra,8(sp)
    5bb8:	6402                	ld	s0,0(sp)
    5bba:	0141                	addi	sp,sp,16
    5bbc:	8082                	ret

0000000000005bbe <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5bbe:	4885                	li	a7,1
 ecall
    5bc0:	00000073          	ecall
 ret
    5bc4:	8082                	ret

0000000000005bc6 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5bc6:	4889                	li	a7,2
 ecall
    5bc8:	00000073          	ecall
 ret
    5bcc:	8082                	ret

0000000000005bce <wait>:
.global wait
wait:
 li a7, SYS_wait
    5bce:	488d                	li	a7,3
 ecall
    5bd0:	00000073          	ecall
 ret
    5bd4:	8082                	ret

0000000000005bd6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5bd6:	4891                	li	a7,4
 ecall
    5bd8:	00000073          	ecall
 ret
    5bdc:	8082                	ret

0000000000005bde <read>:
.global read
read:
 li a7, SYS_read
    5bde:	4895                	li	a7,5
 ecall
    5be0:	00000073          	ecall
 ret
    5be4:	8082                	ret

0000000000005be6 <write>:
.global write
write:
 li a7, SYS_write
    5be6:	48c1                	li	a7,16
 ecall
    5be8:	00000073          	ecall
 ret
    5bec:	8082                	ret

0000000000005bee <close>:
.global close
close:
 li a7, SYS_close
    5bee:	48d5                	li	a7,21
 ecall
    5bf0:	00000073          	ecall
 ret
    5bf4:	8082                	ret

0000000000005bf6 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5bf6:	4899                	li	a7,6
 ecall
    5bf8:	00000073          	ecall
 ret
    5bfc:	8082                	ret

0000000000005bfe <exec>:
.global exec
exec:
 li a7, SYS_exec
    5bfe:	489d                	li	a7,7
 ecall
    5c00:	00000073          	ecall
 ret
    5c04:	8082                	ret

0000000000005c06 <open>:
.global open
open:
 li a7, SYS_open
    5c06:	48bd                	li	a7,15
 ecall
    5c08:	00000073          	ecall
 ret
    5c0c:	8082                	ret

0000000000005c0e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5c0e:	48c5                	li	a7,17
 ecall
    5c10:	00000073          	ecall
 ret
    5c14:	8082                	ret

0000000000005c16 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5c16:	48c9                	li	a7,18
 ecall
    5c18:	00000073          	ecall
 ret
    5c1c:	8082                	ret

0000000000005c1e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5c1e:	48a1                	li	a7,8
 ecall
    5c20:	00000073          	ecall
 ret
    5c24:	8082                	ret

0000000000005c26 <link>:
.global link
link:
 li a7, SYS_link
    5c26:	48cd                	li	a7,19
 ecall
    5c28:	00000073          	ecall
 ret
    5c2c:	8082                	ret

0000000000005c2e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5c2e:	48d1                	li	a7,20
 ecall
    5c30:	00000073          	ecall
 ret
    5c34:	8082                	ret

0000000000005c36 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5c36:	48a5                	li	a7,9
 ecall
    5c38:	00000073          	ecall
 ret
    5c3c:	8082                	ret

0000000000005c3e <dup>:
.global dup
dup:
 li a7, SYS_dup
    5c3e:	48a9                	li	a7,10
 ecall
    5c40:	00000073          	ecall
 ret
    5c44:	8082                	ret

0000000000005c46 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5c46:	48ad                	li	a7,11
 ecall
    5c48:	00000073          	ecall
 ret
    5c4c:	8082                	ret

0000000000005c4e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5c4e:	48b1                	li	a7,12
 ecall
    5c50:	00000073          	ecall
 ret
    5c54:	8082                	ret

0000000000005c56 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5c56:	48b5                	li	a7,13
 ecall
    5c58:	00000073          	ecall
 ret
    5c5c:	8082                	ret

0000000000005c5e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5c5e:	48b9                	li	a7,14
 ecall
    5c60:	00000073          	ecall
 ret
    5c64:	8082                	ret

0000000000005c66 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
    5c66:	48d9                	li	a7,22
 ecall
    5c68:	00000073          	ecall
 ret
    5c6c:	8082                	ret

0000000000005c6e <getreadcount>:
.global getreadcount
getreadcount:
 li a7, SYS_getreadcount
    5c6e:	48dd                	li	a7,23
 ecall
    5c70:	00000073          	ecall
 ret
    5c74:	8082                	ret

0000000000005c76 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5c76:	1101                	addi	sp,sp,-32
    5c78:	ec06                	sd	ra,24(sp)
    5c7a:	e822                	sd	s0,16(sp)
    5c7c:	1000                	addi	s0,sp,32
    5c7e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5c82:	4605                	li	a2,1
    5c84:	fef40593          	addi	a1,s0,-17
    5c88:	00000097          	auipc	ra,0x0
    5c8c:	f5e080e7          	jalr	-162(ra) # 5be6 <write>
}
    5c90:	60e2                	ld	ra,24(sp)
    5c92:	6442                	ld	s0,16(sp)
    5c94:	6105                	addi	sp,sp,32
    5c96:	8082                	ret

0000000000005c98 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5c98:	7139                	addi	sp,sp,-64
    5c9a:	fc06                	sd	ra,56(sp)
    5c9c:	f822                	sd	s0,48(sp)
    5c9e:	f426                	sd	s1,40(sp)
    5ca0:	f04a                	sd	s2,32(sp)
    5ca2:	ec4e                	sd	s3,24(sp)
    5ca4:	0080                	addi	s0,sp,64
    5ca6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5ca8:	c299                	beqz	a3,5cae <printint+0x16>
    5caa:	0805c863          	bltz	a1,5d3a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5cae:	2581                	sext.w	a1,a1
  neg = 0;
    5cb0:	4881                	li	a7,0
    5cb2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5cb6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5cb8:	2601                	sext.w	a2,a2
    5cba:	00003517          	auipc	a0,0x3
    5cbe:	89e50513          	addi	a0,a0,-1890 # 8558 <digits>
    5cc2:	883a                	mv	a6,a4
    5cc4:	2705                	addiw	a4,a4,1
    5cc6:	02c5f7bb          	remuw	a5,a1,a2
    5cca:	1782                	slli	a5,a5,0x20
    5ccc:	9381                	srli	a5,a5,0x20
    5cce:	97aa                	add	a5,a5,a0
    5cd0:	0007c783          	lbu	a5,0(a5)
    5cd4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5cd8:	0005879b          	sext.w	a5,a1
    5cdc:	02c5d5bb          	divuw	a1,a1,a2
    5ce0:	0685                	addi	a3,a3,1
    5ce2:	fec7f0e3          	bgeu	a5,a2,5cc2 <printint+0x2a>
  if(neg)
    5ce6:	00088b63          	beqz	a7,5cfc <printint+0x64>
    buf[i++] = '-';
    5cea:	fd040793          	addi	a5,s0,-48
    5cee:	973e                	add	a4,a4,a5
    5cf0:	02d00793          	li	a5,45
    5cf4:	fef70823          	sb	a5,-16(a4)
    5cf8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5cfc:	02e05863          	blez	a4,5d2c <printint+0x94>
    5d00:	fc040793          	addi	a5,s0,-64
    5d04:	00e78933          	add	s2,a5,a4
    5d08:	fff78993          	addi	s3,a5,-1
    5d0c:	99ba                	add	s3,s3,a4
    5d0e:	377d                	addiw	a4,a4,-1
    5d10:	1702                	slli	a4,a4,0x20
    5d12:	9301                	srli	a4,a4,0x20
    5d14:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5d18:	fff94583          	lbu	a1,-1(s2)
    5d1c:	8526                	mv	a0,s1
    5d1e:	00000097          	auipc	ra,0x0
    5d22:	f58080e7          	jalr	-168(ra) # 5c76 <putc>
  while(--i >= 0)
    5d26:	197d                	addi	s2,s2,-1
    5d28:	ff3918e3          	bne	s2,s3,5d18 <printint+0x80>
}
    5d2c:	70e2                	ld	ra,56(sp)
    5d2e:	7442                	ld	s0,48(sp)
    5d30:	74a2                	ld	s1,40(sp)
    5d32:	7902                	ld	s2,32(sp)
    5d34:	69e2                	ld	s3,24(sp)
    5d36:	6121                	addi	sp,sp,64
    5d38:	8082                	ret
    x = -xx;
    5d3a:	40b005bb          	negw	a1,a1
    neg = 1;
    5d3e:	4885                	li	a7,1
    x = -xx;
    5d40:	bf8d                	j	5cb2 <printint+0x1a>

0000000000005d42 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5d42:	7119                	addi	sp,sp,-128
    5d44:	fc86                	sd	ra,120(sp)
    5d46:	f8a2                	sd	s0,112(sp)
    5d48:	f4a6                	sd	s1,104(sp)
    5d4a:	f0ca                	sd	s2,96(sp)
    5d4c:	ecce                	sd	s3,88(sp)
    5d4e:	e8d2                	sd	s4,80(sp)
    5d50:	e4d6                	sd	s5,72(sp)
    5d52:	e0da                	sd	s6,64(sp)
    5d54:	fc5e                	sd	s7,56(sp)
    5d56:	f862                	sd	s8,48(sp)
    5d58:	f466                	sd	s9,40(sp)
    5d5a:	f06a                	sd	s10,32(sp)
    5d5c:	ec6e                	sd	s11,24(sp)
    5d5e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5d60:	0005c903          	lbu	s2,0(a1)
    5d64:	18090f63          	beqz	s2,5f02 <vprintf+0x1c0>
    5d68:	8aaa                	mv	s5,a0
    5d6a:	8b32                	mv	s6,a2
    5d6c:	00158493          	addi	s1,a1,1
  state = 0;
    5d70:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5d72:	02500a13          	li	s4,37
      if(c == 'd'){
    5d76:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    5d7a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5d7e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5d82:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5d86:	00002b97          	auipc	s7,0x2
    5d8a:	7d2b8b93          	addi	s7,s7,2002 # 8558 <digits>
    5d8e:	a839                	j	5dac <vprintf+0x6a>
        putc(fd, c);
    5d90:	85ca                	mv	a1,s2
    5d92:	8556                	mv	a0,s5
    5d94:	00000097          	auipc	ra,0x0
    5d98:	ee2080e7          	jalr	-286(ra) # 5c76 <putc>
    5d9c:	a019                	j	5da2 <vprintf+0x60>
    } else if(state == '%'){
    5d9e:	01498f63          	beq	s3,s4,5dbc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5da2:	0485                	addi	s1,s1,1
    5da4:	fff4c903          	lbu	s2,-1(s1)
    5da8:	14090d63          	beqz	s2,5f02 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    5dac:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5db0:	fe0997e3          	bnez	s3,5d9e <vprintf+0x5c>
      if(c == '%'){
    5db4:	fd479ee3          	bne	a5,s4,5d90 <vprintf+0x4e>
        state = '%';
    5db8:	89be                	mv	s3,a5
    5dba:	b7e5                	j	5da2 <vprintf+0x60>
      if(c == 'd'){
    5dbc:	05878063          	beq	a5,s8,5dfc <vprintf+0xba>
      } else if(c == 'l') {
    5dc0:	05978c63          	beq	a5,s9,5e18 <vprintf+0xd6>
      } else if(c == 'x') {
    5dc4:	07a78863          	beq	a5,s10,5e34 <vprintf+0xf2>
      } else if(c == 'p') {
    5dc8:	09b78463          	beq	a5,s11,5e50 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    5dcc:	07300713          	li	a4,115
    5dd0:	0ce78663          	beq	a5,a4,5e9c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5dd4:	06300713          	li	a4,99
    5dd8:	0ee78e63          	beq	a5,a4,5ed4 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    5ddc:	11478863          	beq	a5,s4,5eec <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5de0:	85d2                	mv	a1,s4
    5de2:	8556                	mv	a0,s5
    5de4:	00000097          	auipc	ra,0x0
    5de8:	e92080e7          	jalr	-366(ra) # 5c76 <putc>
        putc(fd, c);
    5dec:	85ca                	mv	a1,s2
    5dee:	8556                	mv	a0,s5
    5df0:	00000097          	auipc	ra,0x0
    5df4:	e86080e7          	jalr	-378(ra) # 5c76 <putc>
      }
      state = 0;
    5df8:	4981                	li	s3,0
    5dfa:	b765                	j	5da2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    5dfc:	008b0913          	addi	s2,s6,8
    5e00:	4685                	li	a3,1
    5e02:	4629                	li	a2,10
    5e04:	000b2583          	lw	a1,0(s6)
    5e08:	8556                	mv	a0,s5
    5e0a:	00000097          	auipc	ra,0x0
    5e0e:	e8e080e7          	jalr	-370(ra) # 5c98 <printint>
    5e12:	8b4a                	mv	s6,s2
      state = 0;
    5e14:	4981                	li	s3,0
    5e16:	b771                	j	5da2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5e18:	008b0913          	addi	s2,s6,8
    5e1c:	4681                	li	a3,0
    5e1e:	4629                	li	a2,10
    5e20:	000b2583          	lw	a1,0(s6)
    5e24:	8556                	mv	a0,s5
    5e26:	00000097          	auipc	ra,0x0
    5e2a:	e72080e7          	jalr	-398(ra) # 5c98 <printint>
    5e2e:	8b4a                	mv	s6,s2
      state = 0;
    5e30:	4981                	li	s3,0
    5e32:	bf85                	j	5da2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5e34:	008b0913          	addi	s2,s6,8
    5e38:	4681                	li	a3,0
    5e3a:	4641                	li	a2,16
    5e3c:	000b2583          	lw	a1,0(s6)
    5e40:	8556                	mv	a0,s5
    5e42:	00000097          	auipc	ra,0x0
    5e46:	e56080e7          	jalr	-426(ra) # 5c98 <printint>
    5e4a:	8b4a                	mv	s6,s2
      state = 0;
    5e4c:	4981                	li	s3,0
    5e4e:	bf91                	j	5da2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5e50:	008b0793          	addi	a5,s6,8
    5e54:	f8f43423          	sd	a5,-120(s0)
    5e58:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5e5c:	03000593          	li	a1,48
    5e60:	8556                	mv	a0,s5
    5e62:	00000097          	auipc	ra,0x0
    5e66:	e14080e7          	jalr	-492(ra) # 5c76 <putc>
  putc(fd, 'x');
    5e6a:	85ea                	mv	a1,s10
    5e6c:	8556                	mv	a0,s5
    5e6e:	00000097          	auipc	ra,0x0
    5e72:	e08080e7          	jalr	-504(ra) # 5c76 <putc>
    5e76:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5e78:	03c9d793          	srli	a5,s3,0x3c
    5e7c:	97de                	add	a5,a5,s7
    5e7e:	0007c583          	lbu	a1,0(a5)
    5e82:	8556                	mv	a0,s5
    5e84:	00000097          	auipc	ra,0x0
    5e88:	df2080e7          	jalr	-526(ra) # 5c76 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5e8c:	0992                	slli	s3,s3,0x4
    5e8e:	397d                	addiw	s2,s2,-1
    5e90:	fe0914e3          	bnez	s2,5e78 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5e94:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5e98:	4981                	li	s3,0
    5e9a:	b721                	j	5da2 <vprintf+0x60>
        s = va_arg(ap, char*);
    5e9c:	008b0993          	addi	s3,s6,8
    5ea0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    5ea4:	02090163          	beqz	s2,5ec6 <vprintf+0x184>
        while(*s != 0){
    5ea8:	00094583          	lbu	a1,0(s2)
    5eac:	c9a1                	beqz	a1,5efc <vprintf+0x1ba>
          putc(fd, *s);
    5eae:	8556                	mv	a0,s5
    5eb0:	00000097          	auipc	ra,0x0
    5eb4:	dc6080e7          	jalr	-570(ra) # 5c76 <putc>
          s++;
    5eb8:	0905                	addi	s2,s2,1
        while(*s != 0){
    5eba:	00094583          	lbu	a1,0(s2)
    5ebe:	f9e5                	bnez	a1,5eae <vprintf+0x16c>
        s = va_arg(ap, char*);
    5ec0:	8b4e                	mv	s6,s3
      state = 0;
    5ec2:	4981                	li	s3,0
    5ec4:	bdf9                	j	5da2 <vprintf+0x60>
          s = "(null)";
    5ec6:	00002917          	auipc	s2,0x2
    5eca:	68a90913          	addi	s2,s2,1674 # 8550 <malloc+0x2544>
        while(*s != 0){
    5ece:	02800593          	li	a1,40
    5ed2:	bff1                	j	5eae <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5ed4:	008b0913          	addi	s2,s6,8
    5ed8:	000b4583          	lbu	a1,0(s6)
    5edc:	8556                	mv	a0,s5
    5ede:	00000097          	auipc	ra,0x0
    5ee2:	d98080e7          	jalr	-616(ra) # 5c76 <putc>
    5ee6:	8b4a                	mv	s6,s2
      state = 0;
    5ee8:	4981                	li	s3,0
    5eea:	bd65                	j	5da2 <vprintf+0x60>
        putc(fd, c);
    5eec:	85d2                	mv	a1,s4
    5eee:	8556                	mv	a0,s5
    5ef0:	00000097          	auipc	ra,0x0
    5ef4:	d86080e7          	jalr	-634(ra) # 5c76 <putc>
      state = 0;
    5ef8:	4981                	li	s3,0
    5efa:	b565                	j	5da2 <vprintf+0x60>
        s = va_arg(ap, char*);
    5efc:	8b4e                	mv	s6,s3
      state = 0;
    5efe:	4981                	li	s3,0
    5f00:	b54d                	j	5da2 <vprintf+0x60>
    }
  }
}
    5f02:	70e6                	ld	ra,120(sp)
    5f04:	7446                	ld	s0,112(sp)
    5f06:	74a6                	ld	s1,104(sp)
    5f08:	7906                	ld	s2,96(sp)
    5f0a:	69e6                	ld	s3,88(sp)
    5f0c:	6a46                	ld	s4,80(sp)
    5f0e:	6aa6                	ld	s5,72(sp)
    5f10:	6b06                	ld	s6,64(sp)
    5f12:	7be2                	ld	s7,56(sp)
    5f14:	7c42                	ld	s8,48(sp)
    5f16:	7ca2                	ld	s9,40(sp)
    5f18:	7d02                	ld	s10,32(sp)
    5f1a:	6de2                	ld	s11,24(sp)
    5f1c:	6109                	addi	sp,sp,128
    5f1e:	8082                	ret

0000000000005f20 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5f20:	715d                	addi	sp,sp,-80
    5f22:	ec06                	sd	ra,24(sp)
    5f24:	e822                	sd	s0,16(sp)
    5f26:	1000                	addi	s0,sp,32
    5f28:	e010                	sd	a2,0(s0)
    5f2a:	e414                	sd	a3,8(s0)
    5f2c:	e818                	sd	a4,16(s0)
    5f2e:	ec1c                	sd	a5,24(s0)
    5f30:	03043023          	sd	a6,32(s0)
    5f34:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5f38:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5f3c:	8622                	mv	a2,s0
    5f3e:	00000097          	auipc	ra,0x0
    5f42:	e04080e7          	jalr	-508(ra) # 5d42 <vprintf>
}
    5f46:	60e2                	ld	ra,24(sp)
    5f48:	6442                	ld	s0,16(sp)
    5f4a:	6161                	addi	sp,sp,80
    5f4c:	8082                	ret

0000000000005f4e <printf>:

void
printf(const char *fmt, ...)
{
    5f4e:	711d                	addi	sp,sp,-96
    5f50:	ec06                	sd	ra,24(sp)
    5f52:	e822                	sd	s0,16(sp)
    5f54:	1000                	addi	s0,sp,32
    5f56:	e40c                	sd	a1,8(s0)
    5f58:	e810                	sd	a2,16(s0)
    5f5a:	ec14                	sd	a3,24(s0)
    5f5c:	f018                	sd	a4,32(s0)
    5f5e:	f41c                	sd	a5,40(s0)
    5f60:	03043823          	sd	a6,48(s0)
    5f64:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5f68:	00840613          	addi	a2,s0,8
    5f6c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5f70:	85aa                	mv	a1,a0
    5f72:	4505                	li	a0,1
    5f74:	00000097          	auipc	ra,0x0
    5f78:	dce080e7          	jalr	-562(ra) # 5d42 <vprintf>
}
    5f7c:	60e2                	ld	ra,24(sp)
    5f7e:	6442                	ld	s0,16(sp)
    5f80:	6125                	addi	sp,sp,96
    5f82:	8082                	ret

0000000000005f84 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5f84:	1141                	addi	sp,sp,-16
    5f86:	e422                	sd	s0,8(sp)
    5f88:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5f8a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5f8e:	00003797          	auipc	a5,0x3
    5f92:	4a27b783          	ld	a5,1186(a5) # 9430 <freep>
    5f96:	a805                	j	5fc6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5f98:	4618                	lw	a4,8(a2)
    5f9a:	9db9                	addw	a1,a1,a4
    5f9c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5fa0:	6398                	ld	a4,0(a5)
    5fa2:	6318                	ld	a4,0(a4)
    5fa4:	fee53823          	sd	a4,-16(a0)
    5fa8:	a091                	j	5fec <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5faa:	ff852703          	lw	a4,-8(a0)
    5fae:	9e39                	addw	a2,a2,a4
    5fb0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5fb2:	ff053703          	ld	a4,-16(a0)
    5fb6:	e398                	sd	a4,0(a5)
    5fb8:	a099                	j	5ffe <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5fba:	6398                	ld	a4,0(a5)
    5fbc:	00e7e463          	bltu	a5,a4,5fc4 <free+0x40>
    5fc0:	00e6ea63          	bltu	a3,a4,5fd4 <free+0x50>
{
    5fc4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5fc6:	fed7fae3          	bgeu	a5,a3,5fba <free+0x36>
    5fca:	6398                	ld	a4,0(a5)
    5fcc:	00e6e463          	bltu	a3,a4,5fd4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5fd0:	fee7eae3          	bltu	a5,a4,5fc4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5fd4:	ff852583          	lw	a1,-8(a0)
    5fd8:	6390                	ld	a2,0(a5)
    5fda:	02059713          	slli	a4,a1,0x20
    5fde:	9301                	srli	a4,a4,0x20
    5fe0:	0712                	slli	a4,a4,0x4
    5fe2:	9736                	add	a4,a4,a3
    5fe4:	fae60ae3          	beq	a2,a4,5f98 <free+0x14>
    bp->s.ptr = p->s.ptr;
    5fe8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5fec:	4790                	lw	a2,8(a5)
    5fee:	02061713          	slli	a4,a2,0x20
    5ff2:	9301                	srli	a4,a4,0x20
    5ff4:	0712                	slli	a4,a4,0x4
    5ff6:	973e                	add	a4,a4,a5
    5ff8:	fae689e3          	beq	a3,a4,5faa <free+0x26>
  } else
    p->s.ptr = bp;
    5ffc:	e394                	sd	a3,0(a5)
  freep = p;
    5ffe:	00003717          	auipc	a4,0x3
    6002:	42f73923          	sd	a5,1074(a4) # 9430 <freep>
}
    6006:	6422                	ld	s0,8(sp)
    6008:	0141                	addi	sp,sp,16
    600a:	8082                	ret

000000000000600c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    600c:	7139                	addi	sp,sp,-64
    600e:	fc06                	sd	ra,56(sp)
    6010:	f822                	sd	s0,48(sp)
    6012:	f426                	sd	s1,40(sp)
    6014:	f04a                	sd	s2,32(sp)
    6016:	ec4e                	sd	s3,24(sp)
    6018:	e852                	sd	s4,16(sp)
    601a:	e456                	sd	s5,8(sp)
    601c:	e05a                	sd	s6,0(sp)
    601e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    6020:	02051493          	slli	s1,a0,0x20
    6024:	9081                	srli	s1,s1,0x20
    6026:	04bd                	addi	s1,s1,15
    6028:	8091                	srli	s1,s1,0x4
    602a:	0014899b          	addiw	s3,s1,1
    602e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    6030:	00003517          	auipc	a0,0x3
    6034:	40053503          	ld	a0,1024(a0) # 9430 <freep>
    6038:	c515                	beqz	a0,6064 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    603a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    603c:	4798                	lw	a4,8(a5)
    603e:	02977f63          	bgeu	a4,s1,607c <malloc+0x70>
    6042:	8a4e                	mv	s4,s3
    6044:	0009871b          	sext.w	a4,s3
    6048:	6685                	lui	a3,0x1
    604a:	00d77363          	bgeu	a4,a3,6050 <malloc+0x44>
    604e:	6a05                	lui	s4,0x1
    6050:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    6054:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    6058:	00003917          	auipc	s2,0x3
    605c:	3d890913          	addi	s2,s2,984 # 9430 <freep>
  if(p == (char*)-1)
    6060:	5afd                	li	s5,-1
    6062:	a88d                	j	60d4 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    6064:	0000a797          	auipc	a5,0xa
    6068:	bf478793          	addi	a5,a5,-1036 # fc58 <base>
    606c:	00003717          	auipc	a4,0x3
    6070:	3cf73223          	sd	a5,964(a4) # 9430 <freep>
    6074:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    6076:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    607a:	b7e1                	j	6042 <malloc+0x36>
      if(p->s.size == nunits)
    607c:	02e48b63          	beq	s1,a4,60b2 <malloc+0xa6>
        p->s.size -= nunits;
    6080:	4137073b          	subw	a4,a4,s3
    6084:	c798                	sw	a4,8(a5)
        p += p->s.size;
    6086:	1702                	slli	a4,a4,0x20
    6088:	9301                	srli	a4,a4,0x20
    608a:	0712                	slli	a4,a4,0x4
    608c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    608e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    6092:	00003717          	auipc	a4,0x3
    6096:	38a73f23          	sd	a0,926(a4) # 9430 <freep>
      return (void*)(p + 1);
    609a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    609e:	70e2                	ld	ra,56(sp)
    60a0:	7442                	ld	s0,48(sp)
    60a2:	74a2                	ld	s1,40(sp)
    60a4:	7902                	ld	s2,32(sp)
    60a6:	69e2                	ld	s3,24(sp)
    60a8:	6a42                	ld	s4,16(sp)
    60aa:	6aa2                	ld	s5,8(sp)
    60ac:	6b02                	ld	s6,0(sp)
    60ae:	6121                	addi	sp,sp,64
    60b0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    60b2:	6398                	ld	a4,0(a5)
    60b4:	e118                	sd	a4,0(a0)
    60b6:	bff1                	j	6092 <malloc+0x86>
  hp->s.size = nu;
    60b8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    60bc:	0541                	addi	a0,a0,16
    60be:	00000097          	auipc	ra,0x0
    60c2:	ec6080e7          	jalr	-314(ra) # 5f84 <free>
  return freep;
    60c6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    60ca:	d971                	beqz	a0,609e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    60cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    60ce:	4798                	lw	a4,8(a5)
    60d0:	fa9776e3          	bgeu	a4,s1,607c <malloc+0x70>
    if(p == freep)
    60d4:	00093703          	ld	a4,0(s2)
    60d8:	853e                	mv	a0,a5
    60da:	fef719e3          	bne	a4,a5,60cc <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    60de:	8552                	mv	a0,s4
    60e0:	00000097          	auipc	ra,0x0
    60e4:	b6e080e7          	jalr	-1170(ra) # 5c4e <sbrk>
  if(p == (char*)-1)
    60e8:	fd5518e3          	bne	a0,s5,60b8 <malloc+0xac>
        return 0;
    60ec:	4501                	li	a0,0
    60ee:	bf45                	j	609e <malloc+0x92>
