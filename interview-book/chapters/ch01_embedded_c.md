# Chapter 1 — Embedded C Mastery

> **Part 1 of 2** — Pointers → Arrays → Strings → Structs / Unions / Bitfields → Padding & Alignment.
> Part 2 (in this same file, appended later) covers `volatile`, `const`, `static`, storage classes, typecasting, the preprocessor, and endianness.

This is the make-or-break chapter. In an embedded or avionics interview, every panel eventually returns to C fundamentals, because the language *is* the hardware interface. The questions below are the ones actually asked at screening, panel, and principal-engineer level — answer them out loud until they are reflexes.

---

## 1. Primer

### 1.1 What a pointer actually is

A pointer is a variable whose value is a memory address. On a 32-bit target (e.g. the LPC3250/ARM9 in the BEL work, or a Cortex-M autopilot board) a pointer is 4 bytes regardless of what it points to; on a 64-bit host it is 8 bytes. The *type* of a pointer does not change its size — it tells the compiler two things: how many bytes to read/write when the pointer is dereferenced, and how far to move when the pointer is incremented.

```c
int x = 42;
int *p = &x;   /* p holds the address of x        */
*p = 7;        /* dereference: write 7 into x      */
```

`&` takes an address; `*` (in an expression) dereferences. In a *declaration*, `*` is part of the type: `int *p` means "`p` is a pointer to int."

### 1.2 Pointer arithmetic is typed

`p + 1` does **not** add 1 byte. It adds `1 * sizeof(*p)` bytes. This is the single most common source of confusion and the root of many off-by-N memory bugs.

```c
int arr[4] = {10, 20, 30, 40};
int *p = arr;     /* points at arr[0]              */
p = p + 2;        /* advances 2*4 = 8 bytes on a 32-bit int */
/* *p is now 30   */
```

The difference of two pointers into the same array yields the number of *elements* between them (type `ptrdiff_t`), not bytes.

### 1.3 The hardware reason this matters

Embedded code constantly casts an integer address to a pointer to talk to a peripheral register:

```c
/* target-only: memory-mapped register access */
#define UART0_DR (*(volatile unsigned int *)0x40011004u)
UART0_DR = 'A';   /* write a byte to the UART data register */
```

If the pointer type is wrong, the access width is wrong, and a 32-bit peripheral register read as 8 bits will silently corrupt your driver. This is exactly the class of low-level peripheral-driver verification done on the BEL UART/GPIO drivers.

### 1.4 Arrays are not pointers (but they decay)

An array name is **not** a pointer. It is a block of contiguous storage. In *most* expressions the array name "decays" to a pointer to its first element — but not under `sizeof`, not under `&`, and not as a string literal initialiser. Confusing the two is a Tier-1 elimination question.

### 1.5 Structs, unions, bitfields, padding

- **struct**: members laid out in order, each at its own offset; total size is often larger than the sum of members because the compiler inserts *padding* to satisfy alignment.
- **union**: all members share the same storage; size is that of the largest member. Used for type-punning and for memory-tight register/overlay tricks.
- **bitfield**: members specified in bits, packed into words — used for register maps and protocol headers, but with implementation-defined ordering you must know before trusting one on the wire.

These five primer pages are the minimum. The depth lives in the Q&A and the Coding Gym below.

---

## 2. Q&A Bank

### Tier 1 — Screening (phone / HR-technical). Answer in 2–4 sentences.

**Q1.1 — How big is a pointer?**
It is the size of an address on the target, not the size of what it points to. On a 32-bit MCU every pointer is 4 bytes; on a 64-bit host, 8 bytes. So `sizeof(char*) == sizeof(double*)` on any given platform.

**Q1.2 — What is the difference between `*p` in a declaration and `*p` in an expression?**
In a declaration, `int *p` declares `p` as a pointer to int — the `*` binds the type. In an expression, `*p` dereferences `p` to read or write the pointed-to object. Same symbol, two roles.

