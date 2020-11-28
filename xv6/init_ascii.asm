
_init_ascii：     文件格式 elf32-i386


Disassembly of section .text:

00000000 <char_point_init>:
#include "user.h"
// draw char
int char_to_point[256][16][8];
int char_to_area[256][16][8];

void char_point_init(){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	81 ec 28 04 00 00    	sub    $0x428,%esp
    printf(0, "\n\ninitializing ASCII\n\n");
   9:	83 ec 08             	sub    $0x8,%esp
   c:	68 2b 0a 00 00       	push   $0xa2b
  11:	6a 00                	push   $0x0
  13:	e8 5d 06 00 00       	call   675 <printf>
  18:	83 c4 10             	add    $0x10,%esp
    int fp;
    char buffer[1024];
    if((fp = open("hankaku.txt", 0)) < 0){
  1b:	83 ec 08             	sub    $0x8,%esp
  1e:	6a 00                	push   $0x0
  20:	68 42 0a 00 00       	push   $0xa42
  25:	e8 04 05 00 00       	call   52e <open>
  2a:	83 c4 10             	add    $0x10,%esp
  2d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  30:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  34:	79 17                	jns    4d <char_point_init+0x4d>
        printf(0, "open hankaku.txt error");
  36:	83 ec 08             	sub    $0x8,%esp
  39:	68 4e 0a 00 00       	push   $0xa4e
  3e:	6a 00                	push   $0x0
  40:	e8 30 06 00 00       	call   675 <printf>
  45:	83 c4 10             	add    $0x10,%esp
  48:	e9 b1 01 00 00       	jmp    1fe <char_point_init+0x1fe>
        return;
    }

    int i = 0, n = 0;
  4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  54:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
    int x = 0, y = 0, char_ascii = 0;
  5b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  62:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  69:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    while((n = read(fp, buffer, sizeof(buffer))) > 0){
  70:	e9 ea 00 00 00       	jmp    15f <char_point_init+0x15f>
        for(i = 0; i < n; ++i){
  75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  7c:	e9 d2 00 00 00       	jmp    153 <char_point_init+0x153>
            if(buffer[i] == '*' || buffer[i] == '.'){
  81:	8d 95 d8 fb ff ff    	lea    -0x428(%ebp),%edx
  87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8a:	01 d0                	add    %edx,%eax
  8c:	0f b6 00             	movzbl (%eax),%eax
  8f:	3c 2a                	cmp    $0x2a,%al
  91:	74 16                	je     a9 <char_point_init+0xa9>
  93:	8d 95 d8 fb ff ff    	lea    -0x428(%ebp),%edx
  99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  9c:	01 d0                	add    %edx,%eax
  9e:	0f b6 00             	movzbl (%eax),%eax
  a1:	3c 2e                	cmp    $0x2e,%al
  a3:	0f 85 a6 00 00 00    	jne    14f <char_point_init+0x14f>
                if(buffer[i] == '*'){
  a9:	8d 95 d8 fb ff ff    	lea    -0x428(%ebp),%edx
  af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b2:	01 d0                	add    %edx,%eax
  b4:	0f b6 00             	movzbl (%eax),%eax
  b7:	3c 2a                	cmp    $0x2a,%al
  b9:	75 4a                	jne    105 <char_point_init+0x105>
                    char_to_point[char_ascii][y][x] = 1;
  bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  be:	c1 e0 04             	shl    $0x4,%eax
  c1:	89 c2                	mov    %eax,%edx
  c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  c6:	01 d0                	add    %edx,%eax
  c8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  d2:	01 d0                	add    %edx,%eax
  d4:	c7 04 85 60 0d 02 00 	movl   $0x1,0x20d60(,%eax,4)
  db:	01 00 00 00 
                    char_to_area[char_ascii][y][x] = 0;
  df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  e2:	c1 e0 04             	shl    $0x4,%eax
  e5:	89 c2                	mov    %eax,%edx
  e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  ea:	01 d0                	add    %edx,%eax
  ec:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f6:	01 d0                	add    %edx,%eax
  f8:	c7 04 85 60 0d 00 00 	movl   $0x0,0xd60(,%eax,4)
  ff:	00 00 00 00 
 103:	eb 24                	jmp    129 <char_point_init+0x129>
                }else{
                    char_to_area[char_ascii][y][x] = -1;
 105:	8b 45 e8             	mov    -0x18(%ebp),%eax
 108:	c1 e0 04             	shl    $0x4,%eax
 10b:	89 c2                	mov    %eax,%edx
 10d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 110:	01 d0                	add    %edx,%eax
 112:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 119:	8b 45 f0             	mov    -0x10(%ebp),%eax
 11c:	01 d0                	add    %edx,%eax
 11e:	c7 04 85 60 0d 00 00 	movl   $0xffffffff,0xd60(,%eax,4)
 125:	ff ff ff ff 
                }
                ++x;
 129:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
                if(x >= 8){
 12d:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
 131:	7e 0b                	jle    13e <char_point_init+0x13e>
                    x = 0;
 133:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
                    ++y;
 13a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
                }
                if(y >= 16){
 13e:	83 7d ec 0f          	cmpl   $0xf,-0x14(%ebp)
 142:	7e 0b                	jle    14f <char_point_init+0x14f>
                    y = 0;
 144:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
                    ++char_ascii;
 14b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    }

    int i = 0, n = 0;
    int x = 0, y = 0, char_ascii = 0;
    while((n = read(fp, buffer, sizeof(buffer))) > 0){
        for(i = 0; i < n; ++i){
 14f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 153:	8b 45 f4             	mov    -0xc(%ebp),%eax
 156:	3b 45 d8             	cmp    -0x28(%ebp),%eax
 159:	0f 8c 22 ff ff ff    	jl     81 <char_point_init+0x81>
        return;
    }

    int i = 0, n = 0;
    int x = 0, y = 0, char_ascii = 0;
    while((n = read(fp, buffer, sizeof(buffer))) > 0){
 15f:	83 ec 04             	sub    $0x4,%esp
 162:	68 00 04 00 00       	push   $0x400
 167:	8d 85 d8 fb ff ff    	lea    -0x428(%ebp),%eax
 16d:	50                   	push   %eax
 16e:	ff 75 dc             	pushl  -0x24(%ebp)
 171:	e8 90 03 00 00       	call   506 <read>
 176:	83 c4 10             	add    $0x10,%esp
 179:	89 45 d8             	mov    %eax,-0x28(%ebp)
 17c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
 180:	0f 8f ef fe ff ff    	jg     75 <char_point_init+0x75>

            }
        }
    }
    //for(i = 0; i < 256; ++i){
        for(int j = 0; j < 16; ++j){
 186:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 18d:	eb 57                	jmp    1e6 <char_point_init+0x1e6>
            for (int k = 0; k < 8; ++k){
 18f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 196:	eb 32                	jmp    1ca <char_point_init+0x1ca>
                printf(0,"%d ", char_to_area['a'][j][k]);
 198:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 19b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 1a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1a5:	01 d0                	add    %edx,%eax
 1a7:	05 80 30 00 00       	add    $0x3080,%eax
 1ac:	8b 04 85 60 0d 00 00 	mov    0xd60(,%eax,4),%eax
 1b3:	83 ec 04             	sub    $0x4,%esp
 1b6:	50                   	push   %eax
 1b7:	68 65 0a 00 00       	push   $0xa65
 1bc:	6a 00                	push   $0x0
 1be:	e8 b2 04 00 00       	call   675 <printf>
 1c3:	83 c4 10             	add    $0x10,%esp
            }
        }
    }
    //for(i = 0; i < 256; ++i){
        for(int j = 0; j < 16; ++j){
            for (int k = 0; k < 8; ++k){
 1c6:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
 1ca:	83 7d e0 07          	cmpl   $0x7,-0x20(%ebp)
 1ce:	7e c8                	jle    198 <char_point_init+0x198>
                printf(0,"%d ", char_to_area['a'][j][k]);
            }
            printf(0, "\n");
 1d0:	83 ec 08             	sub    $0x8,%esp
 1d3:	68 69 0a 00 00       	push   $0xa69
 1d8:	6a 00                	push   $0x0
 1da:	e8 96 04 00 00       	call   675 <printf>
 1df:	83 c4 10             	add    $0x10,%esp

            }
        }
    }
    //for(i = 0; i < 256; ++i){
        for(int j = 0; j < 16; ++j){
 1e2:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 1e6:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
 1ea:	7e a3                	jle    18f <char_point_init+0x18f>
            for (int k = 0; k < 8; ++k){
                printf(0,"%d ", char_to_area['a'][j][k]);
            }
            printf(0, "\n");
        }
        printf(0,"\n----------\n");
 1ec:	83 ec 08             	sub    $0x8,%esp
 1ef:	68 6b 0a 00 00       	push   $0xa6b
 1f4:	6a 00                	push   $0x0
 1f6:	e8 7a 04 00 00       	call   675 <printf>
 1fb:	83 c4 10             	add    $0x10,%esp
    //}*/
}
 1fe:	c9                   	leave  
 1ff:	c3                   	ret    

