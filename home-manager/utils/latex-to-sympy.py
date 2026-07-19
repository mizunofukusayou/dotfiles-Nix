import sys
from latex2sympy2 import latex2sympy
from sympy import simplify, S, I, Symbol
from sympy.printing import sstr, latex

def process_latex_expression(latex_str):
    # 1. LaTeXから数式をパース（この時点では変数は複素数扱い）
    raw_expr = latex2sympy(latex_str)

    # 2a. "j" という名前のシンボルは虚数単位(I)として強制的に置換する
    j_subs = {sym: I for sym in raw_expr.free_symbols if sym.name == "j"}
    raw_expr = raw_expr.subs(j_subs)

    # 2b. 残りの変数を「実数(real=True)」として再定義して置換する
    real_vars = {sym: Symbol(sym.name, real=True) for sym in raw_expr.free_symbols}
    full_expr = raw_expr.subs(real_vars)

    # 3. 式をシンプルにする
    simplified_expr = simplify(full_expr)

    # 【修正】実部と虚部に分解して X + j*Y の形にする
    real_part, imag_part = simplified_expr.as_real_imag()

    # 虚数単位を一時的にシンボル 'j' に置き換えて式を再構成
    j_symbol = Symbol('j')
    final_expr = real_part + j_symbol * imag_part

    # 【修正】結果をLaTeX形式の文字列にする
    latex_output = latex(final_expr)

    output = [
        f"Original:\t{sstr(full_expr)}",
        f"Simplified:\t{sstr(simplified_expr)}",
        f"LaTeX (X+jY):\t{latex_output}"
    ]

    return "\n".join(output)

if __name__ == "__main__":
    inp = sys.stdin.read().strip()
    if not inp:
        sys.exit(1)

    print(process_latex_expression(inp))