**Q1.3 — What does `p++` do when `p` is an `int*`?**
It advances `p` by `sizeof(int)` bytes (4 on most targets), so it now points at the next `int`, not the next byte. Pointer arithmetic is always scaled by the pointed-to type.

**Q1.4 — What is a NULL pointer and why use it?**
`NULL` is a pointer value guaranteed not to point at any object. It is used as a sentinel — "no target yet" or "end of list" — and dereferencing it is undefined behaviour, which on an MCU usually means a fault or a read of the vector table at address 0.

**Q1.5 — Difference between an array and a pointer in one line?**
An array is a fixed block of storage; a pointer is a variable holding an address. The array name decays to a pointer in most expressions, but `sizeof` an array gives the whole block while `sizeof` a pointer gives the address size.

**Q1.6 — What terminates a C string?**
A single NUL byte, `'\0'` (value 0). Every standard string function relies on it; a buffer without it is not a string and `strlen` will run off the end.

**Q1.7 — What is `sizeof` — a function or an operator?**
An operator, evaluated at compile time (for non-VLA types). It yields `size_t`. Because it is compile-time, `sizeof(arr)/sizeof(arr[0])` gives the element count of a real array — but only where the array has not decayed to a pointer.

**Q1.8 — Why is a `struct` sometimes bigger than the sum of its members?**
Because the compiler inserts padding bytes so each member sits at a properly aligned address, and pads the tail so arrays of the struct stay aligned. Reordering members largest-to-smallest usually shrinks the struct.

---

### Tier 2 — Core technical (panel round). Answer in a short paragraph.

**Q2.1 — Explain pointer-to-pointer and give a real use.**
A pointer-to-pointer (`int **pp`) holds the address of a pointer. The classic use is a function that must modify the caller's pointer — for example an allocator or a linked-list `push` that needs to update the caller's `head`. C passes everything by value, so to change a `Node*` in the caller you pass its address as `Node**`. Another everyday use is `argv` (`char **argv`) and ragged 2D arrays where each row is a separately allocated buffer.

**Q2.2 — Walk through `const` placement: `const char *p` vs `char *const p` vs `const char *const p`.**
Read the declaration right-to-left from the variable name. `const char *p` — "`p` is a pointer to char that is const": you can repoint `p`, but you cannot write through it (`*p = 'x'` is illegal). `char *const p` — "`p` is a const pointer to char": you can write `*p`, but you cannot repoint `p`. `const char *const p` — both fixed. In drivers, a read-only register view is often `volatile const uint32_t *`, and string-literal parameters should be `const char *` so the compiler stops you writing into read-only memory.

**Q2.3 — What is array-to-pointer decay, and where does it NOT happen?**
In nearly every expression an array name converts to a pointer to its first element — passing to a function, arithmetic, comparison. Decay does **not** happen under `sizeof` (you get the full array size), under unary `&` (`&arr` has type "pointer to array", a different type), and for a string literal used to initialise a `char[]`. The practical trap: pass an array to a function and `sizeof` inside the function gives the pointer size, so you must pass the length separately.

**Q2.4 — How do you declare and use a function pointer? Why does embedded code use them?**
`int (*fp)(int, int);` declares `fp` as a pointer to a function taking two ints and returning int; assign with `fp = &add;` (or just `add`) and call with `fp(2, 3)`. Embedded firmware uses them for jump/dispatch tables (command handlers, protocol-message parsers), for callback registration (ISR-to-application hooks), and for the interrupt vector table itself, which is an array of function pointers. They replace long `switch` ladders with O(1) dispatch and make state machines table-driven.

**Q2.5 — Explain a `union` and one legitimate embedded use.**
A union overlays all its members in the same storage, so its size equals the largest member and writing one member overwrites the others. Legitimate uses: (1) type-punning to inspect the raw bytes of a value — e.g. checking endianness or serialising a float into a telemetry packet; (2) saving RAM when several mutually-exclusive data shapes are never live at once; (3) register overlays where the same word is sometimes read as a whole and sometimes as named bitfields. The discipline is that you must track which member is currently valid yourself — the union does not.

