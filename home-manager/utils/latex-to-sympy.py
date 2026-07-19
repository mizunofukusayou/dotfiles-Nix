# latex-to-sympy.py
import sys
import io
import matplotlib.pyplot as plt
from latex2sympy2 import latex2sympy
from sympy import simplify, S, I, Symbol
from sympy.printing import sstr, latex

def generate_latex_png_bytes(latex_str):
    """数式の長さに合わせて画像の大きさを自動調整し、高解像度でPNGのRawデータを返す"""
    calc_width = max(8.0, min(20.0, len(latex_str) / 12.0))
    calc_height = 3.0 if "\\frac" in latex_str else 1.8

    fig, ax = plt.subplots(figsize=(calc_width, calc_height))
    ax.axis('off')
    
    font_size = 26 if len(latex_str) > 80 else 32
    ax.text(0.5, 0.5, f"${latex_str}$", size=font_size, ha='center', va='center', color='white')
    
    buf = io.BytesIO()
    plt.savefig(buf, format='png', dpi=300, bbox_inches='tight', pad_inches=0, transparent=True)
    plt.close(fig)
    return buf.getvalue()

def process_latex_expression(latex_str):
    raw_expr = latex2sympy(latex_str)
    j_subs = {sym: I for sym in raw_expr.free_symbols if sym.name == "j"}
    raw_expr = raw_expr.subs(j_subs)
    real_vars = {sym: Symbol(sym.name, real=True) for sym in raw_expr.free_symbols}
    full_expr = raw_expr.subs(real_vars)
    simplified_expr = simplify(full_expr)
    
    # 実部と虚部に分解
    real_part, imag_part = simplified_expr.as_real_imag()
    
    latex_real = latex(real_part)
    latex_imag = latex(imag_part)

    # 虚部が 0 の時は実部のみ、それ以外は X + jY の形にする
    if latex_imag == "0":
        latex_output = latex_real
    else:
        if '+' in latex_imag or '-' in latex_imag:
            latex_output = f"{latex_real} + j \\left({latex_imag}\\right)"
        else:
            latex_output = f"{latex_real} + j {latex_imag}"

    # 不要な出力を削除し、LaTeX式のみを組み立てる
    output = (
        f"{latex_output}\n"
        f"---PNG_START---\n"
    )
    
    sys.stdout.buffer.write(output.encode('utf-8'))
    
    # 自動サイズ調整されたPNGバイナリを書き込む
    png_bytes = generate_latex_png_bytes(latex_output)
    sys.stdout.buffer.write(png_bytes)

if __name__ == "__main__":
    inp = sys.stdin.read().strip()
    if not inp:
        sys.exit(1)
    process_latex_expression(inp)
