
_grep：     文件格式 elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
   d:	e9 ab 00 00 00       	jmp    bd <grep+0xbd>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
  18:	c7 45 f0 00 0e 00 00 	movl   $0xe00,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  1f:	eb 4a                	jmp    6b <grep+0x6b>
      *q = 0;
  21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  24:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	ff 75 f0             	pushl  -0x10(%ebp)
  2d:	ff 75 08             	pushl  0x8(%ebp)
  30:	e8 9a 01 00 00       	call   1cf <match>
  35:	83 c4 10             	add    $0x10,%esp
  38:	85 c0                	test   %eax,%eax
  3a:	74 26                	je     62 <grep+0x62>
        *q = '\n';
  3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  3f:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  45:	83 c0 01             	add    $0x1,%eax
  48:	89 c2                	mov    %eax,%edx
  4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  4d:	29 c2                	sub    %eax,%edx
  4f:	89 d0                	mov    %edx,%eax
  51:	83 ec 04             	sub    $0x4,%esp
  54:	50                   	push   %eax
  55:	ff 75 f0             	pushl  -0x10(%ebp)
  58:	6a 01                	push   $0x1
  5a:	e8 43 05 00 00       	call   5a2 <write>
  5f:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
  62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  65:	83 c0 01             	add    $0x1,%eax
  68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  6b:	83 ec 08             	sub    $0x8,%esp
  6e:	6a 0a                	push   $0xa
  70:	ff 75 f0             	pushl  -0x10(%ebp)
  73:	e8 89 03 00 00       	call   401 <strchr>
  78:	83 c4 10             	add    $0x10,%esp
  7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  7e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  82:	75 9d                	jne    21 <grep+0x21>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  84:	81 7d f0 00 0e 00 00 	cmpl   $0xe00,-0x10(%ebp)
  8b:	75 07                	jne    94 <grep+0x94>
      m = 0;
  8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  98:	7e 23                	jle    bd <grep+0xbd>
      m -= p - buf;
  9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  9d:	ba 00 0e 00 00       	mov    $0xe00,%edx
  a2:	29 d0                	sub    %edx,%eax
  a4:	29 45 f4             	sub    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  a7:	83 ec 04             	sub    $0x4,%esp
  aa:	ff 75 f4             	pushl  -0xc(%ebp)
  ad:	ff 75 f0             	pushl  -0x10(%ebp)
  b0:	68 00 0e 00 00       	push   $0xe00
  b5:	e8 83 04 00 00       	call   53d <memmove>
  ba:	83 c4 10             	add    $0x10,%esp
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
  bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c0:	ba 00 04 00 00       	mov    $0x400,%edx
  c5:	29 c2                	sub    %eax,%edx
  c7:	89 d0                	mov    %edx,%eax
  c9:	89 c2                	mov    %eax,%edx
  cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  ce:	05 00 0e 00 00       	add    $0xe00,%eax
  d3:	83 ec 04             	sub    $0x4,%esp
  d6:	52                   	push   %edx
  d7:	50                   	push   %eax
  d8:	ff 75 0c             	pushl  0xc(%ebp)
  db:	e8 ba 04 00 00       	call   59a <read>
  e0:	83 c4 10             	add    $0x10,%esp
  e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  ea:	0f 8f 22 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
  f0:	90                   	nop
  f1:	c9                   	leave  
  f2:	c3                   	ret    

000000f3 <main>:

int
main(int argc, char *argv[])
{
  f3:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f7:	83 e4 f0             	and    $0xfffffff0,%esp
  fa:	ff 71 fc             	pushl  -0x4(%ecx)
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	53                   	push   %ebx
 101:	51                   	push   %ecx
 102:	83 ec 10             	sub    $0x10,%esp
 105:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 107:	83 3b 01             	cmpl   $0x1,(%ebx)
 10a:	7f 17                	jg     123 <main+0x30>
    printf(2, "usage: grep pattern [file ...]\n");
 10c:	83 ec 08             	sub    $0x8,%esp
 10f:	68 c0 0a 00 00       	push   $0xac0
 114:	6a 02                	push   $0x2
 116:	e8 ee 05 00 00       	call   709 <printf>
 11b:	83 c4 10             	add    $0x10,%esp
    exit();
 11e:	e8 5f 04 00 00       	call   582 <exit>
  }
  pattern = argv[1];
 123:	8b 43 04             	mov    0x4(%ebx),%eax
 126:	8b 40 04             	mov    0x4(%eax),%eax
 129:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  if(argc <= 2){
 12c:	83 3b 02             	cmpl   $0x2,(%ebx)
 12f:	7f 15                	jg     146 <main+0x53>
    grep(pattern, 0);
 131:	83 ec 08             	sub    $0x8,%esp
 134:	6a 00                	push   $0x0
 136:	ff 75 f0             	pushl  -0x10(%ebp)
 139:	e8 c2 fe ff ff       	call   0 <grep>
 13e:	83 c4 10             	add    $0x10,%esp
    exit();
 141:	e8 3c 04 00 00       	call   582 <exit>
  }

  for(i = 2; i < argc; i++){
 146:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
 14d:	eb 74                	jmp    1c3 <main+0xd0>
    if((fd = open(argv[i], 0)) < 0){
 14f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 152:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 159:	8b 43 04             	mov    0x4(%ebx),%eax
 15c:	01 d0                	add    %edx,%eax
 15e:	8b 00                	mov    (%eax),%eax
 160:	83 ec 08             	sub    $0x8,%esp
 163:	6a 00                	push   $0x0
 165:	50                   	push   %eax
 166:	e8 57 04 00 00       	call   5c2 <open>
 16b:	83 c4 10             	add    $0x10,%esp
 16e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 171:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 175:	79 29                	jns    1a0 <main+0xad>
      printf(1, "grep: cannot open %s\n", argv[i]);
 177:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 181:	8b 43 04             	mov    0x4(%ebx),%eax
 184:	01 d0                	add    %edx,%eax
 186:	8b 00                	mov    (%eax),%eax
 188:	83 ec 04             	sub    $0x4,%esp
 18b:	50                   	push   %eax
 18c:	68 e0 0a 00 00       	push   $0xae0
 191:	6a 01                	push   $0x1
 193:	e8 71 05 00 00       	call   709 <printf>
 198:	83 c4 10             	add    $0x10,%esp
      exit();
 19b:	e8 e2 03 00 00       	call   582 <exit>
    }
    grep(pattern, fd);
 1a0:	83 ec 08             	sub    $0x8,%esp
 1a3:	ff 75 ec             	pushl  -0x14(%ebp)
 1a6:	ff 75 f0             	pushl  -0x10(%ebp)
 1a9:	e8 52 fe ff ff       	call   0 <grep>
 1ae:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1b1:	83 ec 0c             	sub    $0xc,%esp
 1b4:	ff 75 ec             	pushl  -0x14(%ebp)
 1b7:	e8 ee 03 00 00       	call   5aa <close>
 1bc:	83 c4 10             	add    $0x10,%esp
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1bf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c6:	3b 03                	cmp    (%ebx),%eax
 1c8:	7c 85                	jl     14f <main+0x5c>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1ca:	e8 b3 03 00 00       	call   582 <exit>

000001cf <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1cf:	55                   	push   %ebp
 1d0:	89 e5                	mov    %esp,%ebp
 1d2:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
 1d5:	8b 45 08             	mov    0x8(%ebp),%eax
 1d8:	0f b6 00             	movzbl (%eax),%eax
 1db:	3c 5e                	cmp    $0x5e,%al
 1dd:	75 17                	jne    1f6 <match+0x27>
    return matchhere(re+1, text);
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	83 c0 01             	add    $0x1,%eax
 1e5:	83 ec 08             	sub    $0x8,%esp
 1e8:	ff 75 0c             	pushl  0xc(%ebp)
 1eb:	50                   	push   %eax
 1ec:	e8 38 00 00 00       	call   229 <matchhere>
 1f1:	83 c4 10             	add    $0x10,%esp
 1f4:	eb 31                	jmp    227 <match+0x58>
  do{  // must look at empty string
    if(matchhere(re, text))
 1f6:	83 ec 08             	sub    $0x8,%esp
 1f9:	ff 75 0c             	pushl  0xc(%ebp)
 1fc:	ff 75 08             	pushl  0x8(%ebp)
 1ff:	e8 25 00 00 00       	call   229 <matchhere>
 204:	83 c4 10             	add    $0x10,%esp
 207:	85 c0                	test   %eax,%eax
 209:	74 07                	je     212 <match+0x43>
      return 1;
 20b:	b8 01 00 00 00       	mov    $0x1,%eax
 210:	eb 15                	jmp    227 <match+0x58>
  }while(*text++ != '\0');
 212:	8b 45 0c             	mov    0xc(%ebp),%eax
 215:	8d 50 01             	lea    0x1(%eax),%edx
 218:	89 55 0c             	mov    %edx,0xc(%ebp)
 21b:	0f b6 00             	movzbl (%eax),%eax
 21e:	84 c0                	test   %al,%al
 220:	75 d4                	jne    1f6 <match+0x27>
  return 0;
 222:	b8 00 00 00 00       	mov    $0x0,%eax
}
 227:	c9                   	leave  
 228:	c3                   	ret    

00000229 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 229:	55                   	push   %ebp
 22a:	89 e5                	mov    %esp,%ebp
 22c:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	84 c0                	test   %al,%al
 237:	75 0a                	jne    243 <matchhere+0x1a>
    return 1;
 239:	b8 01 00 00 00       	mov    $0x1,%eax
 23e:	e9 99 00 00 00       	jmp    2dc <matchhere+0xb3>
  if(re[1] == '*')
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	83 c0 01             	add    $0x1,%eax
 249:	0f b6 00             	movzbl (%eax),%eax
 24c:	3c 2a                	cmp    $0x2a,%al
 24e:	75 21                	jne    271 <matchhere+0x48>
    return matchstar(re[0], re+2, text);
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	8d 50 02             	lea    0x2(%eax),%edx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	0f b6 00             	movzbl (%eax),%eax
 25c:	0f be c0             	movsbl %al,%eax
 25f:	83 ec 04             	sub    $0x4,%esp
 262:	ff 75 0c             	pushl  0xc(%ebp)
 265:	52                   	push   %edx
 266:	50                   	push   %eax
 267:	e8 72 00 00 00       	call   2de <matchstar>
 26c:	83 c4 10             	add    $0x10,%esp
 26f:	eb 6b                	jmp    2dc <matchhere+0xb3>
  if(re[0] == '$' && re[1] == '\0')
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	0f b6 00             	movzbl (%eax),%eax
 277:	3c 24                	cmp    $0x24,%al
 279:	75 1d                	jne    298 <matchhere+0x6f>
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	83 c0 01             	add    $0x1,%eax
 281:	0f b6 00             	movzbl (%eax),%eax
 284:	84 c0                	test   %al,%al
 286:	75 10                	jne    298 <matchhere+0x6f>
    return *text == '\0';
 288:	8b 45 0c             	mov    0xc(%ebp),%eax
 28b:	0f b6 00             	movzbl (%eax),%eax
 28e:	84 c0                	test   %al,%al
 290:	0f 94 c0             	sete   %al
 293:	0f b6 c0             	movzbl %al,%eax
 296:	eb 44                	jmp    2dc <matchhere+0xb3>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 298:	8b 45 0c             	mov    0xc(%ebp),%eax
 29b:	0f b6 00             	movzbl (%eax),%eax
 29e:	84 c0                	test   %al,%al
 2a0:	74 35                	je     2d7 <matchhere+0xae>
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
 2a5:	0f b6 00             	movzbl (%eax),%eax
 2a8:	3c 2e                	cmp    $0x2e,%al
 2aa:	74 10                	je     2bc <matchhere+0x93>
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	0f b6 10             	movzbl (%eax),%edx
 2b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b5:	0f b6 00             	movzbl (%eax),%eax
 2b8:	38 c2                	cmp    %al,%dl
 2ba:	75 1b                	jne    2d7 <matchhere+0xae>
    return matchhere(re+1, text+1);
 2bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bf:	8d 50 01             	lea    0x1(%eax),%edx
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	83 c0 01             	add    $0x1,%eax
 2c8:	83 ec 08             	sub    $0x8,%esp
 2cb:	52                   	push   %edx
 2cc:	50                   	push   %eax
 2cd:	e8 57 ff ff ff       	call   229 <matchhere>
 2d2:	83 c4 10             	add    $0x10,%esp
 2d5:	eb 05                	jmp    2dc <matchhere+0xb3>
  return 0;
 2d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2dc:	c9                   	leave  
 2dd:	c3                   	ret    