**Q2.6 — What is structure padding and how do you control it?**
The compiler aligns each member to its natural boundary (a `uint32_t` to a 4-byte address, etc.) by inserting padding, and pads the struct tail to the largest member's alignment. You control it by ordering members largest-to-smallest to minimise gaps, or — when a struct must match a hardware register layout or a wire format exactly — by packing it (`#pragma pack` or `__attribute__((packed))`). Packing removes padding but can create unaligned members, which on some cores (older ARM) faults or is slow, so it is used deliberately, not by default.

**Q2.7 — Why must protocol/packet structs be handled carefully across machines?**
Two reasons collide: padding and endianness. A struct mapped onto a received byte buffer may have different padding than the sender assumed, and multi-byte fields may be byte-swapped if the two ends differ in endianness. The robust approach for something like a MIL-STD-1553B or RS422 telemetry frame is to parse byte-by-byte (or use a `packed` struct *and* explicit byte-order conversion), never to blindly cast the raw buffer to a normal struct pointer. This is exactly why the BEL packet-parsing automation worked at the byte level.

---

### Tier 3 — Trap & depth (principal-engineer level). Paragraph + the trap it defends against.

**Q3.1 — Is `arr[i]` the same as `*(arr + i)`? Is `i[arr]` legal?**
Yes — `arr[i]` is *defined* as `*(arr + i)`. Because addition is commutative, `*(arr + i) == *(i + arr)`, so `i[arr]` is legal C and compiles to the same access. **The trap:** interviewers use `i[arr]` to test whether you understand that subscripting is pure pointer arithmetic, not a special array operation. The follow-up trap is that this equivalence is why there is no bounds checking in C — `arr[i]` will happily compute an out-of-range address, which is the origin of buffer-overrun defects.

**Q3.2 — What is the difference between `char *s = "hi";` and `char s[] = "hi";`?**
`char s[] = "hi"` copies the 3 bytes (`h`,`i`,`\0`) into a writable local array you own — you may modify `s[0]`. `char *s = "hi"` makes `s` point at a string *literal*, which lives in read-only storage; writing `s[0] = 'H'` is undefined behaviour and on an MCU typically faults or is silently dropped if the literal is in flash. **The trap:** the second form should really be `const char *s` and modern compilers warn; candidates who say "they're the same" fail. Also `sizeof(s)` is 3 for the array but the pointer size for the pointer.

**Q3.3 — Given `int a[3][4];`, what are the types of `a`, `a[0]`, `*a`, `&a`, and how does `a+1` differ from `a[0]+1`?**
`a` has type "array[3] of array[4] of int". In an expression it decays to `int (*)[4]` — pointer to a row of 4 ints. `a[0]` is "array[4] of int", decaying to `int*`. `*a` is the same as `a[0]`. `&a` is `int (*)[3][4]` — pointer to the whole 2D array. The killer: `a + 1` advances by one *row* = `4*sizeof(int)` = 16 bytes, while `a[0] + 1` advances by one *int* = 4 bytes. **The trap:** this is how interviewers check you understand multidimensional arrays are not arrays of pointers — they are one contiguous block, and the row pointer type carries the inner dimension. Pass such an array as `void f(int (*a)[4], int rows)`, never as `int **`.

**Q3.4 — When you write `union { float f; uint32_t u; } x;`, then set `x.f` and read `x.u`, is that legal? What about the same trick with a cast `*(uint32_t*)&f`?**
Reading a different union member than the one last written is **type-punning**. In C (since C99, with a footnote) reading through a union member is permitted and is the portable, defined way to reinterpret bytes — this is the right tool for inspecting a float's IEEE-754 bits or serialising it. The cast form `*(uint32_t*)&f` instead violates the **strict-aliasing** rule: the compiler is allowed to assume a `float*` and a `uint32_t*` never refer to the same object, so with optimisation it may reorder or elide the access and produce wrong code. **The trap:** many engineers reach for the pointer cast; the correct, optimiser-safe answers are the union or `memcpy`. `gcc -fstrict-aliasing` (on at `-O2`) will bite the cast version.

