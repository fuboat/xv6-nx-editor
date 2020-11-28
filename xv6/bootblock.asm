
bootblock.o：     文件格式 elf32-i386


Disassembly of section .text:

00007c00 <start>:
# with %cs=0 %ip=7c00.

.code16                       # Assemble for 16-bit mode
.globl start
start:
  cli                         # BIOS enabled interrupts; disable
    7c00:	fa                   	cli    

  # Zero data segment registers DS, ES, and SS.
  xorw    %ax,%ax             # Set %ax to zero
    7c01:	31 c0                	xor    %eax,%eax
  movw    %ax,%ds             # -> Data Segment
    7c03:	8e d8                	mov    %eax,%ds
  movw    %ax,%es             # -> Extra Segment
    7c05:	8e c0                	mov    %eax,%es
  movw    %ax,%ss             # -> Stack Segment
    7c07:	8e d0                	mov    %eax,%ss

00007c09 <seta20.1>:

  # Physical address line A20 is tied to zero so that the first PCs 
  # with 2 MB would run software that assumed 1 MB.  Undo that.
seta20.1:
  inb     $0x64,%al               # Wait for not busy
    7c09:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c0b:	a8 02                	test   $0x2,%al
  jnz     seta20.1
    7c0d:	75 fa                	jne    7c09 <seta20.1>

  movb    $0xd1,%al               # 0xd1 -> port 0x64
    7c0f:	b0 d1                	mov    $0xd1,%al
  outb    %al,$0x64
    7c11:	e6 64                	out    %al,$0x64

00007c13 <seta20.2>:

seta20.2:
  inb     $0x64,%al               # Wait for not busy
    7c13:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c15:	a8 02                	test   $0x2,%al
  jnz     seta20.2
    7c17:	75 fa                	jne    7c13 <seta20.2>

  movb    $0xdf,%al               # 0xdf -> port 0x60
    7c19:	b0 df                	mov    $0xdf,%al
  outb    %al,$0x60
    7c1b:	e6 60                	out    %al,$0x60

  # Get VESA mode
  movw    $0x1000, %di            # %di: the address to save VESA mode info
    7c1d:	bf 00 10 b8 01       	mov    $0x1b81000,%edi
  movw    $0x4f01, %ax            # %ax: 0x4f01 is to get VESA mode info
    7c22:	4f                   	dec    %edi
  movw    $0x4114, %cx            # %cx: 0x4114 mean 800*600(5:6:5) mode
    7c23:	b9 14 41 cd 10       	mov    $0x10cd4114,%ecx
  int     $0x10

  # Set VESA mode
  movw    $0x4f02, %ax            # %ax: 0x4f02 is to set VESA mode info
    7c28:	b8 02 4f bb 14       	mov    $0x14bb4f02,%eax
  movw    $0x4114, %bx            # %bx: 0x4114 mean 800*600(5:6:5) mode
    7c2d:	41                   	inc    %ecx
  int     $0x10
    7c2e:	cd 10                	int    $0x10

  # Switch from real to protected mode.  Use a bootstrap GDT that makes
  # virtual addresses map directly to physical addresses so that the
  # effective memory map doesn't change during the transition.
  lgdt    gdtdesc
    7c30:	0f 01 16             	lgdtl  (%esi)
    7c33:	8c 7c 0f 20          	mov    %?,0x20(%edi,%ecx,1)
  movl    %cr0, %eax
    7c37:	c0 66 83 c8          	shlb   $0xc8,-0x7d(%esi)
  orl     $CR0_PE, %eax
    7c3b:	01 0f                	add    %ecx,(%edi)
  movl    %eax, %cr0
    7c3d:	22 c0                	and    %al,%al

//PAGEBREAK!
  # Complete transition to 32-bit protected mode by using long jmp
  # to reload %cs and %eip.  The segment descriptors are set up with no
  # translation, so that the mapping is still the identity mapping.
  ljmp    $(SEG_KCODE<<3), $start32
    7c3f:	ea                   	.byte 0xea
    7c40:	44                   	inc    %esp
    7c41:	7c 08                	jl     7c4b <start32+0x7>
	...

