# latex-to-sympy.py
import sys
import os
import tempfile
import subprocess
import matplotlib.pyplot as plt
from latex2sympy2 import latex2sympy
from sympy import simplify, S, I, Symbol
from sympy.printing import sstr, latex

def render_latex_to_terminal(latex_str):
    """matplotlibを使ってLaTeX文字列を画像化し、wezterm imgcatで表示する"""
    # グラフの枠線や軸を非表示にする設定
    fig, ax = plt.subplots(figsize=(6, 1.5))
    ax.axis('off')
    
    # matplotlibの独自LaTeXレンダラー(mathtext)を使用するため $ で囲む
    # 読みやすさのためにフォントサイズを大きめに設定
    ax.text(0.5, 0.5, f"${latex_str}$", size=24, ha='center', va='center', color='white')
    
    # 一時ファイルとしてPNG画像を保存（背景は透過）
    with tempfile.NamedTemporaryFile(suffix='.png', delete=False) as tmpfile:
        tmp_path = tmpfile.name
        plt.savefig(tmp_path, bbox_inches='tight', pad_inches=0.1, transparent=True)
        plt.close(fig)
    
    # wezterm imgcat を使ってターミナルへ描画
    try:
        subprocess.run(['wezterm', 'imgcat', tmp_path], check=True)
    finally:
        # 使用後に一時ファイルを削除
        if os.path.exists(tmp_path):
            os.remove(tmp_path)

def process_latex_expression(latex_str):
    raw_expr = latex2sympy(latex_str)

    j_subs = {sym: I for sym in raw_expr.free_symbols if sym.name == "j"}
    raw_expr = raw_expr.subs(j_subs)

    real_vars = {sym: Symbol(sym.name, real=True) for sym in raw_expr.free_symbols}
    full_expr = raw_expr.subs(real_vars)

    simplified_expr = simplify(full_expr)
    real_part, imag_part = simplified_expr.as_real_imag()

    j_symbol = Symbol('j')
    final_expr = real_part + j_symbol * imag_part

    latex_output = latex(final_expr)

    output = [
        f"Original:\t{sstr(full_expr)}",
        f"Simplified:\t{sstr(simplified_expr)}",
        f"LaTeX (X+jY):\t{latex_output}\n"
    ]

    # テキスト情報を標準出力
    print("\n".join(output))
    
    # 【追加】数式画像をターミナル上にレンダリング
    render_latex_to_terminal(latex_output)

if __name__ == "__main__":
    inp = sys.stdin.read().strip()
    if not inp:
        sys.exit(1)

    process_latex_expression(inp)