**Q3.5 — A `struct` has a `uint8_t` then a `uint32_t` then a `uint16_t`. Sketch the layout, give its size, and show how to halve the padding.**
Natural alignment on a 32-bit target: `uint8_t` at offset 0, then 3 padding bytes, `uint32_t` at offset 4, `uint16_t` at offset 8, then 2 tail-padding bytes so the struct size (12) is a multiple of its largest alignment (4). Size = 12, of which 5 bytes are padding. Reorder to `uint32_t, uint16_t, uint8_t`: offsets 0, 4, 6, then 1 tail byte → size 8, only 1 padding byte. **The trap:** the interviewer wants the *tail* padding explained (so arrays of the struct stay aligned) and wants you to know reordering — not packing — is the first, free fix; packing is reserved for wire/register layouts because it can introduce unaligned accesses.

**Q3.6 — Bitfields: name three things that are implementation-defined, and why that disqualifies them from defining a wire protocol.**
(1) The *allocation order* of bits within a unit (MSB-first vs LSB-first) is implementation-defined; (2) whether a bitfield may straddle a storage-unit boundary; (3) the signedness of a plain `int` bitfield (`int x:1` may hold values 0 and −1). There is also padding between bitfields and alignment of the underlying unit. **The trap:** because two compilers (or the same compiler on two architectures) can lay the same bitfield struct out differently, a bitfield struct cast onto a received CCDL/1553B/RS422 frame may parse correctly on one build and garble on another. For on-the-wire or cross-channel data you extract fields with explicit shifts and masks; bitfields are fine only for local, single-compiler register convenience.

**Q3.7 — Explain `restrict` and one place it earns its keep in a driver.**
`restrict` on a pointer parameter is a promise to the compiler that, for the lifetime of that pointer, the object it points to is accessed *only* through that pointer (no aliasing). It lets the optimiser keep values in registers instead of reloading after every store. A `memcpy`-style routine declared `void copy(uint8_t *restrict dst, const uint8_t *restrict src, size_t n)` can be vectorised/unrolled because the compiler knows `dst` and `src` don't overlap. **The trap:** if you pass overlapping buffers to a `restrict` function the behaviour is undefined — which is precisely why `memcpy` is `restrict` and `memmove` is not. Misusing `restrict` to silence a warning is a real-world bug source.

---

## 3. Coding Gym

> Format for each: **Problem → Hints → `>>> ATTEMPT BEFORE READING ON <<<` → Solution (line-by-line) → Interviewer follow-up variants.**
> Every solution here compiles clean under `gcc -Wall -Wextra -std=c11`.

### Problem 1 — Swap two integers through pointers

**Problem.** Write `void swap(int *a, int *b)` that exchanges the two values. Then explain why the same thing written as `void swap(int a, int b)` cannot work.

**Hints.**
- You need the *addresses* of the caller's variables, not copies.
- A temporary is fine; no XOR tricks required (and XOR-swap breaks when both pointers are equal).

```
>>> ATTEMPT BEFORE READING ON <<<
```

**Solution.**

```c
#include <stdio.h>

void swap(int *a, int *b) {   /* a, b hold the addresses of the caller's ints */
    int tmp = *a;             /* read the value at a into a temporary          */
    *a = *b;                  /* copy b's value into a's location              */
    *b = tmp;                 /* copy the saved value into b's location        */
}

int main(void) {
    int x = 3, y = 5;
    swap(&x, &y);             /* pass addresses so swap can reach the originals */
    printf("%d %d\n", x, y);  /* prints: 5 3                                    */
    return 0;
}
```

C is pass-by-value: a plain `swap(int a, int b)` receives *copies*, swaps the copies, and the caller's variables are untouched. Passing pointers gives the function reach into the caller's storage.