000002de <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2de:	55                   	push   %ebp
 2df:	89 e5                	mov    %esp,%ebp
 2e1:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2e4:	83 ec 08             	sub    $0x8,%esp
 2e7:	ff 75 10             	pushl  0x10(%ebp)
 2ea:	ff 75 0c             	pushl  0xc(%ebp)
 2ed:	e8 37 ff ff ff       	call   229 <matchhere>
 2f2:	83 c4 10             	add    $0x10,%esp
 2f5:	85 c0                	test   %eax,%eax
 2f7:	74 07                	je     300 <matchstar+0x22>
      return 1;
 2f9:	b8 01 00 00 00       	mov    $0x1,%eax
 2fe:	eb 29                	jmp    329 <matchstar+0x4b>
  }while(*text!='\0' && (*text++==c || c=='.'));
 300:	8b 45 10             	mov    0x10(%ebp),%eax
 303:	0f b6 00             	movzbl (%eax),%eax
 306:	84 c0                	test   %al,%al
 308:	74 1a                	je     324 <matchstar+0x46>
 30a:	8b 45 10             	mov    0x10(%ebp),%eax
 30d:	8d 50 01             	lea    0x1(%eax),%edx
 310:	89 55 10             	mov    %edx,0x10(%ebp)
 313:	0f b6 00             	movzbl (%eax),%eax
 316:	0f be c0             	movsbl %al,%eax
 319:	3b 45 08             	cmp    0x8(%ebp),%eax
 31c:	74 c6                	je     2e4 <matchstar+0x6>
 31e:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 322:	74 c0                	je     2e4 <matchstar+0x6>
  return 0;
 324:	b8 00 00 00 00       	mov    $0x0,%eax
}
 329:	c9                   	leave  
 32a:	c3                   	ret    

0000032b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 32b:	55                   	push   %ebp
 32c:	89 e5                	mov    %esp,%ebp
 32e:	57                   	push   %edi
 32f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 330:	8b 4d 08             	mov    0x8(%ebp),%ecx
 333:	8b 55 10             	mov    0x10(%ebp),%edx
 336:	8b 45 0c             	mov    0xc(%ebp),%eax
 339:	89 cb                	mov    %ecx,%ebx
 33b:	89 df                	mov    %ebx,%edi
 33d:	89 d1                	mov    %edx,%ecx
 33f:	fc                   	cld    
 340:	f3 aa                	rep stos %al,%es:(%edi)
 342:	89 ca                	mov    %ecx,%edx
 344:	89 fb                	mov    %edi,%ebx
 346:	89 5d 08             	mov    %ebx,0x8(%ebp)
 349:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 34c:	90                   	nop
 34d:	5b                   	pop    %ebx
 34e:	5f                   	pop    %edi
 34f:	5d                   	pop    %ebp
 350:	c3                   	ret    

00000351 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 351:	55                   	push   %ebp
 352:	89 e5                	mov    %esp,%ebp
 354:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 357:	8b 45 08             	mov    0x8(%ebp),%eax
 35a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 35d:	90                   	nop
 35e:	8b 45 08             	mov    0x8(%ebp),%eax
 361:	8d 50 01             	lea    0x1(%eax),%edx
 364:	89 55 08             	mov    %edx,0x8(%ebp)
 367:	8b 55 0c             	mov    0xc(%ebp),%edx
 36a:	8d 4a 01             	lea    0x1(%edx),%ecx
 36d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 370:	0f b6 12             	movzbl (%edx),%edx
 373:	88 10                	mov    %dl,(%eax)
 375:	0f b6 00             	movzbl (%eax),%eax
 378:	84 c0                	test   %al,%al
 37a:	75 e2                	jne    35e <strcpy+0xd>
    ;
  return os;
 37c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 37f:	c9                   	leave  
 380:	c3                   	ret    

