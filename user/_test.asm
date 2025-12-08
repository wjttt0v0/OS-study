
user/_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user.h"

int main() {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    printf("hello test program!\n");
   8:	00001517          	auipc	a0,0x1
   c:	8b850513          	addi	a0,a0,-1864 # 8c0 <uptime+0x8>
  10:	65e000ef          	jal	66e <printf>
    exit(0);
  14:	4501                	li	a0,0
  16:	00b000ef          	jal	820 <exit>

000000000000001a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  1a:	1141                	addi	sp,sp,-16
  1c:	e406                	sd	ra,8(sp)
  1e:	e022                	sd	s0,0(sp)
  20:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  22:	fdfff0ef          	jal	0 <main>
  exit(r);
  26:	7fa000ef          	jal	820 <exit>

000000000000002a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e406                	sd	ra,8(sp)
  2e:	e022                	sd	s0,0(sp)
  30:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  32:	87aa                	mv	a5,a0
  34:	0585                	addi	a1,a1,1
  36:	0785                	addi	a5,a5,1
  38:	fff5c703          	lbu	a4,-1(a1)
  3c:	fee78fa3          	sb	a4,-1(a5)
  40:	fb75                	bnez	a4,34 <strcpy+0xa>
    ;
  return os;
}
  42:	60a2                	ld	ra,8(sp)
  44:	6402                	ld	s0,0(sp)
  46:	0141                	addi	sp,sp,16
  48:	8082                	ret

000000000000004a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4a:	1141                	addi	sp,sp,-16
  4c:	e406                	sd	ra,8(sp)
  4e:	e022                	sd	s0,0(sp)
  50:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  52:	00054783          	lbu	a5,0(a0)
  56:	cb91                	beqz	a5,6a <strcmp+0x20>
  58:	0005c703          	lbu	a4,0(a1)
  5c:	00f71763          	bne	a4,a5,6a <strcmp+0x20>
    p++, q++;
  60:	0505                	addi	a0,a0,1
  62:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  64:	00054783          	lbu	a5,0(a0)
  68:	fbe5                	bnez	a5,58 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  6a:	0005c503          	lbu	a0,0(a1)
}
  6e:	40a7853b          	subw	a0,a5,a0
  72:	60a2                	ld	ra,8(sp)
  74:	6402                	ld	s0,0(sp)
  76:	0141                	addi	sp,sp,16
  78:	8082                	ret

000000000000007a <strlen>:

uint
strlen(const char *s)
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e406                	sd	ra,8(sp)
  7e:	e022                	sd	s0,0(sp)
  80:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  82:	00054783          	lbu	a5,0(a0)
  86:	cf91                	beqz	a5,a2 <strlen+0x28>
  88:	00150793          	addi	a5,a0,1
  8c:	86be                	mv	a3,a5
  8e:	0785                	addi	a5,a5,1
  90:	fff7c703          	lbu	a4,-1(a5)
  94:	ff65                	bnez	a4,8c <strlen+0x12>
  96:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  9a:	60a2                	ld	ra,8(sp)
  9c:	6402                	ld	s0,0(sp)
  9e:	0141                	addi	sp,sp,16
  a0:	8082                	ret
  for(n = 0; s[n]; n++)
  a2:	4501                	li	a0,0
  a4:	bfdd                	j	9a <strlen+0x20>

00000000000000a6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a6:	1141                	addi	sp,sp,-16
  a8:	e406                	sd	ra,8(sp)
  aa:	e022                	sd	s0,0(sp)
  ac:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ae:	ca19                	beqz	a2,c4 <memset+0x1e>
  b0:	87aa                	mv	a5,a0
  b2:	1602                	slli	a2,a2,0x20
  b4:	9201                	srli	a2,a2,0x20
  b6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ba:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  be:	0785                	addi	a5,a5,1
  c0:	fee79de3          	bne	a5,a4,ba <memset+0x14>
  }
  return dst;
}
  c4:	60a2                	ld	ra,8(sp)
  c6:	6402                	ld	s0,0(sp)
  c8:	0141                	addi	sp,sp,16
  ca:	8082                	ret

00000000000000cc <strchr>:

char*
strchr(const char *s, char c)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e406                	sd	ra,8(sp)
  d0:	e022                	sd	s0,0(sp)
  d2:	0800                	addi	s0,sp,16
  for(; *s; s++)
  d4:	00054783          	lbu	a5,0(a0)
  d8:	cf81                	beqz	a5,f0 <strchr+0x24>
    if(*s == c)
  da:	00f58763          	beq	a1,a5,e8 <strchr+0x1c>
  for(; *s; s++)
  de:	0505                	addi	a0,a0,1
  e0:	00054783          	lbu	a5,0(a0)
  e4:	fbfd                	bnez	a5,da <strchr+0xe>
      return (char*)s;
  return 0;
  e6:	4501                	li	a0,0
}
  e8:	60a2                	ld	ra,8(sp)
  ea:	6402                	ld	s0,0(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret
  return 0;
  f0:	4501                	li	a0,0
  f2:	bfdd                	j	e8 <strchr+0x1c>

00000000000000f4 <gets>:

char*
gets(char *buf, int max)
{
  f4:	711d                	addi	sp,sp,-96
  f6:	ec86                	sd	ra,88(sp)
  f8:	e8a2                	sd	s0,80(sp)
  fa:	e4a6                	sd	s1,72(sp)
  fc:	e0ca                	sd	s2,64(sp)
  fe:	fc4e                	sd	s3,56(sp)
 100:	f852                	sd	s4,48(sp)
 102:	f456                	sd	s5,40(sp)
 104:	f05a                	sd	s6,32(sp)
 106:	ec5e                	sd	s7,24(sp)
 108:	e862                	sd	s8,16(sp)
 10a:	1080                	addi	s0,sp,96
 10c:	8baa                	mv	s7,a0
 10e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 110:	892a                	mv	s2,a0
 112:	4481                	li	s1,0
    cc = read(0, &c, 1);
 114:	faf40b13          	addi	s6,s0,-81
 118:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 11a:	8c26                	mv	s8,s1
 11c:	0014899b          	addiw	s3,s1,1
 120:	84ce                	mv	s1,s3
 122:	0349d463          	bge	s3,s4,14a <gets+0x56>
    cc = read(0, &c, 1);
 126:	8656                	mv	a2,s5
 128:	85da                	mv	a1,s6
 12a:	4501                	li	a0,0
 12c:	70c000ef          	jal	838 <read>
    if(cc < 1)
 130:	00a05d63          	blez	a0,14a <gets+0x56>
      break;
    buf[i++] = c;
 134:	faf44783          	lbu	a5,-81(s0)
 138:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 13c:	0905                	addi	s2,s2,1
 13e:	ff678713          	addi	a4,a5,-10
 142:	c319                	beqz	a4,148 <gets+0x54>
 144:	17cd                	addi	a5,a5,-13
 146:	fbf1                	bnez	a5,11a <gets+0x26>
    buf[i++] = c;
 148:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 14a:	9c5e                	add	s8,s8,s7
 14c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 150:	855e                	mv	a0,s7
 152:	60e6                	ld	ra,88(sp)
 154:	6446                	ld	s0,80(sp)
 156:	64a6                	ld	s1,72(sp)
 158:	6906                	ld	s2,64(sp)
 15a:	79e2                	ld	s3,56(sp)
 15c:	7a42                	ld	s4,48(sp)
 15e:	7aa2                	ld	s5,40(sp)
 160:	7b02                	ld	s6,32(sp)
 162:	6be2                	ld	s7,24(sp)
 164:	6c42                	ld	s8,16(sp)
 166:	6125                	addi	sp,sp,96
 168:	8082                	ret

000000000000016a <stat>:

int
stat(const char *n, struct stat *st)
{
 16a:	1101                	addi	sp,sp,-32
 16c:	ec06                	sd	ra,24(sp)
 16e:	e822                	sd	s0,16(sp)
 170:	e04a                	sd	s2,0(sp)
 172:	1000                	addi	s0,sp,32
 174:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 176:	4581                	li	a1,0
 178:	6e8000ef          	jal	860 <open>
  if(fd < 0)
 17c:	02054263          	bltz	a0,1a0 <stat+0x36>
 180:	e426                	sd	s1,8(sp)
 182:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 184:	85ca                	mv	a1,s2
 186:	6f2000ef          	jal	878 <fstat>
 18a:	892a                	mv	s2,a0
  close(fd);
 18c:	8526                	mv	a0,s1
 18e:	6ba000ef          	jal	848 <close>
  return r;
 192:	64a2                	ld	s1,8(sp)
}
 194:	854a                	mv	a0,s2
 196:	60e2                	ld	ra,24(sp)
 198:	6442                	ld	s0,16(sp)
 19a:	6902                	ld	s2,0(sp)
 19c:	6105                	addi	sp,sp,32
 19e:	8082                	ret
    return -1;
 1a0:	57fd                	li	a5,-1
 1a2:	893e                	mv	s2,a5
 1a4:	bfc5                	j	194 <stat+0x2a>

00000000000001a6 <atoi>:

int
atoi(const char *s)
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e406                	sd	ra,8(sp)
 1aa:	e022                	sd	s0,0(sp)
 1ac:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ae:	00054683          	lbu	a3,0(a0)
 1b2:	fd06879b          	addiw	a5,a3,-48
 1b6:	0ff7f793          	zext.b	a5,a5
 1ba:	4625                	li	a2,9
 1bc:	02f66963          	bltu	a2,a5,1ee <atoi+0x48>
 1c0:	872a                	mv	a4,a0
  n = 0;
 1c2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1c4:	0705                	addi	a4,a4,1
 1c6:	0025179b          	slliw	a5,a0,0x2
 1ca:	9fa9                	addw	a5,a5,a0
 1cc:	0017979b          	slliw	a5,a5,0x1
 1d0:	9fb5                	addw	a5,a5,a3
 1d2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1d6:	00074683          	lbu	a3,0(a4)
 1da:	fd06879b          	addiw	a5,a3,-48
 1de:	0ff7f793          	zext.b	a5,a5
 1e2:	fef671e3          	bgeu	a2,a5,1c4 <atoi+0x1e>
  return n;
}
 1e6:	60a2                	ld	ra,8(sp)
 1e8:	6402                	ld	s0,0(sp)
 1ea:	0141                	addi	sp,sp,16
 1ec:	8082                	ret
  n = 0;
 1ee:	4501                	li	a0,0
 1f0:	bfdd                	j	1e6 <atoi+0x40>

00000000000001f2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f2:	1141                	addi	sp,sp,-16
 1f4:	e406                	sd	ra,8(sp)
 1f6:	e022                	sd	s0,0(sp)
 1f8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1fa:	02b57563          	bgeu	a0,a1,224 <memmove+0x32>
    while(n-- > 0)
 1fe:	00c05f63          	blez	a2,21c <memmove+0x2a>
 202:	1602                	slli	a2,a2,0x20
 204:	9201                	srli	a2,a2,0x20
 206:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 20a:	872a                	mv	a4,a0
      *dst++ = *src++;
 20c:	0585                	addi	a1,a1,1
 20e:	0705                	addi	a4,a4,1
 210:	fff5c683          	lbu	a3,-1(a1)
 214:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 218:	fee79ae3          	bne	a5,a4,20c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 21c:	60a2                	ld	ra,8(sp)
 21e:	6402                	ld	s0,0(sp)
 220:	0141                	addi	sp,sp,16
 222:	8082                	ret
    while(n-- > 0)
 224:	fec05ce3          	blez	a2,21c <memmove+0x2a>
    dst += n;
 228:	00c50733          	add	a4,a0,a2
    src += n;
 22c:	95b2                	add	a1,a1,a2
 22e:	fff6079b          	addiw	a5,a2,-1
 232:	1782                	slli	a5,a5,0x20
 234:	9381                	srli	a5,a5,0x20
 236:	fff7c793          	not	a5,a5
 23a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 23c:	15fd                	addi	a1,a1,-1
 23e:	177d                	addi	a4,a4,-1
 240:	0005c683          	lbu	a3,0(a1)
 244:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 248:	fef71ae3          	bne	a4,a5,23c <memmove+0x4a>
 24c:	bfc1                	j	21c <memmove+0x2a>

000000000000024e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 24e:	1141                	addi	sp,sp,-16
 250:	e406                	sd	ra,8(sp)
 252:	e022                	sd	s0,0(sp)
 254:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 256:	c61d                	beqz	a2,284 <memcmp+0x36>
 258:	1602                	slli	a2,a2,0x20
 25a:	9201                	srli	a2,a2,0x20
 25c:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 260:	00054783          	lbu	a5,0(a0)
 264:	0005c703          	lbu	a4,0(a1)
 268:	00e79863          	bne	a5,a4,278 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 26c:	0505                	addi	a0,a0,1
    p2++;
 26e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 270:	fed518e3          	bne	a0,a3,260 <memcmp+0x12>
  }
  return 0;
 274:	4501                	li	a0,0
 276:	a019                	j	27c <memcmp+0x2e>
      return *p1 - *p2;
 278:	40e7853b          	subw	a0,a5,a4
}
 27c:	60a2                	ld	ra,8(sp)
 27e:	6402                	ld	s0,0(sp)
 280:	0141                	addi	sp,sp,16
 282:	8082                	ret
  return 0;
 284:	4501                	li	a0,0
 286:	bfdd                	j	27c <memcmp+0x2e>