**Interviewer follow-up variants.**
1. *"Make it generic for any type."* → `void swap(void *a, void *b, size_t n)` using a byte loop or `memcpy` through a temporary buffer.
2. *"Why is XOR-swap dangerous?"* → If `a == b`, XOR-swap zeroes the value; it also defeats the optimiser and is no faster on modern cores.
3. *"What if a caller passes `swap(&x, &x)`?"* → The temp-based version is safe (writes the same value back); discuss aliasing.

---

### Problem 2 — `my_strlen` from scratch

**Problem.** Implement `size_t my_strlen(const char *s)` without calling library functions.

**Hints.**
- Walk until the NUL terminator.
- `const` because you don't modify the string. Return `size_t`.

```
>>> ATTEMPT BEFORE READING ON <<<
```

**Solution.**

```c
#include <stddef.h>

size_t my_strlen(const char *s) {
    const char *p = s;        /* second cursor so we can subtract at the end   */
    while (*p != '\0') {      /* stop at the NUL terminator                    */
        p++;                  /* advance one char (chars are 1 byte by defn)   */
    }
    return (size_t)(p - s);   /* element distance == number of chars before NUL */
}
```

`p - s` is pointer subtraction over `char`, so it yields the count directly. The cast to `size_t` is because pointer difference is the signed `ptrdiff_t`.

**Interviewer follow-up variants.**
1. *"What if `s` is NULL?"* → Standard `strlen` is UB on NULL; decide a contract (assert, or document non-NULL).
2. *"Make it count up to a maximum (`strnlen`)."* → Add `size_t maxlen` and a second loop condition.
3. *"Where does this go wrong on a non-terminated buffer?"* → It reads past the end → out-of-bounds; tie to why fixed-width fields in a packet are safer than NUL-terminated ones.

---

### Problem 3 — `my_memcpy` and the overlap question

**Problem.** Implement `void *my_memcpy(void *dst, const void *src, size_t n)`. Then state what happens if the regions overlap and what you'd use instead.

**Hints.**
- Copy byte by byte through `unsigned char *`.
- Return `dst` to match the standard signature.

```
>>> ATTEMPT BEFORE READING ON <<<
```

**Solution.**

```c
#include <stddef.h>

void *my_memcpy(void *dst, const void *src, size_t n) {
    unsigned char *d = dst;          /* byte cursor into destination          */
    const unsigned char *s = src;    /* byte cursor into source (read-only)   */
    while (n-- > 0) {                /* copy exactly n bytes                  */
        *d++ = *s++;                 /* post-increment both cursors           */
    }
    return dst;                      /* standard memcpy returns the dest ptr  */
}
```

`unsigned char` is the correct lens for raw bytes (well-defined, no padding traps). If `dst` and `src` overlap, this forward copy can clobber source bytes before reading them, giving wrong results — that case is **undefined behaviour** for `memcpy` and is exactly why `memcpy` declares its pointers `restrict`. Use `memmove`, which detects direction and copies backward when needed.

**Interviewer follow-up variants.**
1. *"Write `my_memmove`."* → If `d < s` copy forward, else copy from the top down.
2. *"Speed it up."* → Copy word-at-a-time once both pointers are aligned, byte-tail the remainder; mention `restrict`.
3. *"Why `unsigned char` and not `char`?"* → `char` signedness is implementation-defined; `unsigned char` is the canonical byte type and is exempt from strict aliasing.

---

### Problem 4 — Count set bits (population count)

**Problem.** Write `int popcount(uint32_t v)` returning the number of 1-bits. Give a simple version and a faster one.

**Hints.**
- Naive: test bit 0, shift right, repeat 32 times.
- Faster: `v &= (v - 1)` clears the lowest set bit each iteration → loops only as many times as there are set bits.

```
>>> ATTEMPT BEFORE READING ON <<<
```

**Solution.**