00000381 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 381:	55                   	push   %ebp
 382:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 384:	eb 08                	jmp    38e <strcmp+0xd>
    p++, q++;
 386:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 38a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
 391:	0f b6 00             	movzbl (%eax),%eax
 394:	84 c0                	test   %al,%al
 396:	74 10                	je     3a8 <strcmp+0x27>
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	0f b6 10             	movzbl (%eax),%edx
 39e:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a1:	0f b6 00             	movzbl (%eax),%eax
 3a4:	38 c2                	cmp    %al,%dl
 3a6:	74 de                	je     386 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3a8:	8b 45 08             	mov    0x8(%ebp),%eax
 3ab:	0f b6 00             	movzbl (%eax),%eax
 3ae:	0f b6 d0             	movzbl %al,%edx
 3b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b4:	0f b6 00             	movzbl (%eax),%eax
 3b7:	0f b6 c0             	movzbl %al,%eax
 3ba:	29 c2                	sub    %eax,%edx
 3bc:	89 d0                	mov    %edx,%eax
}
 3be:	5d                   	pop    %ebp
 3bf:	c3                   	ret    

000003c0 <strlen>:

uint
strlen(char *s)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3cd:	eb 04                	jmp    3d3 <strlen+0x13>
 3cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3d6:	8b 45 08             	mov    0x8(%ebp),%eax
 3d9:	01 d0                	add    %edx,%eax
 3db:	0f b6 00             	movzbl (%eax),%eax
 3de:	84 c0                	test   %al,%al
 3e0:	75 ed                	jne    3cf <strlen+0xf>
    ;
  return n;
 3e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3e5:	c9                   	leave  
 3e6:	c3                   	ret    

000003e7 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3e7:	55                   	push   %ebp
 3e8:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3ea:	8b 45 10             	mov    0x10(%ebp),%eax
 3ed:	50                   	push   %eax
 3ee:	ff 75 0c             	pushl  0xc(%ebp)
 3f1:	ff 75 08             	pushl  0x8(%ebp)
 3f4:	e8 32 ff ff ff       	call   32b <stosb>
 3f9:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3ff:	c9                   	leave  
 400:	c3                   	ret    

00000401 <strchr>:

char*
strchr(const char *s, char c)
{
 401:	55                   	push   %ebp
 402:	89 e5                	mov    %esp,%ebp
 404:	83 ec 04             	sub    $0x4,%esp
 407:	8b 45 0c             	mov    0xc(%ebp),%eax
 40a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 40d:	eb 14                	jmp    423 <strchr+0x22>
    if(*s == c)
 40f:	8b 45 08             	mov    0x8(%ebp),%eax
 412:	0f b6 00             	movzbl (%eax),%eax
 415:	3a 45 fc             	cmp    -0x4(%ebp),%al
 418:	75 05                	jne    41f <strchr+0x1e>
      return (char*)s;
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	eb 13                	jmp    432 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 41f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	0f b6 00             	movzbl (%eax),%eax
 429:	84 c0                	test   %al,%al
 42b:	75 e2                	jne    40f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 42d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 432:	c9                   	leave  
 433:	c3                   	ret    

00000434 <gets>:

char*
gets(char *buf, int max)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 43a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 441:	eb 42                	jmp    485 <gets+0x51>
    cc = read(0, &c, 1);
 443:	83 ec 04             	sub    $0x4,%esp
 446:	6a 01                	push   $0x1
 448:	8d 45 ef             	lea    -0x11(%ebp),%eax
 44b:	50                   	push   %eax
 44c:	6a 00                	push   $0x0
 44e:	e8 47 01 00 00       	call   59a <read>
 453:	83 c4 10             	add    $0x10,%esp
 456:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 459:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 45d:	7e 33                	jle    492 <gets+0x5e>
      break;
    buf[i++] = c;
 45f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 462:	8d 50 01             	lea    0x1(%eax),%edx
 465:	89 55 f4             	mov    %edx,-0xc(%ebp)
 468:	89 c2                	mov    %eax,%edx
 46a:	8b 45 08             	mov    0x8(%ebp),%eax
 46d:	01 c2                	add    %eax,%edx
 46f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 473:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 475:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 479:	3c 0a                	cmp    $0xa,%al
 47b:	74 16                	je     493 <gets+0x5f>
 47d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 481:	3c 0d                	cmp    $0xd,%al
 483:	74 0e                	je     493 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 485:	8b 45 f4             	mov    -0xc(%ebp),%eax
 488:	83 c0 01             	add    $0x1,%eax
 48b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 48e:	7c b3                	jl     443 <gets+0xf>
 490:	eb 01                	jmp    493 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 492:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 493:	8b 55 f4             	mov    -0xc(%ebp),%edx
 496:	8b 45 08             	mov    0x8(%ebp),%eax
 499:	01 d0                	add    %edx,%eax
 49b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 49e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4a1:	c9                   	leave  
 4a2:	c3                   	ret    

000004a3 <stat>:

int
stat(char *n, struct stat *st)
{
 4a3:	55                   	push   %ebp
 4a4:	89 e5                	mov    %esp,%ebp
 4a6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4a9:	83 ec 08             	sub    $0x8,%esp
 4ac:	6a 00                	push   $0x0
 4ae:	ff 75 08             	pushl  0x8(%ebp)
 4b1:	e8 0c 01 00 00       	call   5c2 <open>
 4b6:	83 c4 10             	add    $0x10,%esp
 4b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4c0:	79 07                	jns    4c9 <stat+0x26>
    return -1;
 4c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4c7:	eb 25                	jmp    4ee <stat+0x4b>
  r = fstat(fd, st);
 4c9:	83 ec 08             	sub    $0x8,%esp
 4cc:	ff 75 0c             	pushl  0xc(%ebp)
 4cf:	ff 75 f4             	pushl  -0xc(%ebp)
 4d2:	e8 03 01 00 00       	call   5da <fstat>
 4d7:	83 c4 10             	add    $0x10,%esp
 4da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4dd:	83 ec 0c             	sub    $0xc,%esp
 4e0:	ff 75 f4             	pushl  -0xc(%ebp)
 4e3:	e8 c2 00 00 00       	call   5aa <close>
 4e8:	83 c4 10             	add    $0x10,%esp
  return r;
 4eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4ee:	c9                   	leave  
 4ef:	c3                   	ret    

000004f0 <atoi>:

int
atoi(const char *s)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4fd:	eb 25                	jmp    524 <atoi+0x34>
    n = n*10 + *s++ - '0';
 4ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
 502:	89 d0                	mov    %edx,%eax
 504:	c1 e0 02             	shl    $0x2,%eax
 507:	01 d0                	add    %edx,%eax
 509:	01 c0                	add    %eax,%eax
 50b:	89 c1                	mov    %eax,%ecx
 50d:	8b 45 08             	mov    0x8(%ebp),%eax
 510:	8d 50 01             	lea    0x1(%eax),%edx
 513:	89 55 08             	mov    %edx,0x8(%ebp)
 516:	0f b6 00             	movzbl (%eax),%eax
 519:	0f be c0             	movsbl %al,%eax
 51c:	01 c8                	add    %ecx,%eax
 51e:	83 e8 30             	sub    $0x30,%eax
 521:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 524:	8b 45 08             	mov    0x8(%ebp),%eax
 527:	0f b6 00             	movzbl (%eax),%eax
 52a:	3c 2f                	cmp    $0x2f,%al
 52c:	7e 0a                	jle    538 <atoi+0x48>
 52e:	8b 45 08             	mov    0x8(%ebp),%eax
 531:	0f b6 00             	movzbl (%eax),%eax
 534:	3c 39                	cmp    $0x39,%al
 536:	7e c7                	jle    4ff <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 538:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 53b:	c9                   	leave  
 53c:	c3                   	ret    

0000053d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 53d:	55                   	push   %ebp
 53e:	89 e5                	mov    %esp,%ebp
 540:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 549:	8b 45 0c             	mov    0xc(%ebp),%eax
 54c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 54f:	eb 17                	jmp    568 <memmove+0x2b>
    *dst++ = *src++;
 551:	8b 45 fc             	mov    -0x4(%ebp),%eax
 554:	8d 50 01             	lea    0x1(%eax),%edx
 557:	89 55 fc             	mov    %edx,-0x4(%ebp)
 55a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 55d:	8d 4a 01             	lea    0x1(%edx),%ecx
 560:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 563:	0f b6 12             	movzbl (%edx),%edx
 566:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 568:	8b 45 10             	mov    0x10(%ebp),%eax
 56b:	8d 50 ff             	lea    -0x1(%eax),%edx
 56e:	89 55 10             	mov    %edx,0x10(%ebp)
 571:	85 c0                	test   %eax,%eax
 573:	7f dc                	jg     551 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 575:	8b 45 08             	mov    0x8(%ebp),%eax
}
 578:	c9                   	leave  
 579:	c3                   	ret    

0000057a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 57a:	b8 01 00 00 00       	mov    $0x1,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <exit>:
SYSCALL(exit)
 582:	b8 02 00 00 00       	mov    $0x2,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <wait>:
SYSCALL(wait)
 58a:	b8 03 00 00 00       	mov    $0x3,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <pipe>:
SYSCALL(pipe)
 592:	b8 04 00 00 00       	mov    $0x4,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <read>:
SYSCALL(read)
 59a:	b8 05 00 00 00       	mov    $0x5,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <write>:
SYSCALL(write)
 5a2:	b8 10 00 00 00       	mov    $0x10,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <close>:
SYSCALL(close)
 5aa:	b8 15 00 00 00       	mov    $0x15,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <kill>:
SYSCALL(kill)
 5b2:	b8 06 00 00 00       	mov    $0x6,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <exec>:
SYSCALL(exec)
 5ba:	b8 07 00 00 00       	mov    $0x7,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <open>:
SYSCALL(open)
 5c2:	b8 0f 00 00 00       	mov    $0xf,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <mknod>:
SYSCALL(mknod)
 5ca:	b8 11 00 00 00       	mov    $0x11,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <unlink>:
SYSCALL(unlink)
 5d2:	b8 12 00 00 00       	mov    $0x12,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <fstat>:
SYSCALL(fstat)
 5da:	b8 08 00 00 00       	mov    $0x8,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <link>:
SYSCALL(link)
 5e2:	b8 13 00 00 00       	mov    $0x13,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <mkdir>:
SYSCALL(mkdir)
 5ea:	b8 14 00 00 00       	mov    $0x14,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <chdir>:
SYSCALL(chdir)
 5f2:	b8 09 00 00 00       	mov    $0x9,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <dup>:
SYSCALL(dup)
 5fa:	b8 0a 00 00 00       	mov    $0xa,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <getpid>:
SYSCALL(getpid)
 602:	b8 0b 00 00 00       	mov    $0xb,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <sbrk>:
SYSCALL(sbrk)
 60a:	b8 0c 00 00 00       	mov    $0xc,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <sleep>:
SYSCALL(sleep)
 612:	b8 0d 00 00 00       	mov    $0xd,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <uptime>:
SYSCALL(uptime)
 61a:	b8 0e 00 00 00       	mov    $0xe,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <drawrect>:
SYSCALL(drawrect)
 622:	b8 16 00 00 00       	mov    $0x16,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <drawarea>:
SYSCALL(drawarea)
 62a:	b8 17 00 00 00       	mov    $0x17,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 632:	55                   	push   %ebp
 633:	89 e5                	mov    %esp,%ebp
 635:	83 ec 18             	sub    $0x18,%esp
 638:	8b 45 0c             	mov    0xc(%ebp),%eax
 63b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 63e:	83 ec 04             	sub    $0x4,%esp
 641:	6a 01                	push   $0x1
 643:	8d 45 f4             	lea    -0xc(%ebp),%eax
 646:	50                   	push   %eax
 647:	ff 75 08             	pushl  0x8(%ebp)
 64a:	e8 53 ff ff ff       	call   5a2 <write>
 64f:	83 c4 10             	add    $0x10,%esp
}
 652:	90                   	nop
 653:	c9                   	leave  
 654:	c3                   	ret    