00007c44 <start32>:

.code32  # Tell assembler to generate 32-bit code now.
start32:
  # Set up the protected-mode data segment registers
  movw    $(SEG_KDATA<<3), %ax    # Our data segment selector
    7c44:	66 b8 10 00          	mov    $0x10,%ax
  movw    %ax, %ds                # -> DS: Data Segment
    7c48:	8e d8                	mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
    7c4a:	8e c0                	mov    %eax,%es
  movw    %ax, %ss                # -> SS: Stack Segment
    7c4c:	8e d0                	mov    %eax,%ss
  movw    $0, %ax                 # Zero segments not ready for use
    7c4e:	66 b8 00 00          	mov    $0x0,%ax
  movw    %ax, %fs                # -> FS
    7c52:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs                # -> GS
    7c54:	8e e8                	mov    %eax,%gs

  # Set up the stack pointer and call into C.
  movl    $start, %esp
    7c56:	bc 00 7c 00 00       	mov    $0x7c00,%esp
  call    bootmain
    7c5b:	e8 ef 00 00 00       	call   7d4f <bootmain>

  # If bootmain returns (it shouldn't), trigger a Bochs
  # breakpoint if running under Bochs, then loop.
  movw    $0x8a00, %ax            # 0x8a00 -> port 0x8a00
    7c60:	66 b8 00 8a          	mov    $0x8a00,%ax
  movw    %ax, %dx
    7c64:	66 89 c2             	mov    %ax,%dx
  outw    %ax, %dx
    7c67:	66 ef                	out    %ax,(%dx)
  movw    $0x8ae0, %ax            # 0x8ae0 -> port 0x8a00
    7c69:	66 b8 e0 8a          	mov    $0x8ae0,%ax
  outw    %ax, %dx
    7c6d:	66 ef                	out    %ax,(%dx)

00007c6f <spin>:
spin:
  jmp     spin
    7c6f:	eb fe                	jmp    7c6f <spin>
    7c71:	8d 76 00             	lea    0x0(%esi),%esi

00007c74 <gdt>:
	...
    7c7c:	ff                   	(bad)  
    7c7d:	ff 00                	incl   (%eax)
    7c7f:	00 00                	add    %al,(%eax)
    7c81:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c88:	00                   	.byte 0x0
    7c89:	92                   	xchg   %eax,%edx
    7c8a:	cf                   	iret   
	...

00007c8c <gdtdesc>:
    7c8c:	17                   	pop    %ss
    7c8d:	00 74 7c 00          	add    %dh,0x0(%esp,%edi,2)
	...

00007c92 <waitdisk>:
  entry();
}

void
waitdisk(void)
{
    7c92:	55                   	push   %ebp
    7c93:	89 e5                	mov    %esp,%ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
    7c95:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c9a:	ec                   	in     (%dx),%al
  // Wait for disk ready.
  while((inb(0x1F7) & 0xC0) != 0x40)
    7c9b:	83 e0 c0             	and    $0xffffffc0,%eax
    7c9e:	3c 40                	cmp    $0x40,%al
    7ca0:	75 f8                	jne    7c9a <waitdisk+0x8>
    ;
}
    7ca2:	5d                   	pop    %ebp
    7ca3:	c3                   	ret    

00007ca4 <readsect>:

// Read a single sector at offset into dst.
void
readsect(void *dst, uint offset)
{
    7ca4:	55                   	push   %ebp
    7ca5:	89 e5                	mov    %esp,%ebp
    7ca7:	57                   	push   %edi
    7ca8:	53                   	push   %ebx
    7ca9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  // Issue command.
  waitdisk();
    7cac:	e8 e1 ff ff ff       	call   7c92 <waitdisk>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
    7cb1:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7cb6:	b8 01 00 00 00       	mov    $0x1,%eax
    7cbb:	ee                   	out    %al,(%dx)
    7cbc:	ba f3 01 00 00       	mov    $0x1f3,%edx
    7cc1:	89 d8                	mov    %ebx,%eax
    7cc3:	ee                   	out    %al,(%dx)
    7cc4:	89 d8                	mov    %ebx,%eax
    7cc6:	c1 e8 08             	shr    $0x8,%eax
    7cc9:	ba f4 01 00 00       	mov    $0x1f4,%edx
    7cce:	ee                   	out    %al,(%dx)
    7ccf:	89 d8                	mov    %ebx,%eax
    7cd1:	c1 e8 10             	shr    $0x10,%eax
    7cd4:	ba f5 01 00 00       	mov    $0x1f5,%edx
    7cd9:	ee                   	out    %al,(%dx)
    7cda:	89 d8                	mov    %ebx,%eax
    7cdc:	c1 e8 18             	shr    $0x18,%eax
    7cdf:	83 c8 e0             	or     $0xffffffe0,%eax
    7ce2:	ba f6 01 00 00       	mov    $0x1f6,%edx
    7ce7:	ee                   	out    %al,(%dx)
    7ce8:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7ced:	b8 20 00 00 00       	mov    $0x20,%eax
    7cf2:	ee                   	out    %al,(%dx)
  outb(0x1F5, offset >> 16);
  outb(0x1F6, (offset >> 24) | 0xE0);
  outb(0x1F7, 0x20);  // cmd 0x20 - read sectors

  // Read data.
  waitdisk();
    7cf3:	e8 9a ff ff ff       	call   7c92 <waitdisk>
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
    7cf8:	8b 7d 08             	mov    0x8(%ebp),%edi
    7cfb:	b9 80 00 00 00       	mov    $0x80,%ecx
    7d00:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7d05:	fc                   	cld    
    7d06:	f3 6d                	rep insl (%dx),%es:(%edi)
  insl(0x1F0, dst, SECTSIZE/4);
}
    7d08:	5b                   	pop    %ebx
    7d09:	5f                   	pop    %edi
    7d0a:	5d                   	pop    %ebp
    7d0b:	c3                   	ret    

00007d0c <readseg>:

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked.
void
readseg(uchar* pa, uint count, uint offset)
{
    7d0c:	55                   	push   %ebp
    7d0d:	89 e5                	mov    %esp,%ebp
    7d0f:	57                   	push   %edi
    7d10:	56                   	push   %esi
    7d11:	53                   	push   %ebx
    7d12:	8b 5d 08             	mov    0x8(%ebp),%ebx
    7d15:	8b 75 10             	mov    0x10(%ebp),%esi
  uchar* epa;

  epa = pa + count;
    7d18:	89 df                	mov    %ebx,%edi
    7d1a:	03 7d 0c             	add    0xc(%ebp),%edi

  // Round down to sector boundary.
  pa -= offset % SECTSIZE;
    7d1d:	89 f0                	mov    %esi,%eax
    7d1f:	25 ff 01 00 00       	and    $0x1ff,%eax
    7d24:	29 c3                	sub    %eax,%ebx

  // Translate from bytes to sectors; kernel starts at sector 1.
  offset = (offset / SECTSIZE) + 1;
    7d26:	c1 ee 09             	shr    $0x9,%esi
    7d29:	83 c6 01             	add    $0x1,%esi

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d2c:	39 df                	cmp    %ebx,%edi
    7d2e:	76 17                	jbe    7d47 <readseg+0x3b>
    readsect(pa, offset);
    7d30:	56                   	push   %esi
    7d31:	53                   	push   %ebx
    7d32:	e8 6d ff ff ff       	call   7ca4 <readsect>
  offset = (offset / SECTSIZE) + 1;

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d37:	81 c3 00 02 00 00    	add    $0x200,%ebx
    7d3d:	83 c6 01             	add    $0x1,%esi
    7d40:	83 c4 08             	add    $0x8,%esp
    7d43:	39 df                	cmp    %ebx,%edi
    7d45:	77 e9                	ja     7d30 <readseg+0x24>
    readsect(pa, offset);
}
    7d47:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7d4a:	5b                   	pop    %ebx
    7d4b:	5e                   	pop    %esi
    7d4c:	5f                   	pop    %edi
    7d4d:	5d                   	pop    %ebp
    7d4e:	c3                   	ret    