0000000000000288 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e406                	sd	ra,8(sp)
 28c:	e022                	sd	s0,0(sp)
 28e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 290:	f63ff0ef          	jal	1f2 <memmove>
}
 294:	60a2                	ld	ra,8(sp)
 296:	6402                	ld	s0,0(sp)
 298:	0141                	addi	sp,sp,16
 29a:	8082                	ret

000000000000029c <sbrk>:

char *
sbrk(int n) {
 29c:	1141                	addi	sp,sp,-16
 29e:	e406                	sd	ra,8(sp)
 2a0:	e022                	sd	s0,0(sp)
 2a2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2a4:	4585                	li	a1,1
 2a6:	602000ef          	jal	8a8 <sys_sbrk>
}
 2aa:	60a2                	ld	ra,8(sp)
 2ac:	6402                	ld	s0,0(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret

00000000000002b2 <sbrklazy>:

char *
sbrklazy(int n) {
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e406                	sd	ra,8(sp)
 2b6:	e022                	sd	s0,0(sp)
 2b8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2ba:	4589                	li	a1,2
 2bc:	5ec000ef          	jal	8a8 <sys_sbrk>
}
 2c0:	60a2                	ld	ra,8(sp)
 2c2:	6402                	ld	s0,0(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret

00000000000002c8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 2c8:	1101                	addi	sp,sp,-32
 2ca:	ec06                	sd	ra,24(sp)
 2cc:	e822                	sd	s0,16(sp)
 2ce:	1000                	addi	s0,sp,32
 2d0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 2d4:	4605                	li	a2,1
 2d6:	fef40593          	addi	a1,s0,-17
 2da:	566000ef          	jal	840 <write>
}
 2de:	60e2                	ld	ra,24(sp)
 2e0:	6442                	ld	s0,16(sp)
 2e2:	6105                	addi	sp,sp,32
 2e4:	8082                	ret

00000000000002e6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 2e6:	715d                	addi	sp,sp,-80
 2e8:	e486                	sd	ra,72(sp)
 2ea:	e0a2                	sd	s0,64(sp)
 2ec:	f84a                	sd	s2,48(sp)
 2ee:	f44e                	sd	s3,40(sp)
 2f0:	0880                	addi	s0,sp,80
 2f2:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 2f4:	c6d1                	beqz	a3,380 <printint+0x9a>
 2f6:	0805d563          	bgez	a1,380 <printint+0x9a>
    neg = 1;
    x = -xx;
 2fa:	40b005b3          	neg	a1,a1
    neg = 1;
 2fe:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 300:	fb840993          	addi	s3,s0,-72
  neg = 0;
 304:	86ce                	mv	a3,s3
  i = 0;
 306:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 308:	00000817          	auipc	a6,0x0
 30c:	5d880813          	addi	a6,a6,1496 # 8e0 <digits>
 310:	88ba                	mv	a7,a4
 312:	0017051b          	addiw	a0,a4,1
 316:	872a                	mv	a4,a0
 318:	02c5f7b3          	remu	a5,a1,a2
 31c:	97c2                	add	a5,a5,a6
 31e:	0007c783          	lbu	a5,0(a5)
 322:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 326:	87ae                	mv	a5,a1
 328:	02c5d5b3          	divu	a1,a1,a2
 32c:	0685                	addi	a3,a3,1
 32e:	fec7f1e3          	bgeu	a5,a2,310 <printint+0x2a>
  if(neg)
 332:	00030c63          	beqz	t1,34a <printint+0x64>
    buf[i++] = '-';
 336:	fd050793          	addi	a5,a0,-48
 33a:	00878533          	add	a0,a5,s0
 33e:	02d00793          	li	a5,45
 342:	fef50423          	sb	a5,-24(a0)
 346:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 34a:	02e05563          	blez	a4,374 <printint+0x8e>
 34e:	fc26                	sd	s1,56(sp)
 350:	377d                	addiw	a4,a4,-1
 352:	00e984b3          	add	s1,s3,a4
 356:	19fd                	addi	s3,s3,-1
 358:	99ba                	add	s3,s3,a4
 35a:	1702                	slli	a4,a4,0x20
 35c:	9301                	srli	a4,a4,0x20
 35e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 362:	0004c583          	lbu	a1,0(s1)
 366:	854a                	mv	a0,s2
 368:	f61ff0ef          	jal	2c8 <putc>
  while(--i >= 0)
 36c:	14fd                	addi	s1,s1,-1
 36e:	ff349ae3          	bne	s1,s3,362 <printint+0x7c>
 372:	74e2                	ld	s1,56(sp)
}
 374:	60a6                	ld	ra,72(sp)
 376:	6406                	ld	s0,64(sp)
 378:	7942                	ld	s2,48(sp)
 37a:	79a2                	ld	s3,40(sp)
 37c:	6161                	addi	sp,sp,80
 37e:	8082                	ret
  neg = 0;
 380:	4301                	li	t1,0
 382:	bfbd                	j	300 <printint+0x1a>