```c
#include <stdint.h>

int popcount(uint32_t v) {
    int count = 0;
    while (v != 0u) {        /* Kernighan: loop once per set bit              */
        v &= (v - 1u);       /* clears the least-significant set bit          */
        count++;
    }
    return count;
}
```

`v - 1` flips the lowest set bit to 0 and sets all lower bits to 1; ANDing with `v` removes exactly that lowest set bit. So the loop runs *k* times for *k* set bits, beating the fixed 32-iteration shift version on sparse words.

**Interviewer follow-up variants.**
1. *"Why not just use `__builtin_popcount`?"* → Fine on a host/GCC; on a bare MCU it may expand to a library call — know the portable fallback.
2. *"Count bits in a register status word to detect stuck bits."* → Ties directly to reading a peripheral status/fault register during board bring-up.
3. *"Parallel/bit-twiddling O(1) version?"* → The SWAR mask-and-add sequence; mention it exists, derive only if pushed.

---

### Problem 5 — Reverse a string in place

**Problem.** Write `void reverse(char *s)` that reverses a NUL-terminated string in place.

**Hints.**
- Two indices/pointers from both ends moving toward the middle.
- Need the length first (or a two-pointer walk).

```
>>> ATTEMPT BEFORE READING ON <<<
```

**Solution.**

```c
#include <stddef.h>

static size_t slen(const char *s) {     /* tiny local length helper           */
    const char *p = s;
    while (*p) p++;
    return (size_t)(p - s);
}

void reverse(char *s) {
    if (s == NULL) return;               /* defensive: nothing to do           */
    size_t i = 0;
    size_t j = slen(s);
    if (j == 0) return;                  /* empty string                       */
    j--;                                 /* j = index of last real char        */
    while (i < j) {                      /* swap ends, walk inward             */
        char tmp = s[i];
        s[i] = s[j];
        s[j] = tmp;
        i++;
        j--;
    }
}
```

The guard `if (j == 0)` matters: `j` is unsigned, so decrementing 0 would wrap to a huge value and the loop would run off the end — a classic unsigned-underflow defect.

**Interviewer follow-up variants.**
1. *"Reverse only the words, keeping word order."* → Reverse whole string, then reverse each word — the classic two-pass trick.
2. *"Why must `s` be writable here?"* → A string literal would fault; argument should come from a `char[]`, not `char *lit`.
3. *"Reverse bytes of a `uint32_t` instead (endian swap)."* → Bridges into the endianness topic in Part 2.

---

### Problem 6 — Function-pointer dispatch table (state machine / command parser)

**Problem.** You receive single-byte commands over UART: `'R'` read, `'W'` write, `'S'` status. Replace a `switch` with a function-pointer dispatch table and explain the win.

**Hints.**
- An array (or small map) of `{command, handler}`.
- Each handler shares one signature.

```
>>> ATTEMPT BEFORE READING ON <<<
```

**Solution.**

```c
#include <stdio.h>

typedef int (*handler_fn)(int arg);     /* common handler signature           */

static int do_read(int arg)   { return arg + 1; }   /* stand-ins for real work */
static int do_write(int arg)  { return arg - 1; }
static int do_status(int arg) { return arg * 2; }

typedef struct {
    char        cmd;          /* the command byte from the wire               */
    handler_fn  fn;           /* pointer to the routine that handles it       */
} command_t;

static const command_t table[] = {      /* the dispatch table                 */
    { 'R', do_read   },
    { 'W', do_write  },
    { 'S', do_status },
};

static handler_fn lookup(char cmd) {
    for (size_t i = 0; i < sizeof(table) / sizeof(table[0]); i++) {
        if (table[i].cmd == cmd) {
            return table[i].fn;          /* found the handler                 */
        }
    }
    return NULL;                         /* unknown command                   */
}

int main(void) {
    char incoming = 'W';
    handler_fn h = lookup(incoming);
    if (h != NULL) {
        printf("result = %d\n", h(10));  /* calls do_write(10) -> 9           */
    } else {
        printf("unknown command\n");
    }
    return 0;
}
```