00007d4f <bootmain>:

void readseg(uchar*, uint, uint);

void
bootmain(void)
{
    7d4f:	55                   	push   %ebp
    7d50:	89 e5                	mov    %esp,%ebp
    7d52:	57                   	push   %edi
    7d53:	56                   	push   %esi
    7d54:	53                   	push   %ebx
    7d55:	83 ec 0c             	sub    $0xc,%esp
  uchar* pa;

  elf = (struct elfhdr*)0x10000;  // scratch space

  // Read 1st page off disk
  readseg((uchar*)elf, 4096, 0);
    7d58:	6a 00                	push   $0x0
    7d5a:	68 00 10 00 00       	push   $0x1000
    7d5f:	68 00 00 01 00       	push   $0x10000
    7d64:	e8 a3 ff ff ff       	call   7d0c <readseg>

  // Is this an ELF executable?
  if(elf->magic != ELF_MAGIC)
    7d69:	83 c4 0c             	add    $0xc,%esp
    7d6c:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d73:	45 4c 46 
    7d76:	75 50                	jne    7dc8 <bootmain+0x79>
    return;  // let bootasm.S handle error

  // Load each program segment (ignores ph flags).
  ph = (struct proghdr*)((uchar*)elf + elf->phoff);
    7d78:	a1 1c 00 01 00       	mov    0x1001c,%eax
    7d7d:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
  eph = ph + elf->phnum;
    7d83:	0f b7 35 2c 00 01 00 	movzwl 0x1002c,%esi
    7d8a:	c1 e6 05             	shl    $0x5,%esi
    7d8d:	01 de                	add    %ebx,%esi
  for(; ph < eph; ph++){
    7d8f:	39 f3                	cmp    %esi,%ebx
    7d91:	73 2f                	jae    7dc2 <bootmain+0x73>
    pa = (uchar*)ph->paddr;
    7d93:	8b 7b 0c             	mov    0xc(%ebx),%edi
    readseg(pa, ph->filesz, ph->off);
    7d96:	ff 73 04             	pushl  0x4(%ebx)
    7d99:	ff 73 10             	pushl  0x10(%ebx)
    7d9c:	57                   	push   %edi
    7d9d:	e8 6a ff ff ff       	call   7d0c <readseg>
    if(ph->memsz > ph->filesz)
    7da2:	8b 4b 14             	mov    0x14(%ebx),%ecx
    7da5:	8b 43 10             	mov    0x10(%ebx),%eax
    7da8:	83 c4 0c             	add    $0xc,%esp
    7dab:	39 c1                	cmp    %eax,%ecx
    7dad:	76 0c                	jbe    7dbb <bootmain+0x6c>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    7daf:	01 c7                	add    %eax,%edi
    7db1:	29 c1                	sub    %eax,%ecx
    7db3:	b8 00 00 00 00       	mov    $0x0,%eax
    7db8:	fc                   	cld    
    7db9:	f3 aa                	rep stos %al,%es:(%edi)
    return;  // let bootasm.S handle error

  // Load each program segment (ignores ph flags).
  ph = (struct proghdr*)((uchar*)elf + elf->phoff);
  eph = ph + elf->phnum;
  for(; ph < eph; ph++){
    7dbb:	83 c3 20             	add    $0x20,%ebx
    7dbe:	39 de                	cmp    %ebx,%esi
    7dc0:	77 d1                	ja     7d93 <bootmain+0x44>
  }

  // Call the entry point from the ELF header.
  // Does not return!
  entry = (void(*)(void))(elf->entry);
  entry();
    7dc2:	ff 15 18 00 01 00    	call   *0x10018
}
    7dc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7dcb:	5b                   	pop    %ebx
    7dcc:	5e                   	pop    %esi
    7dcd:	5f                   	pop    %edi
    7dce:	5d                   	pop    %ebp
    7dcf:	c3                   	ret    
