grammar small;

small: r0 EOF;
r0: r4 r1 r5;
r1: r2 r3 | r3 r2;
r2: r4 r4 | r5 r5;
r3: r4 r5 | r5 r4;
r4: 'a';
r5: 'b';