The win: adding a command is one table row, not another `case` plus risk of a missing `break`. The dispatch is data-driven, so the same engine handles any protocol just by swapping the table — which is how a clean RS422/CAN message parser is structured. The interrupt vector table is the same idea baked into hardware: an array of function pointers indexed by exception number.

**Interviewer follow-up variants.**
1. *"What's the danger of an uninitialised function pointer?"* → Calling it jumps to garbage → hard fault; always init to NULL and check.
2. *"How would you make this O(1) instead of O(n)?"* → Index by the command byte directly into a 256-entry sparse table when the command space is small/dense.
3. *"Where do function pointers appear in firmware you didn't write?"* → ISR vector table, RTOS task entry points, callback registration in driver APIs.

---

### Problem 7 — Prove structure padding and shrink it

**Problem.** Without running it on the target, predict `sizeof` for the two structs below on a 32-bit-aligned platform, then write a program that prints the sizes and member offsets to confirm.

```c
struct bad  { uint8_t a; uint32_t b; uint16_t c; };   /* poor order */
struct good { uint32_t b; uint16_t c; uint8_t a; };   /* packed by hand via ordering */
```

**Hints.**
- `offsetof` from `<stddef.h>` reveals where each member lands.
- Tail padding rounds the size up to the largest member's alignment.

```
>>> ATTEMPT BEFORE READING ON <<<
```

**Solution.**

```c
#include <stdio.h>
#include <stddef.h>
#include <stdint.h>

struct bad  { uint8_t a; uint32_t b; uint16_t c; };
struct good { uint32_t b; uint16_t c; uint8_t a; };

int main(void) {
    printf("bad : size=%zu  a@%zu b@%zu c@%zu\n",
           sizeof(struct bad),
           offsetof(struct bad, a),
           offsetof(struct bad, b),
           offsetof(struct bad, c));
    printf("good: size=%zu  b@%zu c@%zu a@%zu\n",
           sizeof(struct good),
           offsetof(struct good, b),
           offsetof(struct good, c),
           offsetof(struct good, a));
    return 0;
}
```

Predicted on a typical 32-bit-aligned ABI: `bad` → `a@0`, 3 pad, `b@4`, `c@8`, 2 tail pad → **size 12**. `good` → `b@0`, `c@4`, `a@6`, 1 tail pad → **size 8**. Same data, 33% smaller, just by ordering members large-to-small. (Exact numbers are ABI-dependent; the program confirms them on whatever you run it on.)

**Interviewer follow-up variants.**
1. *"Now make `bad` exactly 7 bytes."* → `__attribute__((packed))` — but warn about unaligned access cost/fault on some ARM cores.
2. *"Why does the tail get padded?"* → So `struct bad arr[2]` keeps `arr[1].b` aligned.
3. *"How does this interact with sending the struct over RS422?"* → Both ends must agree on padding *and* byte order, or you parse field-by-field instead.

---

### Problem 8 — Type-pun a float safely (endianness probe warm-up)

**Problem.** Print the four raw bytes of `float 1.0f` in memory order, using a *defined* technique (no strict-aliasing violation).

**Hints.**
- `union` member read, or `memcpy` into a byte array — both are legal.
- A `*(uint32_t*)&f` cast is the trap; avoid it.

```
>>> ATTEMPT BEFORE READING ON <<<
```

**Solution.**

```c
#include <stdio.h>
#include <stdint.h>
#include <string.h>

int main(void) {
    float f = 1.0f;
    unsigned char bytes[sizeof f];
    memcpy(bytes, &f, sizeof f);        /* defined: copies the object's bytes  */
    for (size_t i = 0; i < sizeof f; i++) {
        printf("%02X ", bytes[i]);      /* little-endian host prints: 00 00 80 3F */
    }
    printf("\n");
    return 0;
}
```

