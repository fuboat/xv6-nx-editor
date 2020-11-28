
_init：     文件格式 elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "init_ascii", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 02                	push   $0x2
  16:	68 d0 08 00 00       	push   $0x8d0
  1b:	e8 a8 03 00 00       	call   3c8 <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 d0 08 00 00       	push   $0x8d0
  33:	e8 98 03 00 00       	call   3d0 <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 d0 08 00 00       	push   $0x8d0
  45:	e8 7e 03 00 00       	call   3c8 <open>
  4a:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	6a 00                	push   $0x0
  52:	e8 a9 03 00 00       	call   400 <dup>
  57:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	6a 00                	push   $0x0
  5f:	e8 9c 03 00 00       	call   400 <dup>
  64:	83 c4 10             	add    $0x10,%esp
drawrect(0,0,800,600,65535);
  67:	83 ec 0c             	sub    $0xc,%esp
  6a:	68 ff ff 00 00       	push   $0xffff
  6f:	68 58 02 00 00       	push   $0x258
  74:	68 20 03 00 00       	push   $0x320
  79:	6a 00                	push   $0x0
  7b:	6a 00                	push   $0x0
  7d:	e8 a6 03 00 00       	call   428 <drawrect>
  82:	83 c4 20             	add    $0x20,%esp
  printf(1, "init: try to draw background\n");
  85:	83 ec 08             	sub    $0x8,%esp
  88:	68 d8 08 00 00       	push   $0x8d8
  8d:	6a 01                	push   $0x1
  8f:	e8 7b 04 00 00       	call   50f <printf>
  94:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  97:	83 ec 08             	sub    $0x8,%esp
  9a:	68 f6 08 00 00       	push   $0x8f6
  9f:	6a 01                	push   $0x1
  a1:	e8 69 04 00 00       	call   50f <printf>
  a6:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  a9:	e8 d2 02 00 00       	call   380 <fork>
  ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  b5:	79 17                	jns    ce <main+0xce>
      printf(1, "init: fork failed\n");
  b7:	83 ec 08             	sub    $0x8,%esp
  ba:	68 09 09 00 00       	push   $0x909
  bf:	6a 01                	push   $0x1
  c1:	e8 49 04 00 00       	call   50f <printf>
  c6:	83 c4 10             	add    $0x10,%esp
      exit();
  c9:	e8 ba 02 00 00       	call   388 <exit>
    }
    if(pid == 0){
  ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  d2:	75 3e                	jne    112 <main+0x112>
      exec("init_ascii", argv);
  d4:	83 ec 08             	sub    $0x8,%esp
  d7:	68 8c 0b 00 00       	push   $0xb8c
  dc:	68 c5 08 00 00       	push   $0x8c5
  e1:	e8 da 02 00 00       	call   3c0 <exec>
  e6:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  e9:	83 ec 08             	sub    $0x8,%esp
  ec:	68 1c 09 00 00       	push   $0x91c
  f1:	6a 01                	push   $0x1
  f3:	e8 17 04 00 00       	call   50f <printf>
  f8:	83 c4 10             	add    $0x10,%esp
      exit();
  fb:	e8 88 02 00 00       	call   388 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
 100:	83 ec 08             	sub    $0x8,%esp
 103:	68 32 09 00 00       	push   $0x932
 108:	6a 01                	push   $0x1
 10a:	e8 00 04 00 00       	call   50f <printf>
 10f:	83 c4 10             	add    $0x10,%esp
    if(pid == 0){
      exec("init_ascii", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
 112:	e8 79 02 00 00       	call   390 <wait>
 117:	89 45 f0             	mov    %eax,-0x10(%ebp)
 11a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 11e:	0f 88 73 ff ff ff    	js     97 <main+0x97>
 124:	8b 45 f0             	mov    -0x10(%ebp),%eax
 127:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 12a:	75 d4                	jne    100 <main+0x100>
      printf(1, "zombie!\n");
  }
 12c:	e9 66 ff ff ff       	jmp    97 <main+0x97>

00000131 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 131:	55                   	push   %ebp
 132:	89 e5                	mov    %esp,%ebp
 134:	57                   	push   %edi
 135:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 136:	8b 4d 08             	mov    0x8(%ebp),%ecx
 139:	8b 55 10             	mov    0x10(%ebp),%edx
 13c:	8b 45 0c             	mov    0xc(%ebp),%eax
 13f:	89 cb                	mov    %ecx,%ebx
 141:	89 df                	mov    %ebx,%edi
 143:	89 d1                	mov    %edx,%ecx
 145:	fc                   	cld    
 146:	f3 aa                	rep stos %al,%es:(%edi)
 148:	89 ca                	mov    %ecx,%edx
 14a:	89 fb                	mov    %edi,%ebx
 14c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 14f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 152:	90                   	nop
 153:	5b                   	pop    %ebx
 154:	5f                   	pop    %edi
 155:	5d                   	pop    %ebp
 156:	c3                   	ret    

00000157 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 157:	55                   	push   %ebp
 158:	89 e5                	mov    %esp,%ebp
 15a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 163:	90                   	nop
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	8d 50 01             	lea    0x1(%eax),%edx
 16a:	89 55 08             	mov    %edx,0x8(%ebp)
 16d:	8b 55 0c             	mov    0xc(%ebp),%edx
 170:	8d 4a 01             	lea    0x1(%edx),%ecx
 173:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 176:	0f b6 12             	movzbl (%edx),%edx
 179:	88 10                	mov    %dl,(%eax)
 17b:	0f b6 00             	movzbl (%eax),%eax
 17e:	84 c0                	test   %al,%al
 180:	75 e2                	jne    164 <strcpy+0xd>
    ;
  return os;
 182:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 185:	c9                   	leave  
 186:	c3                   	ret    

00000187 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 187:	55                   	push   %ebp
 188:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 18a:	eb 08                	jmp    194 <strcmp+0xd>
    p++, q++;
 18c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 190:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 194:	8b 45 08             	mov    0x8(%ebp),%eax
 197:	0f b6 00             	movzbl (%eax),%eax
 19a:	84 c0                	test   %al,%al
 19c:	74 10                	je     1ae <strcmp+0x27>
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	0f b6 10             	movzbl (%eax),%edx
 1a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a7:	0f b6 00             	movzbl (%eax),%eax
 1aa:	38 c2                	cmp    %al,%dl
 1ac:	74 de                	je     18c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1ae:	8b 45 08             	mov    0x8(%ebp),%eax
 1b1:	0f b6 00             	movzbl (%eax),%eax
 1b4:	0f b6 d0             	movzbl %al,%edx
 1b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ba:	0f b6 00             	movzbl (%eax),%eax
 1bd:	0f b6 c0             	movzbl %al,%eax
 1c0:	29 c2                	sub    %eax,%edx
 1c2:	89 d0                	mov    %edx,%eax
}
 1c4:	5d                   	pop    %ebp
 1c5:	c3                   	ret    

000001c6 <strlen>:

uint
strlen(char *s)
{
 1c6:	55                   	push   %ebp
 1c7:	89 e5                	mov    %esp,%ebp
 1c9:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1d3:	eb 04                	jmp    1d9 <strlen+0x13>
 1d5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1dc:	8b 45 08             	mov    0x8(%ebp),%eax
 1df:	01 d0                	add    %edx,%eax
 1e1:	0f b6 00             	movzbl (%eax),%eax
 1e4:	84 c0                	test   %al,%al
 1e6:	75 ed                	jne    1d5 <strlen+0xf>
    ;
  return n;
 1e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1eb:	c9                   	leave  
 1ec:	c3                   	ret    

000001ed <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ed:	55                   	push   %ebp
 1ee:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1f0:	8b 45 10             	mov    0x10(%ebp),%eax
 1f3:	50                   	push   %eax
 1f4:	ff 75 0c             	pushl  0xc(%ebp)
 1f7:	ff 75 08             	pushl  0x8(%ebp)
 1fa:	e8 32 ff ff ff       	call   131 <stosb>
 1ff:	83 c4 0c             	add    $0xc,%esp
  return dst;
 202:	8b 45 08             	mov    0x8(%ebp),%eax
}
 205:	c9                   	leave  
 206:	c3                   	ret    

00000207 <strchr>:

char*
strchr(const char *s, char c)
{
 207:	55                   	push   %ebp
 208:	89 e5                	mov    %esp,%ebp
 20a:	83 ec 04             	sub    $0x4,%esp
 20d:	8b 45 0c             	mov    0xc(%ebp),%eax
 210:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 213:	eb 14                	jmp    229 <strchr+0x22>
    if(*s == c)
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	0f b6 00             	movzbl (%eax),%eax
 21b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 21e:	75 05                	jne    225 <strchr+0x1e>
      return (char*)s;
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	eb 13                	jmp    238 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 225:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	0f b6 00             	movzbl (%eax),%eax
 22f:	84 c0                	test   %al,%al
 231:	75 e2                	jne    215 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 233:	b8 00 00 00 00       	mov    $0x0,%eax
}
 238:	c9                   	leave  
 239:	c3                   	ret    

0000023a <gets>:

char*
gets(char *buf, int max)
{
 23a:	55                   	push   %ebp
 23b:	89 e5                	mov    %esp,%ebp
 23d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 240:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 247:	eb 42                	jmp    28b <gets+0x51>
    cc = read(0, &c, 1);
 249:	83 ec 04             	sub    $0x4,%esp
 24c:	6a 01                	push   $0x1
 24e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 251:	50                   	push   %eax
 252:	6a 00                	push   $0x0
 254:	e8 47 01 00 00       	call   3a0 <read>
 259:	83 c4 10             	add    $0x10,%esp
 25c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 25f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 263:	7e 33                	jle    298 <gets+0x5e>
      break;
    buf[i++] = c;
 265:	8b 45 f4             	mov    -0xc(%ebp),%eax
 268:	8d 50 01             	lea    0x1(%eax),%edx
 26b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 26e:	89 c2                	mov    %eax,%edx
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	01 c2                	add    %eax,%edx
 275:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 279:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 27b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27f:	3c 0a                	cmp    $0xa,%al
 281:	74 16                	je     299 <gets+0x5f>
 283:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 287:	3c 0d                	cmp    $0xd,%al
 289:	74 0e                	je     299 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 28b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28e:	83 c0 01             	add    $0x1,%eax
 291:	3b 45 0c             	cmp    0xc(%ebp),%eax
 294:	7c b3                	jl     249 <gets+0xf>
 296:	eb 01                	jmp    299 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 298:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 299:	8b 55 f4             	mov    -0xc(%ebp),%edx
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	01 d0                	add    %edx,%eax
 2a1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a7:	c9                   	leave  
 2a8:	c3                   	ret    

000002a9 <stat>:

int
stat(char *n, struct stat *st)
{
 2a9:	55                   	push   %ebp
 2aa:	89 e5                	mov    %esp,%ebp
 2ac:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2af:	83 ec 08             	sub    $0x8,%esp
 2b2:	6a 00                	push   $0x0
 2b4:	ff 75 08             	pushl  0x8(%ebp)
 2b7:	e8 0c 01 00 00       	call   3c8 <open>
 2bc:	83 c4 10             	add    $0x10,%esp
 2bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2c6:	79 07                	jns    2cf <stat+0x26>
    return -1;
 2c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2cd:	eb 25                	jmp    2f4 <stat+0x4b>
  r = fstat(fd, st);
 2cf:	83 ec 08             	sub    $0x8,%esp
 2d2:	ff 75 0c             	pushl  0xc(%ebp)
 2d5:	ff 75 f4             	pushl  -0xc(%ebp)
 2d8:	e8 03 01 00 00       	call   3e0 <fstat>
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2e3:	83 ec 0c             	sub    $0xc,%esp
 2e6:	ff 75 f4             	pushl  -0xc(%ebp)
 2e9:	e8 c2 00 00 00       	call   3b0 <close>
 2ee:	83 c4 10             	add    $0x10,%esp
  return r;
 2f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2f4:	c9                   	leave  
 2f5:	c3                   	ret    

000002f6 <atoi>:

int
atoi(const char *s)
{
 2f6:	55                   	push   %ebp
 2f7:	89 e5                	mov    %esp,%ebp
 2f9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 303:	eb 25                	jmp    32a <atoi+0x34>
    n = n*10 + *s++ - '0';
 305:	8b 55 fc             	mov    -0x4(%ebp),%edx
 308:	89 d0                	mov    %edx,%eax
 30a:	c1 e0 02             	shl    $0x2,%eax
 30d:	01 d0                	add    %edx,%eax
 30f:	01 c0                	add    %eax,%eax
 311:	89 c1                	mov    %eax,%ecx
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	8d 50 01             	lea    0x1(%eax),%edx
 319:	89 55 08             	mov    %edx,0x8(%ebp)
 31c:	0f b6 00             	movzbl (%eax),%eax
 31f:	0f be c0             	movsbl %al,%eax
 322:	01 c8                	add    %ecx,%eax
 324:	83 e8 30             	sub    $0x30,%eax
 327:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 32a:	8b 45 08             	mov    0x8(%ebp),%eax
 32d:	0f b6 00             	movzbl (%eax),%eax
 330:	3c 2f                	cmp    $0x2f,%al
 332:	7e 0a                	jle    33e <atoi+0x48>
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	0f b6 00             	movzbl (%eax),%eax
 33a:	3c 39                	cmp    $0x39,%al
 33c:	7e c7                	jle    305 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 33e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 341:	c9                   	leave  
 342:	c3                   	ret    

00000343 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 343:	55                   	push   %ebp
 344:	89 e5                	mov    %esp,%ebp
 346:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 349:	8b 45 08             	mov    0x8(%ebp),%eax
 34c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 34f:	8b 45 0c             	mov    0xc(%ebp),%eax
 352:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 355:	eb 17                	jmp    36e <memmove+0x2b>
    *dst++ = *src++;
 357:	8b 45 fc             	mov    -0x4(%ebp),%eax
 35a:	8d 50 01             	lea    0x1(%eax),%edx
 35d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 360:	8b 55 f8             	mov    -0x8(%ebp),%edx
 363:	8d 4a 01             	lea    0x1(%edx),%ecx
 366:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 369:	0f b6 12             	movzbl (%edx),%edx
 36c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 36e:	8b 45 10             	mov    0x10(%ebp),%eax
 371:	8d 50 ff             	lea    -0x1(%eax),%edx
 374:	89 55 10             	mov    %edx,0x10(%ebp)
 377:	85 c0                	test   %eax,%eax
 379:	7f dc                	jg     357 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 37b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 37e:	c9                   	leave  
 37f:	c3                   	ret    

00000380 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 380:	b8 01 00 00 00       	mov    $0x1,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <exit>:
SYSCALL(exit)
 388:	b8 02 00 00 00       	mov    $0x2,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <wait>:
SYSCALL(wait)
 390:	b8 03 00 00 00       	mov    $0x3,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <pipe>:
SYSCALL(pipe)
 398:	b8 04 00 00 00       	mov    $0x4,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <read>:
SYSCALL(read)
 3a0:	b8 05 00 00 00       	mov    $0x5,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <write>:
SYSCALL(write)
 3a8:	b8 10 00 00 00       	mov    $0x10,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <close>:
SYSCALL(close)
 3b0:	b8 15 00 00 00       	mov    $0x15,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <kill>:
SYSCALL(kill)
 3b8:	b8 06 00 00 00       	mov    $0x6,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <exec>:
SYSCALL(exec)
 3c0:	b8 07 00 00 00       	mov    $0x7,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <open>:
SYSCALL(open)
 3c8:	b8 0f 00 00 00       	mov    $0xf,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <mknod>:
SYSCALL(mknod)
 3d0:	b8 11 00 00 00       	mov    $0x11,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <unlink>:
SYSCALL(unlink)
 3d8:	b8 12 00 00 00       	mov    $0x12,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <fstat>:
SYSCALL(fstat)
 3e0:	b8 08 00 00 00       	mov    $0x8,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <link>:
SYSCALL(link)
 3e8:	b8 13 00 00 00       	mov    $0x13,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <mkdir>:
SYSCALL(mkdir)
 3f0:	b8 14 00 00 00       	mov    $0x14,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <chdir>:
SYSCALL(chdir)
 3f8:	b8 09 00 00 00       	mov    $0x9,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <dup>:
SYSCALL(dup)
 400:	b8 0a 00 00 00       	mov    $0xa,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <getpid>:
SYSCALL(getpid)
 408:	b8 0b 00 00 00       	mov    $0xb,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <sbrk>:
SYSCALL(sbrk)
 410:	b8 0c 00 00 00       	mov    $0xc,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <sleep>:
SYSCALL(sleep)
 418:	b8 0d 00 00 00       	mov    $0xd,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <uptime>:
SYSCALL(uptime)
 420:	b8 0e 00 00 00       	mov    $0xe,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <drawrect>:
SYSCALL(drawrect)
 428:	b8 16 00 00 00       	mov    $0x16,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <drawarea>:
SYSCALL(drawarea)
 430:	b8 17 00 00 00       	mov    $0x17,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 438:	55                   	push   %ebp
 439:	89 e5                	mov    %esp,%ebp
 43b:	83 ec 18             	sub    $0x18,%esp
 43e:	8b 45 0c             	mov    0xc(%ebp),%eax
 441:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 444:	83 ec 04             	sub    $0x4,%esp
 447:	6a 01                	push   $0x1
 449:	8d 45 f4             	lea    -0xc(%ebp),%eax
 44c:	50                   	push   %eax
 44d:	ff 75 08             	pushl  0x8(%ebp)
 450:	e8 53 ff ff ff       	call   3a8 <write>
 455:	83 c4 10             	add    $0x10,%esp
}
 458:	90                   	nop
 459:	c9                   	leave  
 45a:	c3                   	ret    

0000045b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 45b:	55                   	push   %ebp
 45c:	89 e5                	mov    %esp,%ebp
 45e:	53                   	push   %ebx
 45f:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 462:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 469:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 46d:	74 17                	je     486 <printint+0x2b>
 46f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 473:	79 11                	jns    486 <printint+0x2b>
    neg = 1;
 475:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 47c:	8b 45 0c             	mov    0xc(%ebp),%eax
 47f:	f7 d8                	neg    %eax
 481:	89 45 ec             	mov    %eax,-0x14(%ebp)
 484:	eb 06                	jmp    48c <printint+0x31>
  } else {
    x = xx;
 486:	8b 45 0c             	mov    0xc(%ebp),%eax
 489:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 48c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 493:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 496:	8d 41 01             	lea    0x1(%ecx),%eax
 499:	89 45 f4             	mov    %eax,-0xc(%ebp)
 49c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 49f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a2:	ba 00 00 00 00       	mov    $0x0,%edx
 4a7:	f7 f3                	div    %ebx
 4a9:	89 d0                	mov    %edx,%eax
 4ab:	0f b6 80 94 0b 00 00 	movzbl 0xb94(%eax),%eax
 4b2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4bc:	ba 00 00 00 00       	mov    $0x0,%edx
 4c1:	f7 f3                	div    %ebx
 4c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ca:	75 c7                	jne    493 <printint+0x38>
  if(neg)
 4cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4d0:	74 2d                	je     4ff <printint+0xa4>
    buf[i++] = '-';
 4d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d5:	8d 50 01             	lea    0x1(%eax),%edx
 4d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4db:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4e0:	eb 1d                	jmp    4ff <printint+0xa4>
    putc(fd, buf[i]);
 4e2:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e8:	01 d0                	add    %edx,%eax
 4ea:	0f b6 00             	movzbl (%eax),%eax
 4ed:	0f be c0             	movsbl %al,%eax
 4f0:	83 ec 08             	sub    $0x8,%esp
 4f3:	50                   	push   %eax
 4f4:	ff 75 08             	pushl  0x8(%ebp)
 4f7:	e8 3c ff ff ff       	call   438 <putc>
 4fc:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4ff:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 503:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 507:	79 d9                	jns    4e2 <printint+0x87>
    putc(fd, buf[i]);
}
 509:	90                   	nop
 50a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 50d:	c9                   	leave  
 50e:	c3                   	ret    

0000050f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 50f:	55                   	push   %ebp
 510:	89 e5                	mov    %esp,%ebp
 512:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 515:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 51c:	8d 45 0c             	lea    0xc(%ebp),%eax
 51f:	83 c0 04             	add    $0x4,%eax
 522:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 525:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 52c:	e9 59 01 00 00       	jmp    68a <printf+0x17b>
    c = fmt[i] & 0xff;
 531:	8b 55 0c             	mov    0xc(%ebp),%edx
 534:	8b 45 f0             	mov    -0x10(%ebp),%eax
 537:	01 d0                	add    %edx,%eax
 539:	0f b6 00             	movzbl (%eax),%eax
 53c:	0f be c0             	movsbl %al,%eax
 53f:	25 ff 00 00 00       	and    $0xff,%eax
 544:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 547:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 54b:	75 2c                	jne    579 <printf+0x6a>
      if(c == '%'){
 54d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 551:	75 0c                	jne    55f <printf+0x50>
        state = '%';
 553:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 55a:	e9 27 01 00 00       	jmp    686 <printf+0x177>
      } else {
        putc(fd, c);
 55f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 562:	0f be c0             	movsbl %al,%eax
 565:	83 ec 08             	sub    $0x8,%esp
 568:	50                   	push   %eax
 569:	ff 75 08             	pushl  0x8(%ebp)
 56c:	e8 c7 fe ff ff       	call   438 <putc>
 571:	83 c4 10             	add    $0x10,%esp
 574:	e9 0d 01 00 00       	jmp    686 <printf+0x177>
      }
    } else if(state == '%'){
 579:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 57d:	0f 85 03 01 00 00    	jne    686 <printf+0x177>
      if(c == 'd'){
 583:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 587:	75 1e                	jne    5a7 <printf+0x98>
        printint(fd, *ap, 10, 1);
 589:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58c:	8b 00                	mov    (%eax),%eax
 58e:	6a 01                	push   $0x1
 590:	6a 0a                	push   $0xa
 592:	50                   	push   %eax
 593:	ff 75 08             	pushl  0x8(%ebp)
 596:	e8 c0 fe ff ff       	call   45b <printint>
 59b:	83 c4 10             	add    $0x10,%esp
        ap++;
 59e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a2:	e9 d8 00 00 00       	jmp    67f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5a7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5ab:	74 06                	je     5b3 <printf+0xa4>
 5ad:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5b1:	75 1e                	jne    5d1 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b6:	8b 00                	mov    (%eax),%eax
 5b8:	6a 00                	push   $0x0
 5ba:	6a 10                	push   $0x10
 5bc:	50                   	push   %eax
 5bd:	ff 75 08             	pushl  0x8(%ebp)
 5c0:	e8 96 fe ff ff       	call   45b <printint>
 5c5:	83 c4 10             	add    $0x10,%esp
        ap++;
 5c8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5cc:	e9 ae 00 00 00       	jmp    67f <printf+0x170>
      } else if(c == 's'){
 5d1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5d5:	75 43                	jne    61a <printf+0x10b>
        s = (char*)*ap;
 5d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5da:	8b 00                	mov    (%eax),%eax
 5dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5df:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5e7:	75 25                	jne    60e <printf+0xff>
          s = "(null)";
 5e9:	c7 45 f4 3b 09 00 00 	movl   $0x93b,-0xc(%ebp)
        while(*s != 0){
 5f0:	eb 1c                	jmp    60e <printf+0xff>
          putc(fd, *s);
 5f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f5:	0f b6 00             	movzbl (%eax),%eax
 5f8:	0f be c0             	movsbl %al,%eax
 5fb:	83 ec 08             	sub    $0x8,%esp
 5fe:	50                   	push   %eax
 5ff:	ff 75 08             	pushl  0x8(%ebp)
 602:	e8 31 fe ff ff       	call   438 <putc>
 607:	83 c4 10             	add    $0x10,%esp
          s++;
 60a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 60e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 611:	0f b6 00             	movzbl (%eax),%eax
 614:	84 c0                	test   %al,%al
 616:	75 da                	jne    5f2 <printf+0xe3>
 618:	eb 65                	jmp    67f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 61a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 61e:	75 1d                	jne    63d <printf+0x12e>
        putc(fd, *ap);
 620:	8b 45 e8             	mov    -0x18(%ebp),%eax
 623:	8b 00                	mov    (%eax),%eax
 625:	0f be c0             	movsbl %al,%eax
 628:	83 ec 08             	sub    $0x8,%esp
 62b:	50                   	push   %eax
 62c:	ff 75 08             	pushl  0x8(%ebp)
 62f:	e8 04 fe ff ff       	call   438 <putc>
 634:	83 c4 10             	add    $0x10,%esp
        ap++;
 637:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 63b:	eb 42                	jmp    67f <printf+0x170>
      } else if(c == '%'){
 63d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 641:	75 17                	jne    65a <printf+0x14b>
        putc(fd, c);
 643:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 646:	0f be c0             	movsbl %al,%eax
 649:	83 ec 08             	sub    $0x8,%esp
 64c:	50                   	push   %eax
 64d:	ff 75 08             	pushl  0x8(%ebp)
 650:	e8 e3 fd ff ff       	call   438 <putc>
 655:	83 c4 10             	add    $0x10,%esp
 658:	eb 25                	jmp    67f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 65a:	83 ec 08             	sub    $0x8,%esp
 65d:	6a 25                	push   $0x25
 65f:	ff 75 08             	pushl  0x8(%ebp)
 662:	e8 d1 fd ff ff       	call   438 <putc>
 667:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 66a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 66d:	0f be c0             	movsbl %al,%eax
 670:	83 ec 08             	sub    $0x8,%esp
 673:	50                   	push   %eax
 674:	ff 75 08             	pushl  0x8(%ebp)
 677:	e8 bc fd ff ff       	call   438 <putc>
 67c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 67f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 686:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 68a:	8b 55 0c             	mov    0xc(%ebp),%edx
 68d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 690:	01 d0                	add    %edx,%eax
 692:	0f b6 00             	movzbl (%eax),%eax
 695:	84 c0                	test   %al,%al
 697:	0f 85 94 fe ff ff    	jne    531 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 69d:	90                   	nop
 69e:	c9                   	leave  
 69f:	c3                   	ret    

000006a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a6:	8b 45 08             	mov    0x8(%ebp),%eax
 6a9:	83 e8 08             	sub    $0x8,%eax
 6ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6af:	a1 b0 0b 00 00       	mov    0xbb0,%eax
 6b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b7:	eb 24                	jmp    6dd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	8b 00                	mov    (%eax),%eax
 6be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c1:	77 12                	ja     6d5 <free+0x35>
 6c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c9:	77 24                	ja     6ef <free+0x4f>
 6cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ce:	8b 00                	mov    (%eax),%eax
 6d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d3:	77 1a                	ja     6ef <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 00                	mov    (%eax),%eax
 6da:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e3:	76 d4                	jbe    6b9 <free+0x19>
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ed:	76 ca                	jbe    6b9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f2:	8b 40 04             	mov    0x4(%eax),%eax
 6f5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ff:	01 c2                	add    %eax,%edx
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	8b 00                	mov    (%eax),%eax
 706:	39 c2                	cmp    %eax,%edx
 708:	75 24                	jne    72e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 70a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70d:	8b 50 04             	mov    0x4(%eax),%edx
 710:	8b 45 fc             	mov    -0x4(%ebp),%eax
 713:	8b 00                	mov    (%eax),%eax
 715:	8b 40 04             	mov    0x4(%eax),%eax
 718:	01 c2                	add    %eax,%edx
 71a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 720:	8b 45 fc             	mov    -0x4(%ebp),%eax
 723:	8b 00                	mov    (%eax),%eax
 725:	8b 10                	mov    (%eax),%edx
 727:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72a:	89 10                	mov    %edx,(%eax)
 72c:	eb 0a                	jmp    738 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 72e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 731:	8b 10                	mov    (%eax),%edx
 733:	8b 45 f8             	mov    -0x8(%ebp),%eax
 736:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 738:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73b:	8b 40 04             	mov    0x4(%eax),%eax
 73e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	01 d0                	add    %edx,%eax
 74a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 74d:	75 20                	jne    76f <free+0xcf>
    p->s.size += bp->s.size;
 74f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 752:	8b 50 04             	mov    0x4(%eax),%edx
 755:	8b 45 f8             	mov    -0x8(%ebp),%eax
 758:	8b 40 04             	mov    0x4(%eax),%eax
 75b:	01 c2                	add    %eax,%edx
 75d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 760:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 763:	8b 45 f8             	mov    -0x8(%ebp),%eax
 766:	8b 10                	mov    (%eax),%edx
 768:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76b:	89 10                	mov    %edx,(%eax)
 76d:	eb 08                	jmp    777 <free+0xd7>
  } else
    p->s.ptr = bp;
 76f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 772:	8b 55 f8             	mov    -0x8(%ebp),%edx
 775:	89 10                	mov    %edx,(%eax)
  freep = p;
 777:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77a:	a3 b0 0b 00 00       	mov    %eax,0xbb0
}
 77f:	90                   	nop
 780:	c9                   	leave  
 781:	c3                   	ret    

00000782 <morecore>:

static Header*
morecore(uint nu)
{
 782:	55                   	push   %ebp
 783:	89 e5                	mov    %esp,%ebp
 785:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 788:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 78f:	77 07                	ja     798 <morecore+0x16>
    nu = 4096;
 791:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 798:	8b 45 08             	mov    0x8(%ebp),%eax
 79b:	c1 e0 03             	shl    $0x3,%eax
 79e:	83 ec 0c             	sub    $0xc,%esp
 7a1:	50                   	push   %eax
 7a2:	e8 69 fc ff ff       	call   410 <sbrk>
 7a7:	83 c4 10             	add    $0x10,%esp
 7aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7ad:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7b1:	75 07                	jne    7ba <morecore+0x38>
    return 0;
 7b3:	b8 00 00 00 00       	mov    $0x0,%eax
 7b8:	eb 26                	jmp    7e0 <morecore+0x5e>
  hp = (Header*)p;
 7ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c3:	8b 55 08             	mov    0x8(%ebp),%edx
 7c6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cc:	83 c0 08             	add    $0x8,%eax
 7cf:	83 ec 0c             	sub    $0xc,%esp
 7d2:	50                   	push   %eax
 7d3:	e8 c8 fe ff ff       	call   6a0 <free>
 7d8:	83 c4 10             	add    $0x10,%esp
  return freep;
 7db:	a1 b0 0b 00 00       	mov    0xbb0,%eax
}
 7e0:	c9                   	leave  
 7e1:	c3                   	ret    

000007e2 <malloc>:

void*
malloc(uint nbytes)
{
 7e2:	55                   	push   %ebp
 7e3:	89 e5                	mov    %esp,%ebp
 7e5:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e8:	8b 45 08             	mov    0x8(%ebp),%eax
 7eb:	83 c0 07             	add    $0x7,%eax
 7ee:	c1 e8 03             	shr    $0x3,%eax
 7f1:	83 c0 01             	add    $0x1,%eax
 7f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7f7:	a1 b0 0b 00 00       	mov    0xbb0,%eax
 7fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 803:	75 23                	jne    828 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 805:	c7 45 f0 a8 0b 00 00 	movl   $0xba8,-0x10(%ebp)
 80c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80f:	a3 b0 0b 00 00       	mov    %eax,0xbb0
 814:	a1 b0 0b 00 00       	mov    0xbb0,%eax
 819:	a3 a8 0b 00 00       	mov    %eax,0xba8
    base.s.size = 0;
 81e:	c7 05 ac 0b 00 00 00 	movl   $0x0,0xbac
 825:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 828:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82b:	8b 00                	mov    (%eax),%eax
 82d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 830:	8b 45 f4             	mov    -0xc(%ebp),%eax
 833:	8b 40 04             	mov    0x4(%eax),%eax
 836:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 839:	72 4d                	jb     888 <malloc+0xa6>
      if(p->s.size == nunits)
 83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83e:	8b 40 04             	mov    0x4(%eax),%eax
 841:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 844:	75 0c                	jne    852 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 846:	8b 45 f4             	mov    -0xc(%ebp),%eax
 849:	8b 10                	mov    (%eax),%edx
 84b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84e:	89 10                	mov    %edx,(%eax)
 850:	eb 26                	jmp    878 <malloc+0x96>
      else {
        p->s.size -= nunits;
 852:	8b 45 f4             	mov    -0xc(%ebp),%eax
 855:	8b 40 04             	mov    0x4(%eax),%eax
 858:	2b 45 ec             	sub    -0x14(%ebp),%eax
 85b:	89 c2                	mov    %eax,%edx
 85d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 860:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 863:	8b 45 f4             	mov    -0xc(%ebp),%eax
 866:	8b 40 04             	mov    0x4(%eax),%eax
 869:	c1 e0 03             	shl    $0x3,%eax
 86c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 86f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 872:	8b 55 ec             	mov    -0x14(%ebp),%edx
 875:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 878:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87b:	a3 b0 0b 00 00       	mov    %eax,0xbb0
      return (void*)(p + 1);
 880:	8b 45 f4             	mov    -0xc(%ebp),%eax
 883:	83 c0 08             	add    $0x8,%eax
 886:	eb 3b                	jmp    8c3 <malloc+0xe1>
    }
    if(p == freep)
 888:	a1 b0 0b 00 00       	mov    0xbb0,%eax
 88d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 890:	75 1e                	jne    8b0 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 892:	83 ec 0c             	sub    $0xc,%esp
 895:	ff 75 ec             	pushl  -0x14(%ebp)
 898:	e8 e5 fe ff ff       	call   782 <morecore>
 89d:	83 c4 10             	add    $0x10,%esp
 8a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8a7:	75 07                	jne    8b0 <malloc+0xce>
        return 0;
 8a9:	b8 00 00 00 00       	mov    $0x0,%eax
 8ae:	eb 13                	jmp    8c3 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b9:	8b 00                	mov    (%eax),%eax
 8bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8be:	e9 6d ff ff ff       	jmp    830 <malloc+0x4e>
}
 8c3:	c9                   	leave  
 8c4:	c3                   	ret    