00000200 <get_text_area>:

void* get_text_area(char c){
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	83 ec 14             	sub    $0x14,%esp
 206:	8b 45 08             	mov    0x8(%ebp),%eax
 209:	88 45 ec             	mov    %al,-0x14(%ebp)
    int num = c;
 20c:	0f be 45 ec          	movsbl -0x14(%ebp),%eax
 210:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return char_to_area[num];
 213:	8b 45 fc             	mov    -0x4(%ebp),%eax
 216:	c1 e0 09             	shl    $0x9,%eax
 219:	05 60 0d 00 00       	add    $0xd60,%eax
}
 21e:	c9                   	leave  
 21f:	c3                   	ret    

00000220 <get_text_point>:

void* get_text_point(char c){
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	83 ec 14             	sub    $0x14,%esp
 226:	8b 45 08             	mov    0x8(%ebp),%eax
 229:	88 45 ec             	mov    %al,-0x14(%ebp)
    int num = c;
 22c:	0f be 45 ec          	movsbl -0x14(%ebp),%eax
 230:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return char_to_point[num];
 233:	8b 45 fc             	mov    -0x4(%ebp),%eax
 236:	c1 e0 09             	shl    $0x9,%eax
 239:	05 60 0d 02 00       	add    $0x20d60,%eax
}
 23e:	c9                   	leave  
 23f:	c3                   	ret    

00000240 <main>:

int main() {
 240:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 244:	83 e4 f0             	and    $0xfffffff0,%esp
 247:	ff 71 fc             	pushl  -0x4(%ecx)
 24a:	55                   	push   %ebp
 24b:	89 e5                	mov    %esp,%ebp
 24d:	51                   	push   %ecx
 24e:	83 ec 04             	sub    $0x4,%esp
    char_point_init();
 251:	e8 aa fd ff ff       	call   0 <char_point_init>
    drawrect(0,0,800,600,65535);
 256:	83 ec 0c             	sub    $0xc,%esp
 259:	68 ff ff 00 00       	push   $0xffff
 25e:	68 58 02 00 00       	push   $0x258
 263:	68 20 03 00 00       	push   $0x320
 268:	6a 00                	push   $0x0
 26a:	6a 00                	push   $0x0
 26c:	e8 1d 03 00 00       	call   58e <drawrect>
 271:	83 c4 20             	add    $0x20,%esp
    drawarea(0,0,8,16,get_text_area('a'));
 274:	83 ec 0c             	sub    $0xc,%esp
 277:	6a 61                	push   $0x61
 279:	e8 82 ff ff ff       	call   200 <get_text_area>
 27e:	83 c4 10             	add    $0x10,%esp
 281:	83 ec 0c             	sub    $0xc,%esp
 284:	50                   	push   %eax
 285:	6a 10                	push   $0x10
 287:	6a 08                	push   $0x8
 289:	6a 00                	push   $0x0
 28b:	6a 00                	push   $0x0
 28d:	e8 04 03 00 00       	call   596 <drawarea>
 292:	83 c4 20             	add    $0x20,%esp
    while(1){
        
    }
 295:	eb fe                	jmp    295 <main+0x55>

00000297 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 297:	55                   	push   %ebp
 298:	89 e5                	mov    %esp,%ebp
 29a:	57                   	push   %edi
 29b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 29c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 29f:	8b 55 10             	mov    0x10(%ebp),%edx
 2a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a5:	89 cb                	mov    %ecx,%ebx
 2a7:	89 df                	mov    %ebx,%edi
 2a9:	89 d1                	mov    %edx,%ecx
 2ab:	fc                   	cld    
 2ac:	f3 aa                	rep stos %al,%es:(%edi)
 2ae:	89 ca                	mov    %ecx,%edx
 2b0:	89 fb                	mov    %edi,%ebx
 2b2:	89 5d 08             	mov    %ebx,0x8(%ebp)
 2b5:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 2b8:	90                   	nop
 2b9:	5b                   	pop    %ebx
 2ba:	5f                   	pop    %edi
 2bb:	5d                   	pop    %ebp
 2bc:	c3                   	ret    

000002bd <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2bd:	55                   	push   %ebp
 2be:	89 e5                	mov    %esp,%ebp
 2c0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
 2c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 2c9:	90                   	nop
 2ca:	8b 45 08             	mov    0x8(%ebp),%eax
 2cd:	8d 50 01             	lea    0x1(%eax),%edx
 2d0:	89 55 08             	mov    %edx,0x8(%ebp)
 2d3:	8b 55 0c             	mov    0xc(%ebp),%edx
 2d6:	8d 4a 01             	lea    0x1(%edx),%ecx
 2d9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 2dc:	0f b6 12             	movzbl (%edx),%edx
 2df:	88 10                	mov    %dl,(%eax)
 2e1:	0f b6 00             	movzbl (%eax),%eax
 2e4:	84 c0                	test   %al,%al
 2e6:	75 e2                	jne    2ca <strcpy+0xd>
    ;
  return os;
 2e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2eb:	c9                   	leave  
 2ec:	c3                   	ret    

000002ed <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ed:	55                   	push   %ebp
 2ee:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2f0:	eb 08                	jmp    2fa <strcmp+0xd>
    p++, q++;
 2f2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2f6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2fa:	8b 45 08             	mov    0x8(%ebp),%eax
 2fd:	0f b6 00             	movzbl (%eax),%eax
 300:	84 c0                	test   %al,%al
 302:	74 10                	je     314 <strcmp+0x27>
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	0f b6 10             	movzbl (%eax),%edx
 30a:	8b 45 0c             	mov    0xc(%ebp),%eax
 30d:	0f b6 00             	movzbl (%eax),%eax
 310:	38 c2                	cmp    %al,%dl
 312:	74 de                	je     2f2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 314:	8b 45 08             	mov    0x8(%ebp),%eax
 317:	0f b6 00             	movzbl (%eax),%eax
 31a:	0f b6 d0             	movzbl %al,%edx
 31d:	8b 45 0c             	mov    0xc(%ebp),%eax
 320:	0f b6 00             	movzbl (%eax),%eax
 323:	0f b6 c0             	movzbl %al,%eax
 326:	29 c2                	sub    %eax,%edx
 328:	89 d0                	mov    %edx,%eax
}
 32a:	5d                   	pop    %ebp
 32b:	c3                   	ret    

0000032c <strlen>:

uint
strlen(char *s)
{
 32c:	55                   	push   %ebp
 32d:	89 e5                	mov    %esp,%ebp
 32f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 332:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 339:	eb 04                	jmp    33f <strlen+0x13>
 33b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 33f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 342:	8b 45 08             	mov    0x8(%ebp),%eax
 345:	01 d0                	add    %edx,%eax
 347:	0f b6 00             	movzbl (%eax),%eax
 34a:	84 c0                	test   %al,%al
 34c:	75 ed                	jne    33b <strlen+0xf>
    ;
  return n;
 34e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 351:	c9                   	leave  
 352:	c3                   	ret    

00000353 <memset>:

void*
memset(void *dst, int c, uint n)
{
 353:	55                   	push   %ebp
 354:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 356:	8b 45 10             	mov    0x10(%ebp),%eax
 359:	50                   	push   %eax
 35a:	ff 75 0c             	pushl  0xc(%ebp)
 35d:	ff 75 08             	pushl  0x8(%ebp)
 360:	e8 32 ff ff ff       	call   297 <stosb>
 365:	83 c4 0c             	add    $0xc,%esp
  return dst;
 368:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36b:	c9                   	leave  
 36c:	c3                   	ret    

0000036d <strchr>:

char*
strchr(const char *s, char c)
{
 36d:	55                   	push   %ebp
 36e:	89 e5                	mov    %esp,%ebp
 370:	83 ec 04             	sub    $0x4,%esp
 373:	8b 45 0c             	mov    0xc(%ebp),%eax
 376:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 379:	eb 14                	jmp    38f <strchr+0x22>
    if(*s == c)
 37b:	8b 45 08             	mov    0x8(%ebp),%eax
 37e:	0f b6 00             	movzbl (%eax),%eax
 381:	3a 45 fc             	cmp    -0x4(%ebp),%al
 384:	75 05                	jne    38b <strchr+0x1e>
      return (char*)s;
 386:	8b 45 08             	mov    0x8(%ebp),%eax
 389:	eb 13                	jmp    39e <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 38b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 38f:	8b 45 08             	mov    0x8(%ebp),%eax
 392:	0f b6 00             	movzbl (%eax),%eax
 395:	84 c0                	test   %al,%al
 397:	75 e2                	jne    37b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 399:	b8 00 00 00 00       	mov    $0x0,%eax
}
 39e:	c9                   	leave  
 39f:	c3                   	ret    

000003a0 <gets>:

char*
gets(char *buf, int max)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 3ad:	eb 42                	jmp    3f1 <gets+0x51>
    cc = read(0, &c, 1);
 3af:	83 ec 04             	sub    $0x4,%esp
 3b2:	6a 01                	push   $0x1
 3b4:	8d 45 ef             	lea    -0x11(%ebp),%eax
 3b7:	50                   	push   %eax
 3b8:	6a 00                	push   $0x0
 3ba:	e8 47 01 00 00       	call   506 <read>
 3bf:	83 c4 10             	add    $0x10,%esp
 3c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3c9:	7e 33                	jle    3fe <gets+0x5e>
      break;
    buf[i++] = c;
 3cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ce:	8d 50 01             	lea    0x1(%eax),%edx
 3d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3d4:	89 c2                	mov    %eax,%edx
 3d6:	8b 45 08             	mov    0x8(%ebp),%eax
 3d9:	01 c2                	add    %eax,%edx
 3db:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3df:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3e1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3e5:	3c 0a                	cmp    $0xa,%al
 3e7:	74 16                	je     3ff <gets+0x5f>
 3e9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3ed:	3c 0d                	cmp    $0xd,%al
 3ef:	74 0e                	je     3ff <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f4:	83 c0 01             	add    $0x1,%eax
 3f7:	3b 45 0c             	cmp    0xc(%ebp),%eax
 3fa:	7c b3                	jl     3af <gets+0xf>
 3fc:	eb 01                	jmp    3ff <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 3fe:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
 402:	8b 45 08             	mov    0x8(%ebp),%eax
 405:	01 d0                	add    %edx,%eax
 407:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 40a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40d:	c9                   	leave  
 40e:	c3                   	ret    

0000040f <stat>:

int
stat(char *n, struct stat *st)
{
 40f:	55                   	push   %ebp
 410:	89 e5                	mov    %esp,%ebp
 412:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 415:	83 ec 08             	sub    $0x8,%esp
 418:	6a 00                	push   $0x0
 41a:	ff 75 08             	pushl  0x8(%ebp)
 41d:	e8 0c 01 00 00       	call   52e <open>
 422:	83 c4 10             	add    $0x10,%esp
 425:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 428:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 42c:	79 07                	jns    435 <stat+0x26>
    return -1;
 42e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 433:	eb 25                	jmp    45a <stat+0x4b>
  r = fstat(fd, st);
 435:	83 ec 08             	sub    $0x8,%esp
 438:	ff 75 0c             	pushl  0xc(%ebp)
 43b:	ff 75 f4             	pushl  -0xc(%ebp)
 43e:	e8 03 01 00 00       	call   546 <fstat>
 443:	83 c4 10             	add    $0x10,%esp
 446:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 449:	83 ec 0c             	sub    $0xc,%esp
 44c:	ff 75 f4             	pushl  -0xc(%ebp)
 44f:	e8 c2 00 00 00       	call   516 <close>
 454:	83 c4 10             	add    $0x10,%esp
  return r;
 457:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 45a:	c9                   	leave  
 45b:	c3                   	ret    

0000045c <atoi>:

int
atoi(const char *s)
{
 45c:	55                   	push   %ebp
 45d:	89 e5                	mov    %esp,%ebp
 45f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 462:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 469:	eb 25                	jmp    490 <atoi+0x34>
    n = n*10 + *s++ - '0';
 46b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 46e:	89 d0                	mov    %edx,%eax
 470:	c1 e0 02             	shl    $0x2,%eax
 473:	01 d0                	add    %edx,%eax
 475:	01 c0                	add    %eax,%eax
 477:	89 c1                	mov    %eax,%ecx
 479:	8b 45 08             	mov    0x8(%ebp),%eax
 47c:	8d 50 01             	lea    0x1(%eax),%edx
 47f:	89 55 08             	mov    %edx,0x8(%ebp)
 482:	0f b6 00             	movzbl (%eax),%eax
 485:	0f be c0             	movsbl %al,%eax
 488:	01 c8                	add    %ecx,%eax
 48a:	83 e8 30             	sub    $0x30,%eax
 48d:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 490:	8b 45 08             	mov    0x8(%ebp),%eax
 493:	0f b6 00             	movzbl (%eax),%eax
 496:	3c 2f                	cmp    $0x2f,%al
 498:	7e 0a                	jle    4a4 <atoi+0x48>
 49a:	8b 45 08             	mov    0x8(%ebp),%eax
 49d:	0f b6 00             	movzbl (%eax),%eax
 4a0:	3c 39                	cmp    $0x39,%al
 4a2:	7e c7                	jle    46b <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 4a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4a7:	c9                   	leave  
 4a8:	c3                   	ret    

000004a9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4a9:	55                   	push   %ebp
 4aa:	89 e5                	mov    %esp,%ebp
 4ac:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4af:	8b 45 08             	mov    0x8(%ebp),%eax
 4b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4bb:	eb 17                	jmp    4d4 <memmove+0x2b>
    *dst++ = *src++;
 4bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4c0:	8d 50 01             	lea    0x1(%eax),%edx
 4c3:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4c6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4c9:	8d 4a 01             	lea    0x1(%edx),%ecx
 4cc:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4cf:	0f b6 12             	movzbl (%edx),%edx
 4d2:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4d4:	8b 45 10             	mov    0x10(%ebp),%eax
 4d7:	8d 50 ff             	lea    -0x1(%eax),%edx
 4da:	89 55 10             	mov    %edx,0x10(%ebp)
 4dd:	85 c0                	test   %eax,%eax
 4df:	7f dc                	jg     4bd <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4e4:	c9                   	leave  
 4e5:	c3                   	ret    

000004e6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4e6:	b8 01 00 00 00       	mov    $0x1,%eax
 4eb:	cd 40                	int    $0x40
 4ed:	c3                   	ret    

000004ee <exit>:
SYSCALL(exit)
 4ee:	b8 02 00 00 00       	mov    $0x2,%eax
 4f3:	cd 40                	int    $0x40
 4f5:	c3                   	ret    

000004f6 <wait>:
SYSCALL(wait)
 4f6:	b8 03 00 00 00       	mov    $0x3,%eax
 4fb:	cd 40                	int    $0x40
 4fd:	c3                   	ret    

000004fe <pipe>:
SYSCALL(pipe)
 4fe:	b8 04 00 00 00       	mov    $0x4,%eax
 503:	cd 40                	int    $0x40
 505:	c3                   	ret    

00000506 <read>:
SYSCALL(read)
 506:	b8 05 00 00 00       	mov    $0x5,%eax
 50b:	cd 40                	int    $0x40
 50d:	c3                   	ret    

0000050e <write>:
SYSCALL(write)
 50e:	b8 10 00 00 00       	mov    $0x10,%eax
 513:	cd 40                	int    $0x40
 515:	c3                   	ret    

00000516 <close>:
SYSCALL(close)
 516:	b8 15 00 00 00       	mov    $0x15,%eax
 51b:	cd 40                	int    $0x40
 51d:	c3                   	ret    

0000051e <kill>:
SYSCALL(kill)
 51e:	b8 06 00 00 00       	mov    $0x6,%eax
 523:	cd 40                	int    $0x40
 525:	c3                   	ret    

00000526 <exec>:
SYSCALL(exec)
 526:	b8 07 00 00 00       	mov    $0x7,%eax
 52b:	cd 40                	int    $0x40
 52d:	c3                   	ret    

0000052e <open>:
SYSCALL(open)
 52e:	b8 0f 00 00 00       	mov    $0xf,%eax
 533:	cd 40                	int    $0x40
 535:	c3                   	ret    

00000536 <mknod>:
SYSCALL(mknod)
 536:	b8 11 00 00 00       	mov    $0x11,%eax
 53b:	cd 40                	int    $0x40
 53d:	c3                   	ret    

0000053e <unlink>:
SYSCALL(unlink)
 53e:	b8 12 00 00 00       	mov    $0x12,%eax
 543:	cd 40                	int    $0x40
 545:	c3                   	ret    

00000546 <fstat>:
SYSCALL(fstat)
 546:	b8 08 00 00 00       	mov    $0x8,%eax
 54b:	cd 40                	int    $0x40
 54d:	c3                   	ret    

0000054e <link>:
SYSCALL(link)
 54e:	b8 13 00 00 00       	mov    $0x13,%eax
 553:	cd 40                	int    $0x40
 555:	c3                   	ret    

00000556 <mkdir>:
SYSCALL(mkdir)
 556:	b8 14 00 00 00       	mov    $0x14,%eax
 55b:	cd 40                	int    $0x40
 55d:	c3                   	ret    

0000055e <chdir>:
SYSCALL(chdir)
 55e:	b8 09 00 00 00       	mov    $0x9,%eax
 563:	cd 40                	int    $0x40
 565:	c3                   	ret    

00000566 <dup>:
SYSCALL(dup)
 566:	b8 0a 00 00 00       	mov    $0xa,%eax
 56b:	cd 40                	int    $0x40
 56d:	c3                   	ret    

0000056e <getpid>:
SYSCALL(getpid)
 56e:	b8 0b 00 00 00       	mov    $0xb,%eax
 573:	cd 40                	int    $0x40
 575:	c3                   	ret    

00000576 <sbrk>:
SYSCALL(sbrk)
 576:	b8 0c 00 00 00       	mov    $0xc,%eax
 57b:	cd 40                	int    $0x40
 57d:	c3                   	ret    

0000057e <sleep>:
SYSCALL(sleep)
 57e:	b8 0d 00 00 00       	mov    $0xd,%eax
 583:	cd 40                	int    $0x40
 585:	c3                   	ret    

00000586 <uptime>:
SYSCALL(uptime)
 586:	b8 0e 00 00 00       	mov    $0xe,%eax
 58b:	cd 40                	int    $0x40
 58d:	c3                   	ret    

0000058e <drawrect>:
SYSCALL(drawrect)
 58e:	b8 16 00 00 00       	mov    $0x16,%eax
 593:	cd 40                	int    $0x40
 595:	c3                   	ret    

00000596 <drawarea>:
SYSCALL(drawarea)
 596:	b8 17 00 00 00       	mov    $0x17,%eax
 59b:	cd 40                	int    $0x40
 59d:	c3                   	ret    

0000059e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 59e:	55                   	push   %ebp
 59f:	89 e5                	mov    %esp,%ebp
 5a1:	83 ec 18             	sub    $0x18,%esp
 5a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a7:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5aa:	83 ec 04             	sub    $0x4,%esp
 5ad:	6a 01                	push   $0x1
 5af:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5b2:	50                   	push   %eax
 5b3:	ff 75 08             	pushl  0x8(%ebp)
 5b6:	e8 53 ff ff ff       	call   50e <write>
 5bb:	83 c4 10             	add    $0x10,%esp
}
 5be:	90                   	nop
 5bf:	c9                   	leave  
 5c0:	c3                   	ret    

000005c1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5c1:	55                   	push   %ebp
 5c2:	89 e5                	mov    %esp,%ebp
 5c4:	53                   	push   %ebx
 5c5:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5cf:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5d3:	74 17                	je     5ec <printint+0x2b>
 5d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5d9:	79 11                	jns    5ec <printint+0x2b>
    neg = 1;
 5db:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e5:	f7 d8                	neg    %eax
 5e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5ea:	eb 06                	jmp    5f2 <printint+0x31>
  } else {
    x = xx;
 5ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5f9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5fc:	8d 41 01             	lea    0x1(%ecx),%eax
 5ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
 602:	8b 5d 10             	mov    0x10(%ebp),%ebx
 605:	8b 45 ec             	mov    -0x14(%ebp),%eax
 608:	ba 00 00 00 00       	mov    $0x0,%edx
 60d:	f7 f3                	div    %ebx
 60f:	89 d0                	mov    %edx,%eax
 611:	0f b6 80 28 0d 00 00 	movzbl 0xd28(%eax),%eax
 618:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 61c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 61f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 622:	ba 00 00 00 00       	mov    $0x0,%edx
 627:	f7 f3                	div    %ebx
 629:	89 45 ec             	mov    %eax,-0x14(%ebp)
 62c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 630:	75 c7                	jne    5f9 <printint+0x38>
  if(neg)
 632:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 636:	74 2d                	je     665 <printint+0xa4>
    buf[i++] = '-';
 638:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63b:	8d 50 01             	lea    0x1(%eax),%edx
 63e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 641:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 646:	eb 1d                	jmp    665 <printint+0xa4>
    putc(fd, buf[i]);
 648:	8d 55 dc             	lea    -0x24(%ebp),%edx
 64b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 64e:	01 d0                	add    %edx,%eax
 650:	0f b6 00             	movzbl (%eax),%eax
 653:	0f be c0             	movsbl %al,%eax
 656:	83 ec 08             	sub    $0x8,%esp
 659:	50                   	push   %eax
 65a:	ff 75 08             	pushl  0x8(%ebp)
 65d:	e8 3c ff ff ff       	call   59e <putc>
 662:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 665:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 669:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 66d:	79 d9                	jns    648 <printint+0x87>
    putc(fd, buf[i]);
}
 66f:	90                   	nop
 670:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 673:	c9                   	leave  
 674:	c3                   	ret    

00000675 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 675:	55                   	push   %ebp
 676:	89 e5                	mov    %esp,%ebp
 678:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 67b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 682:	8d 45 0c             	lea    0xc(%ebp),%eax
 685:	83 c0 04             	add    $0x4,%eax
 688:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 68b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 692:	e9 59 01 00 00       	jmp    7f0 <printf+0x17b>
    c = fmt[i] & 0xff;
 697:	8b 55 0c             	mov    0xc(%ebp),%edx
 69a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 69d:	01 d0                	add    %edx,%eax
 69f:	0f b6 00             	movzbl (%eax),%eax
 6a2:	0f be c0             	movsbl %al,%eax
 6a5:	25 ff 00 00 00       	and    $0xff,%eax
 6aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6b1:	75 2c                	jne    6df <printf+0x6a>
      if(c == '%'){
 6b3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6b7:	75 0c                	jne    6c5 <printf+0x50>
        state = '%';
 6b9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6c0:	e9 27 01 00 00       	jmp    7ec <printf+0x177>
      } else {
        putc(fd, c);
 6c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c8:	0f be c0             	movsbl %al,%eax
 6cb:	83 ec 08             	sub    $0x8,%esp
 6ce:	50                   	push   %eax
 6cf:	ff 75 08             	pushl  0x8(%ebp)
 6d2:	e8 c7 fe ff ff       	call   59e <putc>
 6d7:	83 c4 10             	add    $0x10,%esp
 6da:	e9 0d 01 00 00       	jmp    7ec <printf+0x177>
      }
    } else if(state == '%'){
 6df:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6e3:	0f 85 03 01 00 00    	jne    7ec <printf+0x177>
      if(c == 'd'){
 6e9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6ed:	75 1e                	jne    70d <printf+0x98>
        printint(fd, *ap, 10, 1);
 6ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6f2:	8b 00                	mov    (%eax),%eax
 6f4:	6a 01                	push   $0x1
 6f6:	6a 0a                	push   $0xa
 6f8:	50                   	push   %eax
 6f9:	ff 75 08             	pushl  0x8(%ebp)
 6fc:	e8 c0 fe ff ff       	call   5c1 <printint>
 701:	83 c4 10             	add    $0x10,%esp
        ap++;
 704:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 708:	e9 d8 00 00 00       	jmp    7e5 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 70d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 711:	74 06                	je     719 <printf+0xa4>
 713:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 717:	75 1e                	jne    737 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 719:	8b 45 e8             	mov    -0x18(%ebp),%eax
 71c:	8b 00                	mov    (%eax),%eax
 71e:	6a 00                	push   $0x0
 720:	6a 10                	push   $0x10
 722:	50                   	push   %eax
 723:	ff 75 08             	pushl  0x8(%ebp)
 726:	e8 96 fe ff ff       	call   5c1 <printint>
 72b:	83 c4 10             	add    $0x10,%esp
        ap++;
 72e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 732:	e9 ae 00 00 00       	jmp    7e5 <printf+0x170>
      } else if(c == 's'){
 737:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 73b:	75 43                	jne    780 <printf+0x10b>
        s = (char*)*ap;
 73d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 740:	8b 00                	mov    (%eax),%eax
 742:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 745:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 749:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 74d:	75 25                	jne    774 <printf+0xff>
          s = "(null)";
 74f:	c7 45 f4 78 0a 00 00 	movl   $0xa78,-0xc(%ebp)
        while(*s != 0){
 756:	eb 1c                	jmp    774 <printf+0xff>
          putc(fd, *s);
 758:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75b:	0f b6 00             	movzbl (%eax),%eax
 75e:	0f be c0             	movsbl %al,%eax
 761:	83 ec 08             	sub    $0x8,%esp
 764:	50                   	push   %eax
 765:	ff 75 08             	pushl  0x8(%ebp)
 768:	e8 31 fe ff ff       	call   59e <putc>
 76d:	83 c4 10             	add    $0x10,%esp
          s++;
 770:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 774:	8b 45 f4             	mov    -0xc(%ebp),%eax
 777:	0f b6 00             	movzbl (%eax),%eax
 77a:	84 c0                	test   %al,%al
 77c:	75 da                	jne    758 <printf+0xe3>
 77e:	eb 65                	jmp    7e5 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 780:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 784:	75 1d                	jne    7a3 <printf+0x12e>
        putc(fd, *ap);
 786:	8b 45 e8             	mov    -0x18(%ebp),%eax
 789:	8b 00                	mov    (%eax),%eax
 78b:	0f be c0             	movsbl %al,%eax
 78e:	83 ec 08             	sub    $0x8,%esp
 791:	50                   	push   %eax
 792:	ff 75 08             	pushl  0x8(%ebp)
 795:	e8 04 fe ff ff       	call   59e <putc>
 79a:	83 c4 10             	add    $0x10,%esp
        ap++;
 79d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7a1:	eb 42                	jmp    7e5 <printf+0x170>
      } else if(c == '%'){
 7a3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7a7:	75 17                	jne    7c0 <printf+0x14b>
        putc(fd, c);
 7a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7ac:	0f be c0             	movsbl %al,%eax
 7af:	83 ec 08             	sub    $0x8,%esp
 7b2:	50                   	push   %eax
 7b3:	ff 75 08             	pushl  0x8(%ebp)
 7b6:	e8 e3 fd ff ff       	call   59e <putc>
 7bb:	83 c4 10             	add    $0x10,%esp
 7be:	eb 25                	jmp    7e5 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7c0:	83 ec 08             	sub    $0x8,%esp
 7c3:	6a 25                	push   $0x25
 7c5:	ff 75 08             	pushl  0x8(%ebp)
 7c8:	e8 d1 fd ff ff       	call   59e <putc>
 7cd:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 7d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7d3:	0f be c0             	movsbl %al,%eax
 7d6:	83 ec 08             	sub    $0x8,%esp
 7d9:	50                   	push   %eax
 7da:	ff 75 08             	pushl  0x8(%ebp)
 7dd:	e8 bc fd ff ff       	call   59e <putc>
 7e2:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7ec:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7f0:	8b 55 0c             	mov    0xc(%ebp),%edx
 7f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f6:	01 d0                	add    %edx,%eax
 7f8:	0f b6 00             	movzbl (%eax),%eax
 7fb:	84 c0                	test   %al,%al
 7fd:	0f 85 94 fe ff ff    	jne    697 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 803:	90                   	nop
 804:	c9                   	leave  
 805:	c3                   	ret    

00000806 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 806:	55                   	push   %ebp
 807:	89 e5                	mov    %esp,%ebp
 809:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 80c:	8b 45 08             	mov    0x8(%ebp),%eax
 80f:	83 e8 08             	sub    $0x8,%eax
 812:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 815:	a1 48 0d 00 00       	mov    0xd48,%eax
 81a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 81d:	eb 24                	jmp    843 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 822:	8b 00                	mov    (%eax),%eax
 824:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 827:	77 12                	ja     83b <free+0x35>
 829:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 82f:	77 24                	ja     855 <free+0x4f>
 831:	8b 45 fc             	mov    -0x4(%ebp),%eax
 834:	8b 00                	mov    (%eax),%eax
 836:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 839:	77 1a                	ja     855 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 83b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83e:	8b 00                	mov    (%eax),%eax
 840:	89 45 fc             	mov    %eax,-0x4(%ebp)
 843:	8b 45 f8             	mov    -0x8(%ebp),%eax
 846:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 849:	76 d4                	jbe    81f <free+0x19>
 84b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84e:	8b 00                	mov    (%eax),%eax
 850:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 853:	76 ca                	jbe    81f <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 855:	8b 45 f8             	mov    -0x8(%ebp),%eax
 858:	8b 40 04             	mov    0x4(%eax),%eax
 85b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 862:	8b 45 f8             	mov    -0x8(%ebp),%eax
 865:	01 c2                	add    %eax,%edx
 867:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86a:	8b 00                	mov    (%eax),%eax
 86c:	39 c2                	cmp    %eax,%edx
 86e:	75 24                	jne    894 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 870:	8b 45 f8             	mov    -0x8(%ebp),%eax
 873:	8b 50 04             	mov    0x4(%eax),%edx
 876:	8b 45 fc             	mov    -0x4(%ebp),%eax
 879:	8b 00                	mov    (%eax),%eax
 87b:	8b 40 04             	mov    0x4(%eax),%eax
 87e:	01 c2                	add    %eax,%edx
 880:	8b 45 f8             	mov    -0x8(%ebp),%eax
 883:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 886:	8b 45 fc             	mov    -0x4(%ebp),%eax
 889:	8b 00                	mov    (%eax),%eax
 88b:	8b 10                	mov    (%eax),%edx
 88d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 890:	89 10                	mov    %edx,(%eax)
 892:	eb 0a                	jmp    89e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 894:	8b 45 fc             	mov    -0x4(%ebp),%eax
 897:	8b 10                	mov    (%eax),%edx
 899:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 89e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a1:	8b 40 04             	mov    0x4(%eax),%eax
 8a4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ae:	01 d0                	add    %edx,%eax
 8b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8b3:	75 20                	jne    8d5 <free+0xcf>
    p->s.size += bp->s.size;
 8b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b8:	8b 50 04             	mov    0x4(%eax),%edx
 8bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8be:	8b 40 04             	mov    0x4(%eax),%eax
 8c1:	01 c2                	add    %eax,%edx
 8c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cc:	8b 10                	mov    (%eax),%edx
 8ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d1:	89 10                	mov    %edx,(%eax)
 8d3:	eb 08                	jmp    8dd <free+0xd7>
  } else
    p->s.ptr = bp;
 8d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8db:	89 10                	mov    %edx,(%eax)
  freep = p;
 8dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e0:	a3 48 0d 00 00       	mov    %eax,0xd48
}
 8e5:	90                   	nop
 8e6:	c9                   	leave  
 8e7:	c3                   	ret    

000008e8 <morecore>:

static Header*
morecore(uint nu)
{
 8e8:	55                   	push   %ebp
 8e9:	89 e5                	mov    %esp,%ebp
 8eb:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8ee:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8f5:	77 07                	ja     8fe <morecore+0x16>
    nu = 4096;
 8f7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8fe:	8b 45 08             	mov    0x8(%ebp),%eax
 901:	c1 e0 03             	shl    $0x3,%eax
 904:	83 ec 0c             	sub    $0xc,%esp
 907:	50                   	push   %eax
 908:	e8 69 fc ff ff       	call   576 <sbrk>
 90d:	83 c4 10             	add    $0x10,%esp
 910:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 913:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 917:	75 07                	jne    920 <morecore+0x38>
    return 0;
 919:	b8 00 00 00 00       	mov    $0x0,%eax
 91e:	eb 26                	jmp    946 <morecore+0x5e>
  hp = (Header*)p;
 920:	8b 45 f4             	mov    -0xc(%ebp),%eax
 923:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 926:	8b 45 f0             	mov    -0x10(%ebp),%eax
 929:	8b 55 08             	mov    0x8(%ebp),%edx
 92c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 92f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 932:	83 c0 08             	add    $0x8,%eax
 935:	83 ec 0c             	sub    $0xc,%esp
 938:	50                   	push   %eax
 939:	e8 c8 fe ff ff       	call   806 <free>
 93e:	83 c4 10             	add    $0x10,%esp
  return freep;
 941:	a1 48 0d 00 00       	mov    0xd48,%eax
}
 946:	c9                   	leave  
 947:	c3                   	ret    

00000948 <malloc>:

void*
malloc(uint nbytes)
{
 948:	55                   	push   %ebp
 949:	89 e5                	mov    %esp,%ebp
 94b:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 94e:	8b 45 08             	mov    0x8(%ebp),%eax
 951:	83 c0 07             	add    $0x7,%eax
 954:	c1 e8 03             	shr    $0x3,%eax
 957:	83 c0 01             	add    $0x1,%eax
 95a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 95d:	a1 48 0d 00 00       	mov    0xd48,%eax
 962:	89 45 f0             	mov    %eax,-0x10(%ebp)
 965:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 969:	75 23                	jne    98e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 96b:	c7 45 f0 40 0d 00 00 	movl   $0xd40,-0x10(%ebp)
 972:	8b 45 f0             	mov    -0x10(%ebp),%eax
 975:	a3 48 0d 00 00       	mov    %eax,0xd48
 97a:	a1 48 0d 00 00       	mov    0xd48,%eax
 97f:	a3 40 0d 00 00       	mov    %eax,0xd40
    base.s.size = 0;
 984:	c7 05 44 0d 00 00 00 	movl   $0x0,0xd44
 98b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 991:	8b 00                	mov    (%eax),%eax
 993:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 996:	8b 45 f4             	mov    -0xc(%ebp),%eax
 999:	8b 40 04             	mov    0x4(%eax),%eax
 99c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 99f:	72 4d                	jb     9ee <malloc+0xa6>
      if(p->s.size == nunits)
 9a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a4:	8b 40 04             	mov    0x4(%eax),%eax
 9a7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9aa:	75 0c                	jne    9b8 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9af:	8b 10                	mov    (%eax),%edx
 9b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b4:	89 10                	mov    %edx,(%eax)
 9b6:	eb 26                	jmp    9de <malloc+0x96>
      else {
        p->s.size -= nunits;
 9b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bb:	8b 40 04             	mov    0x4(%eax),%eax
 9be:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9c1:	89 c2                	mov    %eax,%edx
 9c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cc:	8b 40 04             	mov    0x4(%eax),%eax
 9cf:	c1 e0 03             	shl    $0x3,%eax
 9d2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9db:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e1:	a3 48 0d 00 00       	mov    %eax,0xd48
      return (void*)(p + 1);
 9e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e9:	83 c0 08             	add    $0x8,%eax
 9ec:	eb 3b                	jmp    a29 <malloc+0xe1>
    }
    if(p == freep)
 9ee:	a1 48 0d 00 00       	mov    0xd48,%eax
 9f3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9f6:	75 1e                	jne    a16 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9f8:	83 ec 0c             	sub    $0xc,%esp
 9fb:	ff 75 ec             	pushl  -0x14(%ebp)
 9fe:	e8 e5 fe ff ff       	call   8e8 <morecore>
 a03:	83 c4 10             	add    $0x10,%esp
 a06:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a0d:	75 07                	jne    a16 <malloc+0xce>
        return 0;
 a0f:	b8 00 00 00 00       	mov    $0x0,%eax
 a14:	eb 13                	jmp    a29 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a19:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1f:	8b 00                	mov    (%eax),%eax
 a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a24:	e9 6d ff ff ff       	jmp    996 <malloc+0x4e>
}
 a29:	c9                   	leave  
 a2a:	c3                   	ret    