`memcpy` into an `unsigned char[]` is the optimiser-safe way to view an object's representation — `unsigned char` may alias anything, and `memcpy` is exempt from strict aliasing. On a little-endian host you'll see `00 00 80 3F` (IEEE-754 `1.0f` = `0x3F800000`, low byte first). On a big-endian target the order reverses — which is the bridge into the endianness section of Part 2 and into why telemetry floats need explicit byte-order handling.

**Interviewer follow-up variants.**
1. *"Do the same with a `union` — is it as legal?"* → Yes in C; show the `union { float f; unsigned char b[4]; }`.
2. *"Detect endianness at runtime."* → Pun a `uint32_t = 1` and look at byte 0 (covered in Part 2).
3. *"Why not `(uint32_t)f`?"* → That *converts* the value (truncates to 1), it does not reinterpret the bits — a favourite trick question.

---

## 4. Link to Her Resume

> **Ready sentence (pointers / drivers):** "On the BEL UART and GPIO driver verification I worked at the register level, so I'm fluent in casting a memory-mapped address to a `volatile` pointer of the correct width — getting that access width wrong is one of the first low-level driver defects I check for."

> **Ready sentence (structs / packets):** "When I built the Python suite parsing MIL-STD-1553B and RS422 telemetry, I learned the hard way to parse frames field-by-field rather than casting a raw buffer onto a struct — padding and endianness differences between the sender and my parser would otherwise corrupt the decode. The same byte-level discipline carries into the C side."

> **Ready sentence (function pointers):** "A clean message parser for CCDL or CAN traffic is a function-pointer dispatch table, not a giant switch — adding a message type becomes one table entry, and it mirrors how the MCU's own interrupt vector table works."

These connect Chapter 1 fundamentals to concrete lines already on the resume (LPC3250/ARM9 driver work, the 1553B/RS422 Python automation, RS422 interface routines at TASL). Keep the claims to what the resume states — the deep project scripting happens later, only from `inputs/INTAKE.md`.

---

## 5. Self-Test Scorecard

> 10 rapid-fire questions. Pass mark **8/10**. Answer out loud, then check the key.

1. On a 32-bit MCU, what is `sizeof(double *)`?
2. `int *p; p++;` — by how many bytes does `p` move?
3. Read aloud: `char *const p`. What is fixed, what is free?
4. Where does array-to-pointer decay **not** happen? Name two places.
5. What single byte ends a C string, and what is its value?
6. `arr[i]` is shorthand for what pointer expression? Is `i[arr]` legal?
7. Why is `char s[] = "hi"` writable but `char *s = "hi"` not safe to write?
8. Given `uint8_t; uint32_t; uint16_t` in a struct, what is the size on a 32-bit ABI, and how do you shrink it?
9. Reading a union member you didn't last write — legal in C? What about `*(uint32_t*)&myfloat`?
10. Name two reasons a bitfield struct must not define an on-the-wire protocol.

**Answer key.**
1. 4 bytes — pointer size follows the target address width, not the pointee.
2. `sizeof(int)` bytes, normally 4.
3. `p` (the pointer) is fixed/const; `*p` (the pointed-to char) is writable.
4. Under `sizeof`, under unary `&`, and as a `char[]` string-literal initialiser (any two).
5. The NUL byte `'\0'`, value 0.
6. `*(arr + i)`; yes, `i[arr]` is legal because addition commutes.
7. The array copies the bytes into writable storage you own; the pointer aims at a read-only string literal — writing it is UB.
8. 12 bytes (with 5 padding); reorder largest-to-smallest → 8 bytes. Packing is the last resort, for wire/register layouts.
9. Union member read is legal type-punning in C; the pointer-cast version violates strict aliasing and can be miscompiled at `-O2`.
10. Bit allocation order (MSB/LSB-first) is implementation-defined; signedness of plain-`int` bitfields is implementation-defined; straddling storage units and padding are also unspecified — so layout isn't portable across compilers/architectures.

---

*End of Chapter 1, Part 1. Part 2 (`volatile` / `const` / `static` / storage classes / typecasting / preprocessor / endianness) continues in this file in the next session.*