00000655 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 655:	55                   	push   %ebp
 656:	89 e5                	mov    %esp,%ebp
 658:	53                   	push   %ebx
 659:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 65c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 663:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 667:	74 17                	je     680 <printint+0x2b>
 669:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 66d:	79 11                	jns    680 <printint+0x2b>
    neg = 1;
 66f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 676:	8b 45 0c             	mov    0xc(%ebp),%eax
 679:	f7 d8                	neg    %eax
 67b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 67e:	eb 06                	jmp    686 <printint+0x31>
  } else {
    x = xx;
 680:	8b 45 0c             	mov    0xc(%ebp),%eax
 683:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 686:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 68d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 690:	8d 41 01             	lea    0x1(%ecx),%eax
 693:	89 45 f4             	mov    %eax,-0xc(%ebp)
 696:	8b 5d 10             	mov    0x10(%ebp),%ebx
 699:	8b 45 ec             	mov    -0x14(%ebp),%eax
 69c:	ba 00 00 00 00       	mov    $0x0,%edx
 6a1:	f7 f3                	div    %ebx
 6a3:	89 d0                	mov    %edx,%eax
 6a5:	0f b6 80 cc 0d 00 00 	movzbl 0xdcc(%eax),%eax
 6ac:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6b6:	ba 00 00 00 00       	mov    $0x0,%edx
 6bb:	f7 f3                	div    %ebx
 6bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6c4:	75 c7                	jne    68d <printint+0x38>
  if(neg)
 6c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6ca:	74 2d                	je     6f9 <printint+0xa4>
    buf[i++] = '-';
 6cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6cf:	8d 50 01             	lea    0x1(%eax),%edx
 6d2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6d5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6da:	eb 1d                	jmp    6f9 <printint+0xa4>
    putc(fd, buf[i]);
 6dc:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e2:	01 d0                	add    %edx,%eax
 6e4:	0f b6 00             	movzbl (%eax),%eax
 6e7:	0f be c0             	movsbl %al,%eax
 6ea:	83 ec 08             	sub    $0x8,%esp
 6ed:	50                   	push   %eax
 6ee:	ff 75 08             	pushl  0x8(%ebp)
 6f1:	e8 3c ff ff ff       	call   632 <putc>
 6f6:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6f9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 701:	79 d9                	jns    6dc <printint+0x87>
    putc(fd, buf[i]);
}
 703:	90                   	nop
 704:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 707:	c9                   	leave  
 708:	c3                   	ret    