0000000000000384 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 384:	711d                	addi	sp,sp,-96
 386:	ec86                	sd	ra,88(sp)
 388:	e8a2                	sd	s0,80(sp)
 38a:	e4a6                	sd	s1,72(sp)
 38c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 38e:	0005c483          	lbu	s1,0(a1)
 392:	22048363          	beqz	s1,5b8 <vprintf+0x234>
 396:	e0ca                	sd	s2,64(sp)
 398:	fc4e                	sd	s3,56(sp)
 39a:	f852                	sd	s4,48(sp)
 39c:	f456                	sd	s5,40(sp)
 39e:	f05a                	sd	s6,32(sp)
 3a0:	ec5e                	sd	s7,24(sp)
 3a2:	e862                	sd	s8,16(sp)
 3a4:	8b2a                	mv	s6,a0
 3a6:	8a2e                	mv	s4,a1
 3a8:	8bb2                	mv	s7,a2
  state = 0;
 3aa:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 3ac:	4901                	li	s2,0
 3ae:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 3b0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 3b4:	06400c13          	li	s8,100
 3b8:	a00d                	j	3da <vprintf+0x56>
        putc(fd, c0);
 3ba:	85a6                	mv	a1,s1
 3bc:	855a                	mv	a0,s6
 3be:	f0bff0ef          	jal	2c8 <putc>
 3c2:	a019                	j	3c8 <vprintf+0x44>
    } else if(state == '%'){
 3c4:	03598363          	beq	s3,s5,3ea <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 3c8:	0019079b          	addiw	a5,s2,1
 3cc:	893e                	mv	s2,a5
 3ce:	873e                	mv	a4,a5
 3d0:	97d2                	add	a5,a5,s4
 3d2:	0007c483          	lbu	s1,0(a5)
 3d6:	1c048a63          	beqz	s1,5aa <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 3da:	0004879b          	sext.w	a5,s1
    if(state == 0){
 3de:	fe0993e3          	bnez	s3,3c4 <vprintf+0x40>
      if(c0 == '%'){
 3e2:	fd579ce3          	bne	a5,s5,3ba <vprintf+0x36>
        state = '%';
 3e6:	89be                	mv	s3,a5
 3e8:	b7c5                	j	3c8 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 3ea:	00ea06b3          	add	a3,s4,a4
 3ee:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 3f2:	1c060863          	beqz	a2,5c2 <vprintf+0x23e>
      if(c0 == 'd'){
 3f6:	03878763          	beq	a5,s8,424 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 3fa:	f9478693          	addi	a3,a5,-108
 3fe:	0016b693          	seqz	a3,a3
 402:	f9c60593          	addi	a1,a2,-100
 406:	e99d                	bnez	a1,43c <vprintf+0xb8>
 408:	ca95                	beqz	a3,43c <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 40a:	008b8493          	addi	s1,s7,8
 40e:	4685                	li	a3,1
 410:	4629                	li	a2,10
 412:	000bb583          	ld	a1,0(s7)
 416:	855a                	mv	a0,s6
 418:	ecfff0ef          	jal	2e6 <printint>
        i += 1;
 41c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 41e:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 420:	4981                	li	s3,0
 422:	b75d                	j	3c8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 424:	008b8493          	addi	s1,s7,8
 428:	4685                	li	a3,1
 42a:	4629                	li	a2,10
 42c:	000ba583          	lw	a1,0(s7)
 430:	855a                	mv	a0,s6
 432:	eb5ff0ef          	jal	2e6 <printint>
 436:	8ba6                	mv	s7,s1
      state = 0;
 438:	4981                	li	s3,0
 43a:	b779                	j	3c8 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 43c:	9752                	add	a4,a4,s4
 43e:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 442:	f9460713          	addi	a4,a2,-108
 446:	00173713          	seqz	a4,a4
 44a:	8f75                	and	a4,a4,a3
 44c:	f9c58513          	addi	a0,a1,-100
 450:	18051363          	bnez	a0,5d6 <vprintf+0x252>
 454:	18070163          	beqz	a4,5d6 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 458:	008b8493          	addi	s1,s7,8
 45c:	4685                	li	a3,1
 45e:	4629                	li	a2,10
 460:	000bb583          	ld	a1,0(s7)
 464:	855a                	mv	a0,s6
 466:	e81ff0ef          	jal	2e6 <printint>
        i += 2;
 46a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 46c:	8ba6                	mv	s7,s1
      state = 0;
 46e:	4981                	li	s3,0
        i += 2;
 470:	bfa1                	j	3c8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 472:	008b8493          	addi	s1,s7,8
 476:	4681                	li	a3,0
 478:	4629                	li	a2,10
 47a:	000be583          	lwu	a1,0(s7)
 47e:	855a                	mv	a0,s6
 480:	e67ff0ef          	jal	2e6 <printint>
 484:	8ba6                	mv	s7,s1
      state = 0;
 486:	4981                	li	s3,0
 488:	b781                	j	3c8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 48a:	008b8493          	addi	s1,s7,8
 48e:	4681                	li	a3,0
 490:	4629                	li	a2,10
 492:	000bb583          	ld	a1,0(s7)
 496:	855a                	mv	a0,s6
 498:	e4fff0ef          	jal	2e6 <printint>
        i += 1;
 49c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 49e:	8ba6                	mv	s7,s1
      state = 0;
 4a0:	4981                	li	s3,0
 4a2:	b71d                	j	3c8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4a4:	008b8493          	addi	s1,s7,8
 4a8:	4681                	li	a3,0
 4aa:	4629                	li	a2,10
 4ac:	000bb583          	ld	a1,0(s7)
 4b0:	855a                	mv	a0,s6
 4b2:	e35ff0ef          	jal	2e6 <printint>
        i += 2;
 4b6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 4b8:	8ba6                	mv	s7,s1
      state = 0;
 4ba:	4981                	li	s3,0
        i += 2;
 4bc:	b731                	j	3c8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 4be:	008b8493          	addi	s1,s7,8
 4c2:	4681                	li	a3,0
 4c4:	4641                	li	a2,16
 4c6:	000be583          	lwu	a1,0(s7)
 4ca:	855a                	mv	a0,s6
 4cc:	e1bff0ef          	jal	2e6 <printint>
 4d0:	8ba6                	mv	s7,s1
      state = 0;
 4d2:	4981                	li	s3,0
 4d4:	bdd5                	j	3c8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 4d6:	008b8493          	addi	s1,s7,8
 4da:	4681                	li	a3,0
 4dc:	4641                	li	a2,16
 4de:	000bb583          	ld	a1,0(s7)
 4e2:	855a                	mv	a0,s6
 4e4:	e03ff0ef          	jal	2e6 <printint>
        i += 1;
 4e8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 4ea:	8ba6                	mv	s7,s1
      state = 0;
 4ec:	4981                	li	s3,0
 4ee:	bde9                	j	3c8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 4f0:	008b8493          	addi	s1,s7,8
 4f4:	4681                	li	a3,0
 4f6:	4641                	li	a2,16
 4f8:	000bb583          	ld	a1,0(s7)
 4fc:	855a                	mv	a0,s6
 4fe:	de9ff0ef          	jal	2e6 <printint>
        i += 2;
 502:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 504:	8ba6                	mv	s7,s1
      state = 0;
 506:	4981                	li	s3,0
        i += 2;
 508:	b5c1                	j	3c8 <vprintf+0x44>
 50a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 50c:	008b8793          	addi	a5,s7,8
 510:	8cbe                	mv	s9,a5
 512:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 516:	03000593          	li	a1,48
 51a:	855a                	mv	a0,s6
 51c:	dadff0ef          	jal	2c8 <putc>
  putc(fd, 'x');
 520:	07800593          	li	a1,120
 524:	855a                	mv	a0,s6
 526:	da3ff0ef          	jal	2c8 <putc>
 52a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 52c:	00000b97          	auipc	s7,0x0
 530:	3b4b8b93          	addi	s7,s7,948 # 8e0 <digits>
 534:	03c9d793          	srli	a5,s3,0x3c
 538:	97de                	add	a5,a5,s7
 53a:	0007c583          	lbu	a1,0(a5)
 53e:	855a                	mv	a0,s6
 540:	d89ff0ef          	jal	2c8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 544:	0992                	slli	s3,s3,0x4
 546:	34fd                	addiw	s1,s1,-1
 548:	f4f5                	bnez	s1,534 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 54a:	8be6                	mv	s7,s9
      state = 0;
 54c:	4981                	li	s3,0
 54e:	6ca2                	ld	s9,8(sp)
 550:	bda5                	j	3c8 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 552:	008b8493          	addi	s1,s7,8
 556:	000bc583          	lbu	a1,0(s7)
 55a:	855a                	mv	a0,s6
 55c:	d6dff0ef          	jal	2c8 <putc>
 560:	8ba6                	mv	s7,s1
      state = 0;
 562:	4981                	li	s3,0
 564:	b595                	j	3c8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 566:	008b8993          	addi	s3,s7,8
 56a:	000bb483          	ld	s1,0(s7)
 56e:	cc91                	beqz	s1,58a <vprintf+0x206>
        for(; *s; s++)
 570:	0004c583          	lbu	a1,0(s1)
 574:	c985                	beqz	a1,5a4 <vprintf+0x220>
          putc(fd, *s);
 576:	855a                	mv	a0,s6
 578:	d51ff0ef          	jal	2c8 <putc>
        for(; *s; s++)
 57c:	0485                	addi	s1,s1,1
 57e:	0004c583          	lbu	a1,0(s1)
 582:	f9f5                	bnez	a1,576 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 584:	8bce                	mv	s7,s3
      state = 0;
 586:	4981                	li	s3,0
 588:	b581                	j	3c8 <vprintf+0x44>
          s = "(null)";
 58a:	00000497          	auipc	s1,0x0
 58e:	34e48493          	addi	s1,s1,846 # 8d8 <uptime+0x20>
        for(; *s; s++)
 592:	02800593          	li	a1,40
 596:	b7c5                	j	576 <vprintf+0x1f2>
        putc(fd, '%');
 598:	85be                	mv	a1,a5
 59a:	855a                	mv	a0,s6
 59c:	d2dff0ef          	jal	2c8 <putc>
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	b51d                	j	3c8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 5a4:	8bce                	mv	s7,s3
      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	b505                	j	3c8 <vprintf+0x44>
 5aa:	6906                	ld	s2,64(sp)
 5ac:	79e2                	ld	s3,56(sp)
 5ae:	7a42                	ld	s4,48(sp)
 5b0:	7aa2                	ld	s5,40(sp)
 5b2:	7b02                	ld	s6,32(sp)
 5b4:	6be2                	ld	s7,24(sp)
 5b6:	6c42                	ld	s8,16(sp)
    }
  }
}
 5b8:	60e6                	ld	ra,88(sp)
 5ba:	6446                	ld	s0,80(sp)
 5bc:	64a6                	ld	s1,72(sp)
 5be:	6125                	addi	sp,sp,96
 5c0:	8082                	ret
      if(c0 == 'd'){
 5c2:	06400713          	li	a4,100
 5c6:	e4e78fe3          	beq	a5,a4,424 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 5ca:	f9478693          	addi	a3,a5,-108
 5ce:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 5d2:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d4:	4701                	li	a4,0
      } else if(c0 == 'u'){
 5d6:	07500513          	li	a0,117
 5da:	e8a78ce3          	beq	a5,a0,472 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 5de:	f8b60513          	addi	a0,a2,-117
 5e2:	e119                	bnez	a0,5e8 <vprintf+0x264>
 5e4:	ea0693e3          	bnez	a3,48a <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5e8:	f8b58513          	addi	a0,a1,-117
 5ec:	e119                	bnez	a0,5f2 <vprintf+0x26e>
 5ee:	ea071be3          	bnez	a4,4a4 <vprintf+0x120>
      } else if(c0 == 'x'){
 5f2:	07800513          	li	a0,120
 5f6:	eca784e3          	beq	a5,a0,4be <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 5fa:	f8860613          	addi	a2,a2,-120
 5fe:	e219                	bnez	a2,604 <vprintf+0x280>
 600:	ec069be3          	bnez	a3,4d6 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 604:	f8858593          	addi	a1,a1,-120
 608:	e199                	bnez	a1,60e <vprintf+0x28a>
 60a:	ee0713e3          	bnez	a4,4f0 <vprintf+0x16c>
      } else if(c0 == 'p'){
 60e:	07000713          	li	a4,112
 612:	eee78ce3          	beq	a5,a4,50a <vprintf+0x186>
      } else if(c0 == 'c'){
 616:	06300713          	li	a4,99
 61a:	f2e78ce3          	beq	a5,a4,552 <vprintf+0x1ce>
      } else if(c0 == 's'){
 61e:	07300713          	li	a4,115
 622:	f4e782e3          	beq	a5,a4,566 <vprintf+0x1e2>
      } else if(c0 == '%'){
 626:	02500713          	li	a4,37
 62a:	f6e787e3          	beq	a5,a4,598 <vprintf+0x214>
        putc(fd, '%');
 62e:	02500593          	li	a1,37
 632:	855a                	mv	a0,s6
 634:	c95ff0ef          	jal	2c8 <putc>
        putc(fd, c0);
 638:	85a6                	mv	a1,s1
 63a:	855a                	mv	a0,s6
 63c:	c8dff0ef          	jal	2c8 <putc>
      state = 0;
 640:	4981                	li	s3,0
 642:	b359                	j	3c8 <vprintf+0x44>

0000000000000644 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 644:	715d                	addi	sp,sp,-80
 646:	ec06                	sd	ra,24(sp)
 648:	e822                	sd	s0,16(sp)
 64a:	1000                	addi	s0,sp,32
 64c:	e010                	sd	a2,0(s0)
 64e:	e414                	sd	a3,8(s0)
 650:	e818                	sd	a4,16(s0)
 652:	ec1c                	sd	a5,24(s0)
 654:	03043023          	sd	a6,32(s0)
 658:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 65c:	8622                	mv	a2,s0
 65e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 662:	d23ff0ef          	jal	384 <vprintf>
}
 666:	60e2                	ld	ra,24(sp)
 668:	6442                	ld	s0,16(sp)
 66a:	6161                	addi	sp,sp,80
 66c:	8082                	ret

000000000000066e <printf>:

void
printf(const char *fmt, ...)
{
 66e:	711d                	addi	sp,sp,-96
 670:	ec06                	sd	ra,24(sp)
 672:	e822                	sd	s0,16(sp)
 674:	1000                	addi	s0,sp,32
 676:	e40c                	sd	a1,8(s0)
 678:	e810                	sd	a2,16(s0)
 67a:	ec14                	sd	a3,24(s0)
 67c:	f018                	sd	a4,32(s0)
 67e:	f41c                	sd	a5,40(s0)
 680:	03043823          	sd	a6,48(s0)
 684:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 688:	00840613          	addi	a2,s0,8
 68c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 690:	85aa                	mv	a1,a0
 692:	4505                	li	a0,1
 694:	cf1ff0ef          	jal	384 <vprintf>
 698:	60e2                	ld	ra,24(sp)
 69a:	6442                	ld	s0,16(sp)
 69c:	6125                	addi	sp,sp,96
 69e:	8082                	ret

00000000000006a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a0:	1141                	addi	sp,sp,-16
 6a2:	e406                	sd	ra,8(sp)
 6a4:	e022                	sd	s0,0(sp)
 6a6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ac:	00001797          	auipc	a5,0x1
 6b0:	9547b783          	ld	a5,-1708(a5) # 1000 <freep>
 6b4:	a039                	j	6c2 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b6:	6398                	ld	a4,0(a5)
 6b8:	00e7e463          	bltu	a5,a4,6c0 <free+0x20>
 6bc:	00e6ea63          	bltu	a3,a4,6d0 <free+0x30>
{
 6c0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c2:	fed7fae3          	bgeu	a5,a3,6b6 <free+0x16>
 6c6:	6398                	ld	a4,0(a5)
 6c8:	00e6e463          	bltu	a3,a4,6d0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6cc:	fee7eae3          	bltu	a5,a4,6c0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6d0:	ff852583          	lw	a1,-8(a0)
 6d4:	6390                	ld	a2,0(a5)
 6d6:	02059813          	slli	a6,a1,0x20
 6da:	01c85713          	srli	a4,a6,0x1c
 6de:	9736                	add	a4,a4,a3
 6e0:	02e60563          	beq	a2,a4,70a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6e4:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6e8:	4790                	lw	a2,8(a5)
 6ea:	02061593          	slli	a1,a2,0x20
 6ee:	01c5d713          	srli	a4,a1,0x1c
 6f2:	973e                	add	a4,a4,a5
 6f4:	02e68263          	beq	a3,a4,718 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6f8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6fa:	00001717          	auipc	a4,0x1
 6fe:	90f73323          	sd	a5,-1786(a4) # 1000 <freep>
}
 702:	60a2                	ld	ra,8(sp)
 704:	6402                	ld	s0,0(sp)
 706:	0141                	addi	sp,sp,16
 708:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 70a:	4618                	lw	a4,8(a2)
 70c:	9f2d                	addw	a4,a4,a1
 70e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 712:	6398                	ld	a4,0(a5)
 714:	6310                	ld	a2,0(a4)
 716:	b7f9                	j	6e4 <free+0x44>
    p->s.size += bp->s.size;
 718:	ff852703          	lw	a4,-8(a0)
 71c:	9f31                	addw	a4,a4,a2
 71e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 720:	ff053683          	ld	a3,-16(a0)
 724:	bfd1                	j	6f8 <free+0x58>

0000000000000726 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 726:	7139                	addi	sp,sp,-64
 728:	fc06                	sd	ra,56(sp)
 72a:	f822                	sd	s0,48(sp)
 72c:	f04a                	sd	s2,32(sp)
 72e:	ec4e                	sd	s3,24(sp)
 730:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 732:	02051993          	slli	s3,a0,0x20
 736:	0209d993          	srli	s3,s3,0x20
 73a:	09bd                	addi	s3,s3,15
 73c:	0049d993          	srli	s3,s3,0x4
 740:	2985                	addiw	s3,s3,1
 742:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 744:	00001517          	auipc	a0,0x1
 748:	8bc53503          	ld	a0,-1860(a0) # 1000 <freep>
 74c:	c905                	beqz	a0,77c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 74e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 750:	4798                	lw	a4,8(a5)
 752:	09377663          	bgeu	a4,s3,7de <malloc+0xb8>
 756:	f426                	sd	s1,40(sp)
 758:	e852                	sd	s4,16(sp)
 75a:	e456                	sd	s5,8(sp)
 75c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 75e:	8a4e                	mv	s4,s3
 760:	6705                	lui	a4,0x1
 762:	00e9f363          	bgeu	s3,a4,768 <malloc+0x42>
 766:	6a05                	lui	s4,0x1
 768:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 76c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 770:	00001497          	auipc	s1,0x1
 774:	89048493          	addi	s1,s1,-1904 # 1000 <freep>
  if(p == SBRK_ERROR)
 778:	5afd                	li	s5,-1
 77a:	a83d                	j	7b8 <malloc+0x92>
 77c:	f426                	sd	s1,40(sp)
 77e:	e852                	sd	s4,16(sp)
 780:	e456                	sd	s5,8(sp)
 782:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 784:	00001797          	auipc	a5,0x1
 788:	88c78793          	addi	a5,a5,-1908 # 1010 <base>
 78c:	00001717          	auipc	a4,0x1
 790:	86f73a23          	sd	a5,-1932(a4) # 1000 <freep>
 794:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 796:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 79a:	b7d1                	j	75e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 79c:	6398                	ld	a4,0(a5)
 79e:	e118                	sd	a4,0(a0)
 7a0:	a899                	j	7f6 <malloc+0xd0>
  hp->s.size = nu;
 7a2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7a6:	0541                	addi	a0,a0,16
 7a8:	ef9ff0ef          	jal	6a0 <free>
  return freep;
 7ac:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 7ae:	c125                	beqz	a0,80e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7b2:	4798                	lw	a4,8(a5)
 7b4:	03277163          	bgeu	a4,s2,7d6 <malloc+0xb0>
    if(p == freep)
 7b8:	6098                	ld	a4,0(s1)
 7ba:	853e                	mv	a0,a5
 7bc:	fef71ae3          	bne	a4,a5,7b0 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 7c0:	8552                	mv	a0,s4
 7c2:	adbff0ef          	jal	29c <sbrk>
  if(p == SBRK_ERROR)
 7c6:	fd551ee3          	bne	a0,s5,7a2 <malloc+0x7c>
        return 0;
 7ca:	4501                	li	a0,0
 7cc:	74a2                	ld	s1,40(sp)
 7ce:	6a42                	ld	s4,16(sp)
 7d0:	6aa2                	ld	s5,8(sp)
 7d2:	6b02                	ld	s6,0(sp)
 7d4:	a03d                	j	802 <malloc+0xdc>
 7d6:	74a2                	ld	s1,40(sp)
 7d8:	6a42                	ld	s4,16(sp)
 7da:	6aa2                	ld	s5,8(sp)
 7dc:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7de:	fae90fe3          	beq	s2,a4,79c <malloc+0x76>
        p->s.size -= nunits;
 7e2:	4137073b          	subw	a4,a4,s3
 7e6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7e8:	02071693          	slli	a3,a4,0x20
 7ec:	01c6d713          	srli	a4,a3,0x1c
 7f0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7f2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7f6:	00001717          	auipc	a4,0x1
 7fa:	80a73523          	sd	a0,-2038(a4) # 1000 <freep>
      return (void*)(p + 1);
 7fe:	01078513          	addi	a0,a5,16
  }
 802:	70e2                	ld	ra,56(sp)
 804:	7442                	ld	s0,48(sp)
 806:	7902                	ld	s2,32(sp)
 808:	69e2                	ld	s3,24(sp)
 80a:	6121                	addi	sp,sp,64
 80c:	8082                	ret
 80e:	74a2                	ld	s1,40(sp)
 810:	6a42                	ld	s4,16(sp)
 812:	6aa2                	ld	s5,8(sp)
 814:	6b02                	ld	s6,0(sp)
 816:	b7f5                	j	802 <malloc+0xdc>

0000000000000818 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 818:	4885                	li	a7,1
 ecall
 81a:	00000073          	ecall
 ret
 81e:	8082                	ret

0000000000000820 <exit>:
.global exit
exit:
 li a7, SYS_exit
 820:	4889                	li	a7,2
 ecall
 822:	00000073          	ecall
 ret
 826:	8082                	ret

0000000000000828 <wait>:
.global wait
wait:
 li a7, SYS_wait
 828:	488d                	li	a7,3
 ecall
 82a:	00000073          	ecall
 ret
 82e:	8082                	ret

0000000000000830 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 830:	4891                	li	a7,4
 ecall
 832:	00000073          	ecall
 ret
 836:	8082                	ret

0000000000000838 <read>:
.global read
read:
 li a7, SYS_read
 838:	4895                	li	a7,5
 ecall
 83a:	00000073          	ecall
 ret
 83e:	8082                	ret

0000000000000840 <write>:
.global write
write:
 li a7, SYS_write
 840:	48c1                	li	a7,16
 ecall
 842:	00000073          	ecall
 ret
 846:	8082                	ret

0000000000000848 <close>:
.global close
close:
 li a7, SYS_close
 848:	48d5                	li	a7,21
 ecall
 84a:	00000073          	ecall
 ret
 84e:	8082                	ret

0000000000000850 <kill>:
.global kill
kill:
 li a7, SYS_kill
 850:	4899                	li	a7,6
 ecall
 852:	00000073          	ecall
 ret
 856:	8082                	ret

0000000000000858 <exec>:
.global exec
exec:
 li a7, SYS_exec
 858:	489d                	li	a7,7
 ecall
 85a:	00000073          	ecall
 ret
 85e:	8082                	ret

0000000000000860 <open>:
.global open
open:
 li a7, SYS_open
 860:	48bd                	li	a7,15
 ecall
 862:	00000073          	ecall
 ret
 866:	8082                	ret

0000000000000868 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 868:	48c5                	li	a7,17
 ecall
 86a:	00000073          	ecall
 ret
 86e:	8082                	ret

0000000000000870 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 870:	48c9                	li	a7,18
 ecall
 872:	00000073          	ecall
 ret
 876:	8082                	ret

0000000000000878 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 878:	48a1                	li	a7,8
 ecall
 87a:	00000073          	ecall
 ret
 87e:	8082                	ret

0000000000000880 <link>:
.global link
link:
 li a7, SYS_link
 880:	48cd                	li	a7,19
 ecall
 882:	00000073          	ecall
 ret
 886:	8082                	ret

0000000000000888 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 888:	48d1                	li	a7,20
 ecall
 88a:	00000073          	ecall
 ret
 88e:	8082                	ret

0000000000000890 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 890:	48a5                	li	a7,9
 ecall
 892:	00000073          	ecall
 ret
 896:	8082                	ret

0000000000000898 <dup>:
.global dup
dup:
 li a7, SYS_dup
 898:	48a9                	li	a7,10
 ecall
 89a:	00000073          	ecall
 ret
 89e:	8082                	ret

00000000000008a0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 8a0:	48ad                	li	a7,11
 ecall
 8a2:	00000073          	ecall
 ret
 8a6:	8082                	ret

00000000000008a8 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 8a8:	48b1                	li	a7,12
 ecall
 8aa:	00000073          	ecall
 ret
 8ae:	8082                	ret

00000000000008b0 <pause>:
.global pause
pause:
 li a7, SYS_pause
 8b0:	48d9                	li	a7,22
 ecall
 8b2:	00000073          	ecall
 ret
 8b6:	8082                	ret

00000000000008b8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 8b8:	48b9                	li	a7,14
 ecall
 8ba:	00000073          	ecall
 ret
 8be:	8082                	ret
