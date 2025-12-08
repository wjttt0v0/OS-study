
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/file.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int main() {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    printf("init running\n");
   8:	00001517          	auipc	a0,0x1
   c:	8c850513          	addi	a0,a0,-1848 # 8d0 <uptime+0xa>
  10:	66c000ef          	jal	67c <printf>
    exec("test", 0);
  14:	4581                	li	a1,0
  16:	00001517          	auipc	a0,0x1
  1a:	8ca50513          	addi	a0,a0,-1846 # 8e0 <uptime+0x1a>
  1e:	049000ef          	jal	866 <exec>
    exit(0);
  22:	4501                	li	a0,0
  24:	00b000ef          	jal	82e <exit>

0000000000000028 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  28:	1141                	addi	sp,sp,-16
  2a:	e406                	sd	ra,8(sp)
  2c:	e022                	sd	s0,0(sp)
  2e:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  30:	fd1ff0ef          	jal	0 <main>
  exit(r);
  34:	7fa000ef          	jal	82e <exit>

0000000000000038 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  38:	1141                	addi	sp,sp,-16
  3a:	e406                	sd	ra,8(sp)
  3c:	e022                	sd	s0,0(sp)
  3e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  40:	87aa                	mv	a5,a0
  42:	0585                	addi	a1,a1,1
  44:	0785                	addi	a5,a5,1
  46:	fff5c703          	lbu	a4,-1(a1)
  4a:	fee78fa3          	sb	a4,-1(a5)
  4e:	fb75                	bnez	a4,42 <strcpy+0xa>
    ;
  return os;
}
  50:	60a2                	ld	ra,8(sp)
  52:	6402                	ld	s0,0(sp)
  54:	0141                	addi	sp,sp,16
  56:	8082                	ret

0000000000000058 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  58:	1141                	addi	sp,sp,-16
  5a:	e406                	sd	ra,8(sp)
  5c:	e022                	sd	s0,0(sp)
  5e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  60:	00054783          	lbu	a5,0(a0)
  64:	cb91                	beqz	a5,78 <strcmp+0x20>
  66:	0005c703          	lbu	a4,0(a1)
  6a:	00f71763          	bne	a4,a5,78 <strcmp+0x20>
    p++, q++;
  6e:	0505                	addi	a0,a0,1
  70:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  72:	00054783          	lbu	a5,0(a0)
  76:	fbe5                	bnez	a5,66 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  78:	0005c503          	lbu	a0,0(a1)
}
  7c:	40a7853b          	subw	a0,a5,a0
  80:	60a2                	ld	ra,8(sp)
  82:	6402                	ld	s0,0(sp)
  84:	0141                	addi	sp,sp,16
  86:	8082                	ret

0000000000000088 <strlen>:

uint
strlen(const char *s)
{
  88:	1141                	addi	sp,sp,-16
  8a:	e406                	sd	ra,8(sp)
  8c:	e022                	sd	s0,0(sp)
  8e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  90:	00054783          	lbu	a5,0(a0)
  94:	cf91                	beqz	a5,b0 <strlen+0x28>
  96:	00150793          	addi	a5,a0,1
  9a:	86be                	mv	a3,a5
  9c:	0785                	addi	a5,a5,1
  9e:	fff7c703          	lbu	a4,-1(a5)
  a2:	ff65                	bnez	a4,9a <strlen+0x12>
  a4:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  a8:	60a2                	ld	ra,8(sp)
  aa:	6402                	ld	s0,0(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret
  for(n = 0; s[n]; n++)
  b0:	4501                	li	a0,0
  b2:	bfdd                	j	a8 <strlen+0x20>

00000000000000b4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e406                	sd	ra,8(sp)
  b8:	e022                	sd	s0,0(sp)
  ba:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  bc:	ca19                	beqz	a2,d2 <memset+0x1e>
  be:	87aa                	mv	a5,a0
  c0:	1602                	slli	a2,a2,0x20
  c2:	9201                	srli	a2,a2,0x20
  c4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  cc:	0785                	addi	a5,a5,1
  ce:	fee79de3          	bne	a5,a4,c8 <memset+0x14>
  }
  return dst;
}
  d2:	60a2                	ld	ra,8(sp)
  d4:	6402                	ld	s0,0(sp)
  d6:	0141                	addi	sp,sp,16
  d8:	8082                	ret

00000000000000da <strchr>:

char*
strchr(const char *s, char c)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e406                	sd	ra,8(sp)
  de:	e022                	sd	s0,0(sp)
  e0:	0800                	addi	s0,sp,16
  for(; *s; s++)
  e2:	00054783          	lbu	a5,0(a0)
  e6:	cf81                	beqz	a5,fe <strchr+0x24>
    if(*s == c)
  e8:	00f58763          	beq	a1,a5,f6 <strchr+0x1c>
  for(; *s; s++)
  ec:	0505                	addi	a0,a0,1
  ee:	00054783          	lbu	a5,0(a0)
  f2:	fbfd                	bnez	a5,e8 <strchr+0xe>
      return (char*)s;
  return 0;
  f4:	4501                	li	a0,0
}
  f6:	60a2                	ld	ra,8(sp)
  f8:	6402                	ld	s0,0(sp)
  fa:	0141                	addi	sp,sp,16
  fc:	8082                	ret
  return 0;
  fe:	4501                	li	a0,0
 100:	bfdd                	j	f6 <strchr+0x1c>

0000000000000102 <gets>:

char*
gets(char *buf, int max)
{
 102:	711d                	addi	sp,sp,-96
 104:	ec86                	sd	ra,88(sp)
 106:	e8a2                	sd	s0,80(sp)
 108:	e4a6                	sd	s1,72(sp)
 10a:	e0ca                	sd	s2,64(sp)
 10c:	fc4e                	sd	s3,56(sp)
 10e:	f852                	sd	s4,48(sp)
 110:	f456                	sd	s5,40(sp)
 112:	f05a                	sd	s6,32(sp)
 114:	ec5e                	sd	s7,24(sp)
 116:	e862                	sd	s8,16(sp)
 118:	1080                	addi	s0,sp,96
 11a:	8baa                	mv	s7,a0
 11c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11e:	892a                	mv	s2,a0
 120:	4481                	li	s1,0
    cc = read(0, &c, 1);
 122:	faf40b13          	addi	s6,s0,-81
 126:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 128:	8c26                	mv	s8,s1
 12a:	0014899b          	addiw	s3,s1,1
 12e:	84ce                	mv	s1,s3
 130:	0349d463          	bge	s3,s4,158 <gets+0x56>
    cc = read(0, &c, 1);
 134:	8656                	mv	a2,s5
 136:	85da                	mv	a1,s6
 138:	4501                	li	a0,0
 13a:	70c000ef          	jal	846 <read>
    if(cc < 1)
 13e:	00a05d63          	blez	a0,158 <gets+0x56>
      break;
    buf[i++] = c;
 142:	faf44783          	lbu	a5,-81(s0)
 146:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 14a:	0905                	addi	s2,s2,1
 14c:	ff678713          	addi	a4,a5,-10
 150:	c319                	beqz	a4,156 <gets+0x54>
 152:	17cd                	addi	a5,a5,-13
 154:	fbf1                	bnez	a5,128 <gets+0x26>
    buf[i++] = c;
 156:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 158:	9c5e                	add	s8,s8,s7
 15a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 15e:	855e                	mv	a0,s7
 160:	60e6                	ld	ra,88(sp)
 162:	6446                	ld	s0,80(sp)
 164:	64a6                	ld	s1,72(sp)
 166:	6906                	ld	s2,64(sp)
 168:	79e2                	ld	s3,56(sp)
 16a:	7a42                	ld	s4,48(sp)
 16c:	7aa2                	ld	s5,40(sp)
 16e:	7b02                	ld	s6,32(sp)
 170:	6be2                	ld	s7,24(sp)
 172:	6c42                	ld	s8,16(sp)
 174:	6125                	addi	sp,sp,96
 176:	8082                	ret

0000000000000178 <stat>:

int
stat(const char *n, struct stat *st)
{
 178:	1101                	addi	sp,sp,-32
 17a:	ec06                	sd	ra,24(sp)
 17c:	e822                	sd	s0,16(sp)
 17e:	e04a                	sd	s2,0(sp)
 180:	1000                	addi	s0,sp,32
 182:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 184:	4581                	li	a1,0
 186:	6e8000ef          	jal	86e <open>
  if(fd < 0)
 18a:	02054263          	bltz	a0,1ae <stat+0x36>
 18e:	e426                	sd	s1,8(sp)
 190:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 192:	85ca                	mv	a1,s2
 194:	6f2000ef          	jal	886 <fstat>
 198:	892a                	mv	s2,a0
  close(fd);
 19a:	8526                	mv	a0,s1
 19c:	6ba000ef          	jal	856 <close>
  return r;
 1a0:	64a2                	ld	s1,8(sp)
}
 1a2:	854a                	mv	a0,s2
 1a4:	60e2                	ld	ra,24(sp)
 1a6:	6442                	ld	s0,16(sp)
 1a8:	6902                	ld	s2,0(sp)
 1aa:	6105                	addi	sp,sp,32
 1ac:	8082                	ret
    return -1;
 1ae:	57fd                	li	a5,-1
 1b0:	893e                	mv	s2,a5
 1b2:	bfc5                	j	1a2 <stat+0x2a>

00000000000001b4 <atoi>:

int
atoi(const char *s)
{
 1b4:	1141                	addi	sp,sp,-16
 1b6:	e406                	sd	ra,8(sp)
 1b8:	e022                	sd	s0,0(sp)
 1ba:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1bc:	00054683          	lbu	a3,0(a0)
 1c0:	fd06879b          	addiw	a5,a3,-48
 1c4:	0ff7f793          	zext.b	a5,a5
 1c8:	4625                	li	a2,9
 1ca:	02f66963          	bltu	a2,a5,1fc <atoi+0x48>
 1ce:	872a                	mv	a4,a0
  n = 0;
 1d0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1d2:	0705                	addi	a4,a4,1
 1d4:	0025179b          	slliw	a5,a0,0x2
 1d8:	9fa9                	addw	a5,a5,a0
 1da:	0017979b          	slliw	a5,a5,0x1
 1de:	9fb5                	addw	a5,a5,a3
 1e0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1e4:	00074683          	lbu	a3,0(a4)
 1e8:	fd06879b          	addiw	a5,a3,-48
 1ec:	0ff7f793          	zext.b	a5,a5
 1f0:	fef671e3          	bgeu	a2,a5,1d2 <atoi+0x1e>
  return n;
}
 1f4:	60a2                	ld	ra,8(sp)
 1f6:	6402                	ld	s0,0(sp)
 1f8:	0141                	addi	sp,sp,16
 1fa:	8082                	ret
  n = 0;
 1fc:	4501                	li	a0,0
 1fe:	bfdd                	j	1f4 <atoi+0x40>

0000000000000200 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 200:	1141                	addi	sp,sp,-16
 202:	e406                	sd	ra,8(sp)
 204:	e022                	sd	s0,0(sp)
 206:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 208:	02b57563          	bgeu	a0,a1,232 <memmove+0x32>
    while(n-- > 0)
 20c:	00c05f63          	blez	a2,22a <memmove+0x2a>
 210:	1602                	slli	a2,a2,0x20
 212:	9201                	srli	a2,a2,0x20
 214:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 218:	872a                	mv	a4,a0
      *dst++ = *src++;
 21a:	0585                	addi	a1,a1,1
 21c:	0705                	addi	a4,a4,1
 21e:	fff5c683          	lbu	a3,-1(a1)
 222:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 226:	fee79ae3          	bne	a5,a4,21a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 22a:	60a2                	ld	ra,8(sp)
 22c:	6402                	ld	s0,0(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret
    while(n-- > 0)
 232:	fec05ce3          	blez	a2,22a <memmove+0x2a>
    dst += n;
 236:	00c50733          	add	a4,a0,a2
    src += n;
 23a:	95b2                	add	a1,a1,a2
 23c:	fff6079b          	addiw	a5,a2,-1
 240:	1782                	slli	a5,a5,0x20
 242:	9381                	srli	a5,a5,0x20
 244:	fff7c793          	not	a5,a5
 248:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 24a:	15fd                	addi	a1,a1,-1
 24c:	177d                	addi	a4,a4,-1
 24e:	0005c683          	lbu	a3,0(a1)
 252:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 256:	fef71ae3          	bne	a4,a5,24a <memmove+0x4a>
 25a:	bfc1                	j	22a <memmove+0x2a>

000000000000025c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e406                	sd	ra,8(sp)
 260:	e022                	sd	s0,0(sp)
 262:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 264:	c61d                	beqz	a2,292 <memcmp+0x36>
 266:	1602                	slli	a2,a2,0x20
 268:	9201                	srli	a2,a2,0x20
 26a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 26e:	00054783          	lbu	a5,0(a0)
 272:	0005c703          	lbu	a4,0(a1)
 276:	00e79863          	bne	a5,a4,286 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 27a:	0505                	addi	a0,a0,1
    p2++;
 27c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 27e:	fed518e3          	bne	a0,a3,26e <memcmp+0x12>
  }
  return 0;
 282:	4501                	li	a0,0
 284:	a019                	j	28a <memcmp+0x2e>
      return *p1 - *p2;
 286:	40e7853b          	subw	a0,a5,a4
}
 28a:	60a2                	ld	ra,8(sp)
 28c:	6402                	ld	s0,0(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret
  return 0;
 292:	4501                	li	a0,0
 294:	bfdd                	j	28a <memcmp+0x2e>

0000000000000296 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 296:	1141                	addi	sp,sp,-16
 298:	e406                	sd	ra,8(sp)
 29a:	e022                	sd	s0,0(sp)
 29c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 29e:	f63ff0ef          	jal	200 <memmove>
}
 2a2:	60a2                	ld	ra,8(sp)
 2a4:	6402                	ld	s0,0(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret

00000000000002aa <sbrk>:

char *
sbrk(int n) {
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e406                	sd	ra,8(sp)
 2ae:	e022                	sd	s0,0(sp)
 2b0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2b2:	4585                	li	a1,1
 2b4:	602000ef          	jal	8b6 <sys_sbrk>
}
 2b8:	60a2                	ld	ra,8(sp)
 2ba:	6402                	ld	s0,0(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret

00000000000002c0 <sbrklazy>:

char *
sbrklazy(int n) {
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e406                	sd	ra,8(sp)
 2c4:	e022                	sd	s0,0(sp)
 2c6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2c8:	4589                	li	a1,2
 2ca:	5ec000ef          	jal	8b6 <sys_sbrk>
}
 2ce:	60a2                	ld	ra,8(sp)
 2d0:	6402                	ld	s0,0(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret

00000000000002d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 2d6:	1101                	addi	sp,sp,-32
 2d8:	ec06                	sd	ra,24(sp)
 2da:	e822                	sd	s0,16(sp)
 2dc:	1000                	addi	s0,sp,32
 2de:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 2e2:	4605                	li	a2,1
 2e4:	fef40593          	addi	a1,s0,-17
 2e8:	566000ef          	jal	84e <write>
}
 2ec:	60e2                	ld	ra,24(sp)
 2ee:	6442                	ld	s0,16(sp)
 2f0:	6105                	addi	sp,sp,32
 2f2:	8082                	ret

00000000000002f4 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 2f4:	715d                	addi	sp,sp,-80
 2f6:	e486                	sd	ra,72(sp)
 2f8:	e0a2                	sd	s0,64(sp)
 2fa:	f84a                	sd	s2,48(sp)
 2fc:	f44e                	sd	s3,40(sp)
 2fe:	0880                	addi	s0,sp,80
 300:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 302:	c6d1                	beqz	a3,38e <printint+0x9a>
 304:	0805d563          	bgez	a1,38e <printint+0x9a>
    neg = 1;
    x = -xx;
 308:	40b005b3          	neg	a1,a1
    neg = 1;
 30c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 30e:	fb840993          	addi	s3,s0,-72
  neg = 0;
 312:	86ce                	mv	a3,s3
  i = 0;
 314:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 316:	00000817          	auipc	a6,0x0
 31a:	5da80813          	addi	a6,a6,1498 # 8f0 <digits>
 31e:	88ba                	mv	a7,a4
 320:	0017051b          	addiw	a0,a4,1
 324:	872a                	mv	a4,a0
 326:	02c5f7b3          	remu	a5,a1,a2
 32a:	97c2                	add	a5,a5,a6
 32c:	0007c783          	lbu	a5,0(a5)
 330:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 334:	87ae                	mv	a5,a1
 336:	02c5d5b3          	divu	a1,a1,a2
 33a:	0685                	addi	a3,a3,1
 33c:	fec7f1e3          	bgeu	a5,a2,31e <printint+0x2a>
  if(neg)
 340:	00030c63          	beqz	t1,358 <printint+0x64>
    buf[i++] = '-';
 344:	fd050793          	addi	a5,a0,-48
 348:	00878533          	add	a0,a5,s0
 34c:	02d00793          	li	a5,45
 350:	fef50423          	sb	a5,-24(a0)
 354:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 358:	02e05563          	blez	a4,382 <printint+0x8e>
 35c:	fc26                	sd	s1,56(sp)
 35e:	377d                	addiw	a4,a4,-1
 360:	00e984b3          	add	s1,s3,a4
 364:	19fd                	addi	s3,s3,-1
 366:	99ba                	add	s3,s3,a4
 368:	1702                	slli	a4,a4,0x20
 36a:	9301                	srli	a4,a4,0x20
 36c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 370:	0004c583          	lbu	a1,0(s1)
 374:	854a                	mv	a0,s2
 376:	f61ff0ef          	jal	2d6 <putc>
  while(--i >= 0)
 37a:	14fd                	addi	s1,s1,-1
 37c:	ff349ae3          	bne	s1,s3,370 <printint+0x7c>
 380:	74e2                	ld	s1,56(sp)
}
 382:	60a6                	ld	ra,72(sp)
 384:	6406                	ld	s0,64(sp)
 386:	7942                	ld	s2,48(sp)
 388:	79a2                	ld	s3,40(sp)
 38a:	6161                	addi	sp,sp,80
 38c:	8082                	ret
  neg = 0;
 38e:	4301                	li	t1,0
 390:	bfbd                	j	30e <printint+0x1a>

0000000000000392 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 392:	711d                	addi	sp,sp,-96
 394:	ec86                	sd	ra,88(sp)
 396:	e8a2                	sd	s0,80(sp)
 398:	e4a6                	sd	s1,72(sp)
 39a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 39c:	0005c483          	lbu	s1,0(a1)
 3a0:	22048363          	beqz	s1,5c6 <vprintf+0x234>
 3a4:	e0ca                	sd	s2,64(sp)
 3a6:	fc4e                	sd	s3,56(sp)
 3a8:	f852                	sd	s4,48(sp)
 3aa:	f456                	sd	s5,40(sp)
 3ac:	f05a                	sd	s6,32(sp)
 3ae:	ec5e                	sd	s7,24(sp)
 3b0:	e862                	sd	s8,16(sp)
 3b2:	8b2a                	mv	s6,a0
 3b4:	8a2e                	mv	s4,a1
 3b6:	8bb2                	mv	s7,a2
  state = 0;
 3b8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 3ba:	4901                	li	s2,0
 3bc:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 3be:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 3c2:	06400c13          	li	s8,100
 3c6:	a00d                	j	3e8 <vprintf+0x56>
        putc(fd, c0);
 3c8:	85a6                	mv	a1,s1
 3ca:	855a                	mv	a0,s6
 3cc:	f0bff0ef          	jal	2d6 <putc>
 3d0:	a019                	j	3d6 <vprintf+0x44>
    } else if(state == '%'){
 3d2:	03598363          	beq	s3,s5,3f8 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 3d6:	0019079b          	addiw	a5,s2,1
 3da:	893e                	mv	s2,a5
 3dc:	873e                	mv	a4,a5
 3de:	97d2                	add	a5,a5,s4
 3e0:	0007c483          	lbu	s1,0(a5)
 3e4:	1c048a63          	beqz	s1,5b8 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 3e8:	0004879b          	sext.w	a5,s1
    if(state == 0){
 3ec:	fe0993e3          	bnez	s3,3d2 <vprintf+0x40>
      if(c0 == '%'){
 3f0:	fd579ce3          	bne	a5,s5,3c8 <vprintf+0x36>
        state = '%';
 3f4:	89be                	mv	s3,a5
 3f6:	b7c5                	j	3d6 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 3f8:	00ea06b3          	add	a3,s4,a4
 3fc:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 400:	1c060863          	beqz	a2,5d0 <vprintf+0x23e>
      if(c0 == 'd'){
 404:	03878763          	beq	a5,s8,432 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 408:	f9478693          	addi	a3,a5,-108
 40c:	0016b693          	seqz	a3,a3
 410:	f9c60593          	addi	a1,a2,-100
 414:	e99d                	bnez	a1,44a <vprintf+0xb8>
 416:	ca95                	beqz	a3,44a <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 418:	008b8493          	addi	s1,s7,8
 41c:	4685                	li	a3,1
 41e:	4629                	li	a2,10
 420:	000bb583          	ld	a1,0(s7)
 424:	855a                	mv	a0,s6
 426:	ecfff0ef          	jal	2f4 <printint>
        i += 1;
 42a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 42c:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 42e:	4981                	li	s3,0
 430:	b75d                	j	3d6 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 432:	008b8493          	addi	s1,s7,8
 436:	4685                	li	a3,1
 438:	4629                	li	a2,10
 43a:	000ba583          	lw	a1,0(s7)
 43e:	855a                	mv	a0,s6
 440:	eb5ff0ef          	jal	2f4 <printint>
 444:	8ba6                	mv	s7,s1
      state = 0;
 446:	4981                	li	s3,0
 448:	b779                	j	3d6 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 44a:	9752                	add	a4,a4,s4
 44c:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 450:	f9460713          	addi	a4,a2,-108
 454:	00173713          	seqz	a4,a4
 458:	8f75                	and	a4,a4,a3
 45a:	f9c58513          	addi	a0,a1,-100
 45e:	18051363          	bnez	a0,5e4 <vprintf+0x252>
 462:	18070163          	beqz	a4,5e4 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 466:	008b8493          	addi	s1,s7,8
 46a:	4685                	li	a3,1
 46c:	4629                	li	a2,10
 46e:	000bb583          	ld	a1,0(s7)
 472:	855a                	mv	a0,s6
 474:	e81ff0ef          	jal	2f4 <printint>
        i += 2;
 478:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 47a:	8ba6                	mv	s7,s1
      state = 0;
 47c:	4981                	li	s3,0
        i += 2;
 47e:	bfa1                	j	3d6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 480:	008b8493          	addi	s1,s7,8
 484:	4681                	li	a3,0
 486:	4629                	li	a2,10
 488:	000be583          	lwu	a1,0(s7)
 48c:	855a                	mv	a0,s6
 48e:	e67ff0ef          	jal	2f4 <printint>
 492:	8ba6                	mv	s7,s1
      state = 0;
 494:	4981                	li	s3,0
 496:	b781                	j	3d6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 498:	008b8493          	addi	s1,s7,8
 49c:	4681                	li	a3,0
 49e:	4629                	li	a2,10
 4a0:	000bb583          	ld	a1,0(s7)
 4a4:	855a                	mv	a0,s6
 4a6:	e4fff0ef          	jal	2f4 <printint>
        i += 1;
 4aa:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 4ac:	8ba6                	mv	s7,s1
      state = 0;
 4ae:	4981                	li	s3,0
 4b0:	b71d                	j	3d6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4b2:	008b8493          	addi	s1,s7,8
 4b6:	4681                	li	a3,0
 4b8:	4629                	li	a2,10
 4ba:	000bb583          	ld	a1,0(s7)
 4be:	855a                	mv	a0,s6
 4c0:	e35ff0ef          	jal	2f4 <printint>
        i += 2;
 4c4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 4c6:	8ba6                	mv	s7,s1
      state = 0;
 4c8:	4981                	li	s3,0
        i += 2;
 4ca:	b731                	j	3d6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 4cc:	008b8493          	addi	s1,s7,8
 4d0:	4681                	li	a3,0
 4d2:	4641                	li	a2,16
 4d4:	000be583          	lwu	a1,0(s7)
 4d8:	855a                	mv	a0,s6
 4da:	e1bff0ef          	jal	2f4 <printint>
 4de:	8ba6                	mv	s7,s1
      state = 0;
 4e0:	4981                	li	s3,0
 4e2:	bdd5                	j	3d6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 4e4:	008b8493          	addi	s1,s7,8
 4e8:	4681                	li	a3,0
 4ea:	4641                	li	a2,16
 4ec:	000bb583          	ld	a1,0(s7)
 4f0:	855a                	mv	a0,s6
 4f2:	e03ff0ef          	jal	2f4 <printint>
        i += 1;
 4f6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 4f8:	8ba6                	mv	s7,s1
      state = 0;
 4fa:	4981                	li	s3,0
 4fc:	bde9                	j	3d6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 4fe:	008b8493          	addi	s1,s7,8
 502:	4681                	li	a3,0
 504:	4641                	li	a2,16
 506:	000bb583          	ld	a1,0(s7)
 50a:	855a                	mv	a0,s6
 50c:	de9ff0ef          	jal	2f4 <printint>
        i += 2;
 510:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 512:	8ba6                	mv	s7,s1
      state = 0;
 514:	4981                	li	s3,0
        i += 2;
 516:	b5c1                	j	3d6 <vprintf+0x44>
 518:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 51a:	008b8793          	addi	a5,s7,8
 51e:	8cbe                	mv	s9,a5
 520:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 524:	03000593          	li	a1,48
 528:	855a                	mv	a0,s6
 52a:	dadff0ef          	jal	2d6 <putc>
  putc(fd, 'x');
 52e:	07800593          	li	a1,120
 532:	855a                	mv	a0,s6
 534:	da3ff0ef          	jal	2d6 <putc>
 538:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 53a:	00000b97          	auipc	s7,0x0
 53e:	3b6b8b93          	addi	s7,s7,950 # 8f0 <digits>
 542:	03c9d793          	srli	a5,s3,0x3c
 546:	97de                	add	a5,a5,s7
 548:	0007c583          	lbu	a1,0(a5)
 54c:	855a                	mv	a0,s6
 54e:	d89ff0ef          	jal	2d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 552:	0992                	slli	s3,s3,0x4
 554:	34fd                	addiw	s1,s1,-1
 556:	f4f5                	bnez	s1,542 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 558:	8be6                	mv	s7,s9
      state = 0;
 55a:	4981                	li	s3,0
 55c:	6ca2                	ld	s9,8(sp)
 55e:	bda5                	j	3d6 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 560:	008b8493          	addi	s1,s7,8
 564:	000bc583          	lbu	a1,0(s7)
 568:	855a                	mv	a0,s6
 56a:	d6dff0ef          	jal	2d6 <putc>
 56e:	8ba6                	mv	s7,s1
      state = 0;
 570:	4981                	li	s3,0
 572:	b595                	j	3d6 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 574:	008b8993          	addi	s3,s7,8
 578:	000bb483          	ld	s1,0(s7)
 57c:	cc91                	beqz	s1,598 <vprintf+0x206>
        for(; *s; s++)
 57e:	0004c583          	lbu	a1,0(s1)
 582:	c985                	beqz	a1,5b2 <vprintf+0x220>
          putc(fd, *s);
 584:	855a                	mv	a0,s6
 586:	d51ff0ef          	jal	2d6 <putc>
        for(; *s; s++)
 58a:	0485                	addi	s1,s1,1
 58c:	0004c583          	lbu	a1,0(s1)
 590:	f9f5                	bnez	a1,584 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 592:	8bce                	mv	s7,s3
      state = 0;
 594:	4981                	li	s3,0
 596:	b581                	j	3d6 <vprintf+0x44>
          s = "(null)";
 598:	00000497          	auipc	s1,0x0
 59c:	35048493          	addi	s1,s1,848 # 8e8 <uptime+0x22>
        for(; *s; s++)
 5a0:	02800593          	li	a1,40
 5a4:	b7c5                	j	584 <vprintf+0x1f2>
        putc(fd, '%');
 5a6:	85be                	mv	a1,a5
 5a8:	855a                	mv	a0,s6
 5aa:	d2dff0ef          	jal	2d6 <putc>
      state = 0;
 5ae:	4981                	li	s3,0
 5b0:	b51d                	j	3d6 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 5b2:	8bce                	mv	s7,s3
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	b505                	j	3d6 <vprintf+0x44>
 5b8:	6906                	ld	s2,64(sp)
 5ba:	79e2                	ld	s3,56(sp)
 5bc:	7a42                	ld	s4,48(sp)
 5be:	7aa2                	ld	s5,40(sp)
 5c0:	7b02                	ld	s6,32(sp)
 5c2:	6be2                	ld	s7,24(sp)
 5c4:	6c42                	ld	s8,16(sp)
    }
  }
}
 5c6:	60e6                	ld	ra,88(sp)
 5c8:	6446                	ld	s0,80(sp)
 5ca:	64a6                	ld	s1,72(sp)
 5cc:	6125                	addi	sp,sp,96
 5ce:	8082                	ret
      if(c0 == 'd'){
 5d0:	06400713          	li	a4,100
 5d4:	e4e78fe3          	beq	a5,a4,432 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 5d8:	f9478693          	addi	a3,a5,-108
 5dc:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 5e0:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5e2:	4701                	li	a4,0
      } else if(c0 == 'u'){
 5e4:	07500513          	li	a0,117
 5e8:	e8a78ce3          	beq	a5,a0,480 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 5ec:	f8b60513          	addi	a0,a2,-117
 5f0:	e119                	bnez	a0,5f6 <vprintf+0x264>
 5f2:	ea0693e3          	bnez	a3,498 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5f6:	f8b58513          	addi	a0,a1,-117
 5fa:	e119                	bnez	a0,600 <vprintf+0x26e>
 5fc:	ea071be3          	bnez	a4,4b2 <vprintf+0x120>
      } else if(c0 == 'x'){
 600:	07800513          	li	a0,120
 604:	eca784e3          	beq	a5,a0,4cc <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 608:	f8860613          	addi	a2,a2,-120
 60c:	e219                	bnez	a2,612 <vprintf+0x280>
 60e:	ec069be3          	bnez	a3,4e4 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 612:	f8858593          	addi	a1,a1,-120
 616:	e199                	bnez	a1,61c <vprintf+0x28a>
 618:	ee0713e3          	bnez	a4,4fe <vprintf+0x16c>
      } else if(c0 == 'p'){
 61c:	07000713          	li	a4,112
 620:	eee78ce3          	beq	a5,a4,518 <vprintf+0x186>
      } else if(c0 == 'c'){
 624:	06300713          	li	a4,99
 628:	f2e78ce3          	beq	a5,a4,560 <vprintf+0x1ce>
      } else if(c0 == 's'){
 62c:	07300713          	li	a4,115
 630:	f4e782e3          	beq	a5,a4,574 <vprintf+0x1e2>
      } else if(c0 == '%'){
 634:	02500713          	li	a4,37
 638:	f6e787e3          	beq	a5,a4,5a6 <vprintf+0x214>
        putc(fd, '%');
 63c:	02500593          	li	a1,37
 640:	855a                	mv	a0,s6
 642:	c95ff0ef          	jal	2d6 <putc>
        putc(fd, c0);
 646:	85a6                	mv	a1,s1
 648:	855a                	mv	a0,s6
 64a:	c8dff0ef          	jal	2d6 <putc>
      state = 0;
 64e:	4981                	li	s3,0
 650:	b359                	j	3d6 <vprintf+0x44>

0000000000000652 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 652:	715d                	addi	sp,sp,-80
 654:	ec06                	sd	ra,24(sp)
 656:	e822                	sd	s0,16(sp)
 658:	1000                	addi	s0,sp,32
 65a:	e010                	sd	a2,0(s0)
 65c:	e414                	sd	a3,8(s0)
 65e:	e818                	sd	a4,16(s0)
 660:	ec1c                	sd	a5,24(s0)
 662:	03043023          	sd	a6,32(s0)
 666:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 66a:	8622                	mv	a2,s0
 66c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 670:	d23ff0ef          	jal	392 <vprintf>
}
 674:	60e2                	ld	ra,24(sp)
 676:	6442                	ld	s0,16(sp)
 678:	6161                	addi	sp,sp,80
 67a:	8082                	ret

000000000000067c <printf>:

void
printf(const char *fmt, ...)
{
 67c:	711d                	addi	sp,sp,-96
 67e:	ec06                	sd	ra,24(sp)
 680:	e822                	sd	s0,16(sp)
 682:	1000                	addi	s0,sp,32
 684:	e40c                	sd	a1,8(s0)
 686:	e810                	sd	a2,16(s0)
 688:	ec14                	sd	a3,24(s0)
 68a:	f018                	sd	a4,32(s0)
 68c:	f41c                	sd	a5,40(s0)
 68e:	03043823          	sd	a6,48(s0)
 692:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 696:	00840613          	addi	a2,s0,8
 69a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 69e:	85aa                	mv	a1,a0
 6a0:	4505                	li	a0,1
 6a2:	cf1ff0ef          	jal	392 <vprintf>
 6a6:	60e2                	ld	ra,24(sp)
 6a8:	6442                	ld	s0,16(sp)
 6aa:	6125                	addi	sp,sp,96
 6ac:	8082                	ret

00000000000006ae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ae:	1141                	addi	sp,sp,-16
 6b0:	e406                	sd	ra,8(sp)
 6b2:	e022                	sd	s0,0(sp)
 6b4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ba:	00001797          	auipc	a5,0x1
 6be:	9467b783          	ld	a5,-1722(a5) # 1000 <freep>
 6c2:	a039                	j	6d0 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c4:	6398                	ld	a4,0(a5)
 6c6:	00e7e463          	bltu	a5,a4,6ce <free+0x20>
 6ca:	00e6ea63          	bltu	a3,a4,6de <free+0x30>
{
 6ce:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d0:	fed7fae3          	bgeu	a5,a3,6c4 <free+0x16>
 6d4:	6398                	ld	a4,0(a5)
 6d6:	00e6e463          	bltu	a3,a4,6de <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6da:	fee7eae3          	bltu	a5,a4,6ce <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6de:	ff852583          	lw	a1,-8(a0)
 6e2:	6390                	ld	a2,0(a5)
 6e4:	02059813          	slli	a6,a1,0x20
 6e8:	01c85713          	srli	a4,a6,0x1c
 6ec:	9736                	add	a4,a4,a3
 6ee:	02e60563          	beq	a2,a4,718 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6f2:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6f6:	4790                	lw	a2,8(a5)
 6f8:	02061593          	slli	a1,a2,0x20
 6fc:	01c5d713          	srli	a4,a1,0x1c
 700:	973e                	add	a4,a4,a5
 702:	02e68263          	beq	a3,a4,726 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 706:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 708:	00001717          	auipc	a4,0x1
 70c:	8ef73c23          	sd	a5,-1800(a4) # 1000 <freep>
}
 710:	60a2                	ld	ra,8(sp)
 712:	6402                	ld	s0,0(sp)
 714:	0141                	addi	sp,sp,16
 716:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 718:	4618                	lw	a4,8(a2)
 71a:	9f2d                	addw	a4,a4,a1
 71c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 720:	6398                	ld	a4,0(a5)
 722:	6310                	ld	a2,0(a4)
 724:	b7f9                	j	6f2 <free+0x44>
    p->s.size += bp->s.size;
 726:	ff852703          	lw	a4,-8(a0)
 72a:	9f31                	addw	a4,a4,a2
 72c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 72e:	ff053683          	ld	a3,-16(a0)
 732:	bfd1                	j	706 <free+0x58>

0000000000000734 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 734:	7139                	addi	sp,sp,-64
 736:	fc06                	sd	ra,56(sp)
 738:	f822                	sd	s0,48(sp)
 73a:	f04a                	sd	s2,32(sp)
 73c:	ec4e                	sd	s3,24(sp)
 73e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 740:	02051993          	slli	s3,a0,0x20
 744:	0209d993          	srli	s3,s3,0x20
 748:	09bd                	addi	s3,s3,15
 74a:	0049d993          	srli	s3,s3,0x4
 74e:	2985                	addiw	s3,s3,1
 750:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 752:	00001517          	auipc	a0,0x1
 756:	8ae53503          	ld	a0,-1874(a0) # 1000 <freep>
 75a:	c905                	beqz	a0,78a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 75c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 75e:	4798                	lw	a4,8(a5)
 760:	09377663          	bgeu	a4,s3,7ec <malloc+0xb8>
 764:	f426                	sd	s1,40(sp)
 766:	e852                	sd	s4,16(sp)
 768:	e456                	sd	s5,8(sp)
 76a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 76c:	8a4e                	mv	s4,s3
 76e:	6705                	lui	a4,0x1
 770:	00e9f363          	bgeu	s3,a4,776 <malloc+0x42>
 774:	6a05                	lui	s4,0x1
 776:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 77a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 77e:	00001497          	auipc	s1,0x1
 782:	88248493          	addi	s1,s1,-1918 # 1000 <freep>
  if(p == SBRK_ERROR)
 786:	5afd                	li	s5,-1
 788:	a83d                	j	7c6 <malloc+0x92>
 78a:	f426                	sd	s1,40(sp)
 78c:	e852                	sd	s4,16(sp)
 78e:	e456                	sd	s5,8(sp)
 790:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 792:	00001797          	auipc	a5,0x1
 796:	87e78793          	addi	a5,a5,-1922 # 1010 <base>
 79a:	00001717          	auipc	a4,0x1
 79e:	86f73323          	sd	a5,-1946(a4) # 1000 <freep>
 7a2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7a4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7a8:	b7d1                	j	76c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7aa:	6398                	ld	a4,0(a5)
 7ac:	e118                	sd	a4,0(a0)
 7ae:	a899                	j	804 <malloc+0xd0>
  hp->s.size = nu;
 7b0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7b4:	0541                	addi	a0,a0,16
 7b6:	ef9ff0ef          	jal	6ae <free>
  return freep;
 7ba:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 7bc:	c125                	beqz	a0,81c <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c0:	4798                	lw	a4,8(a5)
 7c2:	03277163          	bgeu	a4,s2,7e4 <malloc+0xb0>
    if(p == freep)
 7c6:	6098                	ld	a4,0(s1)
 7c8:	853e                	mv	a0,a5
 7ca:	fef71ae3          	bne	a4,a5,7be <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 7ce:	8552                	mv	a0,s4
 7d0:	adbff0ef          	jal	2aa <sbrk>
  if(p == SBRK_ERROR)
 7d4:	fd551ee3          	bne	a0,s5,7b0 <malloc+0x7c>
        return 0;
 7d8:	4501                	li	a0,0
 7da:	74a2                	ld	s1,40(sp)
 7dc:	6a42                	ld	s4,16(sp)
 7de:	6aa2                	ld	s5,8(sp)
 7e0:	6b02                	ld	s6,0(sp)
 7e2:	a03d                	j	810 <malloc+0xdc>
 7e4:	74a2                	ld	s1,40(sp)
 7e6:	6a42                	ld	s4,16(sp)
 7e8:	6aa2                	ld	s5,8(sp)
 7ea:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7ec:	fae90fe3          	beq	s2,a4,7aa <malloc+0x76>
        p->s.size -= nunits;
 7f0:	4137073b          	subw	a4,a4,s3
 7f4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7f6:	02071693          	slli	a3,a4,0x20
 7fa:	01c6d713          	srli	a4,a3,0x1c
 7fe:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 800:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 804:	00000717          	auipc	a4,0x0
 808:	7ea73e23          	sd	a0,2044(a4) # 1000 <freep>
      return (void*)(p + 1);
 80c:	01078513          	addi	a0,a5,16
  }
 810:	70e2                	ld	ra,56(sp)
 812:	7442                	ld	s0,48(sp)
 814:	7902                	ld	s2,32(sp)
 816:	69e2                	ld	s3,24(sp)
 818:	6121                	addi	sp,sp,64
 81a:	8082                	ret
 81c:	74a2                	ld	s1,40(sp)
 81e:	6a42                	ld	s4,16(sp)
 820:	6aa2                	ld	s5,8(sp)
 822:	6b02                	ld	s6,0(sp)
 824:	b7f5                	j	810 <malloc+0xdc>

0000000000000826 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 826:	4885                	li	a7,1
 ecall
 828:	00000073          	ecall
 ret
 82c:	8082                	ret

000000000000082e <exit>:
.global exit
exit:
 li a7, SYS_exit
 82e:	4889                	li	a7,2
 ecall
 830:	00000073          	ecall
 ret
 834:	8082                	ret

0000000000000836 <wait>:
.global wait
wait:
 li a7, SYS_wait
 836:	488d                	li	a7,3
 ecall
 838:	00000073          	ecall
 ret
 83c:	8082                	ret

000000000000083e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 83e:	4891                	li	a7,4
 ecall
 840:	00000073          	ecall
 ret
 844:	8082                	ret

0000000000000846 <read>:
.global read
read:
 li a7, SYS_read
 846:	4895                	li	a7,5
 ecall
 848:	00000073          	ecall
 ret
 84c:	8082                	ret

000000000000084e <write>:
.global write
write:
 li a7, SYS_write
 84e:	48c1                	li	a7,16
 ecall
 850:	00000073          	ecall
 ret
 854:	8082                	ret

0000000000000856 <close>:
.global close
close:
 li a7, SYS_close
 856:	48d5                	li	a7,21
 ecall
 858:	00000073          	ecall
 ret
 85c:	8082                	ret

000000000000085e <kill>:
.global kill
kill:
 li a7, SYS_kill
 85e:	4899                	li	a7,6
 ecall
 860:	00000073          	ecall
 ret
 864:	8082                	ret

0000000000000866 <exec>:
.global exec
exec:
 li a7, SYS_exec
 866:	489d                	li	a7,7
 ecall
 868:	00000073          	ecall
 ret
 86c:	8082                	ret

000000000000086e <open>:
.global open
open:
 li a7, SYS_open
 86e:	48bd                	li	a7,15
 ecall
 870:	00000073          	ecall
 ret
 874:	8082                	ret

0000000000000876 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 876:	48c5                	li	a7,17
 ecall
 878:	00000073          	ecall
 ret
 87c:	8082                	ret

000000000000087e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 87e:	48c9                	li	a7,18
 ecall
 880:	00000073          	ecall
 ret
 884:	8082                	ret

0000000000000886 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 886:	48a1                	li	a7,8
 ecall
 888:	00000073          	ecall
 ret
 88c:	8082                	ret

000000000000088e <link>:
.global link
link:
 li a7, SYS_link
 88e:	48cd                	li	a7,19
 ecall
 890:	00000073          	ecall
 ret
 894:	8082                	ret

0000000000000896 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 896:	48d1                	li	a7,20
 ecall
 898:	00000073          	ecall
 ret
 89c:	8082                	ret

000000000000089e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 89e:	48a5                	li	a7,9
 ecall
 8a0:	00000073          	ecall
 ret
 8a4:	8082                	ret

00000000000008a6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 8a6:	48a9                	li	a7,10
 ecall
 8a8:	00000073          	ecall
 ret
 8ac:	8082                	ret

00000000000008ae <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 8ae:	48ad                	li	a7,11
 ecall
 8b0:	00000073          	ecall
 ret
 8b4:	8082                	ret

00000000000008b6 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 8b6:	48b1                	li	a7,12
 ecall
 8b8:	00000073          	ecall
 ret
 8bc:	8082                	ret

00000000000008be <pause>:
.global pause
pause:
 li a7, SYS_pause
 8be:	48d9                	li	a7,22
 ecall
 8c0:	00000073          	ecall
 ret
 8c4:	8082                	ret

00000000000008c6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 8c6:	48b9                	li	a7,14
 ecall
 8c8:	00000073          	ecall
 ret
 8cc:	8082                	ret