00000709 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 709:	55                   	push   %ebp
 70a:	89 e5                	mov    %esp,%ebp
 70c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 70f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 716:	8d 45 0c             	lea    0xc(%ebp),%eax
 719:	83 c0 04             	add    $0x4,%eax
 71c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 71f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 726:	e9 59 01 00 00       	jmp    884 <printf+0x17b>
    c = fmt[i] & 0xff;
 72b:	8b 55 0c             	mov    0xc(%ebp),%edx
 72e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 731:	01 d0                	add    %edx,%eax
 733:	0f b6 00             	movzbl (%eax),%eax
 736:	0f be c0             	movsbl %al,%eax
 739:	25 ff 00 00 00       	and    $0xff,%eax
 73e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 741:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 745:	75 2c                	jne    773 <printf+0x6a>
      if(c == '%'){
 747:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 74b:	75 0c                	jne    759 <printf+0x50>
        state = '%';
 74d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 754:	e9 27 01 00 00       	jmp    880 <printf+0x177>
      } else {
        putc(fd, c);
 759:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 75c:	0f be c0             	movsbl %al,%eax
 75f:	83 ec 08             	sub    $0x8,%esp
 762:	50                   	push   %eax
 763:	ff 75 08             	pushl  0x8(%ebp)
 766:	e8 c7 fe ff ff       	call   632 <putc>
 76b:	83 c4 10             	add    $0x10,%esp
 76e:	e9 0d 01 00 00       	jmp    880 <printf+0x177>
      }
    } else if(state == '%'){
 773:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 777:	0f 85 03 01 00 00    	jne    880 <printf+0x177>
      if(c == 'd'){
 77d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 781:	75 1e                	jne    7a1 <printf+0x98>
        printint(fd, *ap, 10, 1);
 783:	8b 45 e8             	mov    -0x18(%ebp),%eax
 786:	8b 00                	mov    (%eax),%eax
 788:	6a 01                	push   $0x1
 78a:	6a 0a                	push   $0xa
 78c:	50                   	push   %eax
 78d:	ff 75 08             	pushl  0x8(%ebp)
 790:	e8 c0 fe ff ff       	call   655 <printint>
 795:	83 c4 10             	add    $0x10,%esp
        ap++;
 798:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 79c:	e9 d8 00 00 00       	jmp    879 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7a1:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7a5:	74 06                	je     7ad <printf+0xa4>
 7a7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7ab:	75 1e                	jne    7cb <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7b0:	8b 00                	mov    (%eax),%eax
 7b2:	6a 00                	push   $0x0
 7b4:	6a 10                	push   $0x10
 7b6:	50                   	push   %eax
 7b7:	ff 75 08             	pushl  0x8(%ebp)
 7ba:	e8 96 fe ff ff       	call   655 <printint>
 7bf:	83 c4 10             	add    $0x10,%esp
        ap++;
 7c2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7c6:	e9 ae 00 00 00       	jmp    879 <printf+0x170>
      } else if(c == 's'){
 7cb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7cf:	75 43                	jne    814 <printf+0x10b>
        s = (char*)*ap;
 7d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d4:	8b 00                	mov    (%eax),%eax
 7d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7e1:	75 25                	jne    808 <printf+0xff>
          s = "(null)";
 7e3:	c7 45 f4 f6 0a 00 00 	movl   $0xaf6,-0xc(%ebp)
        while(*s != 0){
 7ea:	eb 1c                	jmp    808 <printf+0xff>
          putc(fd, *s);
 7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ef:	0f b6 00             	movzbl (%eax),%eax
 7f2:	0f be c0             	movsbl %al,%eax
 7f5:	83 ec 08             	sub    $0x8,%esp
 7f8:	50                   	push   %eax
 7f9:	ff 75 08             	pushl  0x8(%ebp)
 7fc:	e8 31 fe ff ff       	call   632 <putc>
 801:	83 c4 10             	add    $0x10,%esp
          s++;
 804:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 808:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80b:	0f b6 00             	movzbl (%eax),%eax
 80e:	84 c0                	test   %al,%al
 810:	75 da                	jne    7ec <printf+0xe3>
 812:	eb 65                	jmp    879 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 814:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 818:	75 1d                	jne    837 <printf+0x12e>
        putc(fd, *ap);
 81a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 81d:	8b 00                	mov    (%eax),%eax
 81f:	0f be c0             	movsbl %al,%eax
 822:	83 ec 08             	sub    $0x8,%esp
 825:	50                   	push   %eax
 826:	ff 75 08             	pushl  0x8(%ebp)
 829:	e8 04 fe ff ff       	call   632 <putc>
 82e:	83 c4 10             	add    $0x10,%esp
        ap++;
 831:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 835:	eb 42                	jmp    879 <printf+0x170>
      } else if(c == '%'){
 837:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 83b:	75 17                	jne    854 <printf+0x14b>
        putc(fd, c);
 83d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 840:	0f be c0             	movsbl %al,%eax
 843:	83 ec 08             	sub    $0x8,%esp
 846:	50                   	push   %eax
 847:	ff 75 08             	pushl  0x8(%ebp)
 84a:	e8 e3 fd ff ff       	call   632 <putc>
 84f:	83 c4 10             	add    $0x10,%esp
 852:	eb 25                	jmp    879 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 854:	83 ec 08             	sub    $0x8,%esp
 857:	6a 25                	push   $0x25
 859:	ff 75 08             	pushl  0x8(%ebp)
 85c:	e8 d1 fd ff ff       	call   632 <putc>
 861:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 864:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 867:	0f be c0             	movsbl %al,%eax
 86a:	83 ec 08             	sub    $0x8,%esp
 86d:	50                   	push   %eax
 86e:	ff 75 08             	pushl  0x8(%ebp)
 871:	e8 bc fd ff ff       	call   632 <putc>
 876:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 879:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 880:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 884:	8b 55 0c             	mov    0xc(%ebp),%edx
 887:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88a:	01 d0                	add    %edx,%eax
 88c:	0f b6 00             	movzbl (%eax),%eax
 88f:	84 c0                	test   %al,%al
 891:	0f 85 94 fe ff ff    	jne    72b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 897:	90                   	nop
 898:	c9                   	leave  
 899:	c3                   	ret    

0000089a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 89a:	55                   	push   %ebp
 89b:	89 e5                	mov    %esp,%ebp
 89d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8a0:	8b 45 08             	mov    0x8(%ebp),%eax
 8a3:	83 e8 08             	sub    $0x8,%eax
 8a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a9:	a1 e8 0d 00 00       	mov    0xde8,%eax
 8ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8b1:	eb 24                	jmp    8d7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b6:	8b 00                	mov    (%eax),%eax
 8b8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8bb:	77 12                	ja     8cf <free+0x35>
 8bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8c3:	77 24                	ja     8e9 <free+0x4f>
 8c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c8:	8b 00                	mov    (%eax),%eax
 8ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8cd:	77 1a                	ja     8e9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d2:	8b 00                	mov    (%eax),%eax
 8d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8da:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8dd:	76 d4                	jbe    8b3 <free+0x19>
 8df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e2:	8b 00                	mov    (%eax),%eax
 8e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8e7:	76 ca                	jbe    8b3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ec:	8b 40 04             	mov    0x4(%eax),%eax
 8ef:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f9:	01 c2                	add    %eax,%edx
 8fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fe:	8b 00                	mov    (%eax),%eax
 900:	39 c2                	cmp    %eax,%edx
 902:	75 24                	jne    928 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 904:	8b 45 f8             	mov    -0x8(%ebp),%eax
 907:	8b 50 04             	mov    0x4(%eax),%edx
 90a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90d:	8b 00                	mov    (%eax),%eax
 90f:	8b 40 04             	mov    0x4(%eax),%eax
 912:	01 c2                	add    %eax,%edx
 914:	8b 45 f8             	mov    -0x8(%ebp),%eax
 917:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 91a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91d:	8b 00                	mov    (%eax),%eax
 91f:	8b 10                	mov    (%eax),%edx
 921:	8b 45 f8             	mov    -0x8(%ebp),%eax
 924:	89 10                	mov    %edx,(%eax)
 926:	eb 0a                	jmp    932 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 928:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92b:	8b 10                	mov    (%eax),%edx
 92d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 930:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 932:	8b 45 fc             	mov    -0x4(%ebp),%eax
 935:	8b 40 04             	mov    0x4(%eax),%eax
 938:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 93f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 942:	01 d0                	add    %edx,%eax
 944:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 947:	75 20                	jne    969 <free+0xcf>
    p->s.size += bp->s.size;
 949:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94c:	8b 50 04             	mov    0x4(%eax),%edx
 94f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 952:	8b 40 04             	mov    0x4(%eax),%eax
 955:	01 c2                	add    %eax,%edx
 957:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 95d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 960:	8b 10                	mov    (%eax),%edx
 962:	8b 45 fc             	mov    -0x4(%ebp),%eax
 965:	89 10                	mov    %edx,(%eax)
 967:	eb 08                	jmp    971 <free+0xd7>
  } else
    p->s.ptr = bp;
 969:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 96f:	89 10                	mov    %edx,(%eax)
  freep = p;
 971:	8b 45 fc             	mov    -0x4(%ebp),%eax
 974:	a3 e8 0d 00 00       	mov    %eax,0xde8
}
 979:	90                   	nop
 97a:	c9                   	leave  
 97b:	c3                   	ret    

0000097c <morecore>:

static Header*
morecore(uint nu)
{
 97c:	55                   	push   %ebp
 97d:	89 e5                	mov    %esp,%ebp
 97f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 982:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 989:	77 07                	ja     992 <morecore+0x16>
    nu = 4096;
 98b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 992:	8b 45 08             	mov    0x8(%ebp),%eax
 995:	c1 e0 03             	shl    $0x3,%eax
 998:	83 ec 0c             	sub    $0xc,%esp
 99b:	50                   	push   %eax
 99c:	e8 69 fc ff ff       	call   60a <sbrk>
 9a1:	83 c4 10             	add    $0x10,%esp
 9a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9a7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9ab:	75 07                	jne    9b4 <morecore+0x38>
    return 0;
 9ad:	b8 00 00 00 00       	mov    $0x0,%eax
 9b2:	eb 26                	jmp    9da <morecore+0x5e>
  hp = (Header*)p;
 9b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9bd:	8b 55 08             	mov    0x8(%ebp),%edx
 9c0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c6:	83 c0 08             	add    $0x8,%eax
 9c9:	83 ec 0c             	sub    $0xc,%esp
 9cc:	50                   	push   %eax
 9cd:	e8 c8 fe ff ff       	call   89a <free>
 9d2:	83 c4 10             	add    $0x10,%esp
  return freep;
 9d5:	a1 e8 0d 00 00       	mov    0xde8,%eax
}
 9da:	c9                   	leave  
 9db:	c3                   	ret    

000009dc <malloc>:

void*
malloc(uint nbytes)
{
 9dc:	55                   	push   %ebp
 9dd:	89 e5                	mov    %esp,%ebp
 9df:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e2:	8b 45 08             	mov    0x8(%ebp),%eax
 9e5:	83 c0 07             	add    $0x7,%eax
 9e8:	c1 e8 03             	shr    $0x3,%eax
 9eb:	83 c0 01             	add    $0x1,%eax
 9ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9f1:	a1 e8 0d 00 00       	mov    0xde8,%eax
 9f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9fd:	75 23                	jne    a22 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9ff:	c7 45 f0 e0 0d 00 00 	movl   $0xde0,-0x10(%ebp)
 a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a09:	a3 e8 0d 00 00       	mov    %eax,0xde8
 a0e:	a1 e8 0d 00 00       	mov    0xde8,%eax
 a13:	a3 e0 0d 00 00       	mov    %eax,0xde0
    base.s.size = 0;
 a18:	c7 05 e4 0d 00 00 00 	movl   $0x0,0xde4
 a1f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a25:	8b 00                	mov    (%eax),%eax
 a27:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2d:	8b 40 04             	mov    0x4(%eax),%eax
 a30:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a33:	72 4d                	jb     a82 <malloc+0xa6>
      if(p->s.size == nunits)
 a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a38:	8b 40 04             	mov    0x4(%eax),%eax
 a3b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a3e:	75 0c                	jne    a4c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a43:	8b 10                	mov    (%eax),%edx
 a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a48:	89 10                	mov    %edx,(%eax)
 a4a:	eb 26                	jmp    a72 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4f:	8b 40 04             	mov    0x4(%eax),%eax
 a52:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a55:	89 c2                	mov    %eax,%edx
 a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a60:	8b 40 04             	mov    0x4(%eax),%eax
 a63:	c1 e0 03             	shl    $0x3,%eax
 a66:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a6f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a75:	a3 e8 0d 00 00       	mov    %eax,0xde8
      return (void*)(p + 1);
 a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7d:	83 c0 08             	add    $0x8,%eax
 a80:	eb 3b                	jmp    abd <malloc+0xe1>
    }
    if(p == freep)
 a82:	a1 e8 0d 00 00       	mov    0xde8,%eax
 a87:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a8a:	75 1e                	jne    aaa <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a8c:	83 ec 0c             	sub    $0xc,%esp
 a8f:	ff 75 ec             	pushl  -0x14(%ebp)
 a92:	e8 e5 fe ff ff       	call   97c <morecore>
 a97:	83 c4 10             	add    $0x10,%esp
 a9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 aa1:	75 07                	jne    aaa <malloc+0xce>
        return 0;
 aa3:	b8 00 00 00 00       	mov    $0x0,%eax
 aa8:	eb 13                	jmp    abd <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aad:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab3:	8b 00                	mov    (%eax),%eax
 ab5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ab8:	e9 6d ff ff ff       	jmp    a2a <malloc+0x4e>
}
 abd:	c9                   	leave  
 abe:	c3                   	ret    
