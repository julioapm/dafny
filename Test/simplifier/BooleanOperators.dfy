// RUN: %dafny /compile:0 "%s" > "%t"
// RUN: %diff "%s.expect" "%t"

function method {:simplifier} simp<T>(x: T): T { x }

function method {:opaque} Foo(x: int): int {
  42
}

lemma {:simp} Foo42()
  ensures Foo(7) == 42
{
  reveal Foo();
}

lemma {:simp} IfTrue_simp<T>(x: T, y: T)
  ensures (if true then x else y) == x
{}

lemma {:simp} IfFalse_simp<T>(x: T, y: T)
  ensures (if false then x else y) == y
{}

lemma {:simp} AndFalse_simp1(x: bool)
  ensures (x && false) == false
{}

lemma {:simp} AndFalse_simp2(x: bool)
  ensures (false && x) == false
{}

lemma {:simp} AndTrue_simp()
  ensures (true && true) == true
{}

lemma {:simp} OrTrue_simp1(x: bool)
  ensures (x || true) == true
{}

lemma {:simp} OrTrue_simp2(x: bool)
  ensures (true || x) == true
{}

lemma {:simp} OrFalse_simp()
  ensures (false || false) == false
{}

method g(x: bool)
{
  assert simp(Foo(if true && false then 8 else 7)) == 42;
  assert simp(Foo(if true && true then 7 else 8)) == 42;
  assert simp(Foo(if false && x then 8 else 7)) == 42;
  assert simp(Foo(if x && false then 8 else 7)) == 42;

  assert simp(Foo(if (true || false) then 7 else 8)) == 42;
  assert simp(Foo(if false || false then 8 else 7)) == 42;
  assert simp(Foo(if true || x then 7 else 8)) == 42;
  assert simp(Foo(if x || true then 7 else 8)) == 42;
}
