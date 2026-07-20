import io
import sys

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
from latex2sympy2 import latex2sympy
from sympy import I, Symbol, simplify
from sympy.printing import latex


def generate_latex_png_bytes(latex_str):
    calc_width = max(8.0, min(20.0, len(latex_str) / 12.0))
    calc_height = 3.0 if "\\frac" in latex_str else 1.8

    fig, ax = plt.subplots(figsize=(calc_width, calc_height))
    ax.axis("off")

    font_size = 26 if len(latex_str) > 80 else 32
    ax.text(
        0.5,
        0.5,
        f"${latex_str}$",
        size=font_size,
        ha="center",
        va="center",
        color="white",
    )

    buf = io.BytesIO()
    plt.savefig(
        buf, format="png", dpi=300, bbox_inches="tight", pad_inches=0, transparent=True
    )
    plt.close(fig)
    return buf.getvalue()


def process_latex_expression(latex_str):
    raw_expr = latex2sympy(latex_str)
    j_subs = {sym: I for sym in raw_expr.free_symbols if sym.name == "j"}
    raw_expr = raw_expr.subs(j_subs)
    real_vars = {sym: Symbol(sym.name, real=True) for sym in raw_expr.free_symbols}
    full_expr = raw_expr.subs(real_vars)

    # 実部と虚部に分解
    real_part, imag_part = full_expr.as_real_imag()

    real_part = simplify(real_part)
    imag_part = simplify(imag_part)

    # 虚部が 0 の時は実部のみ、それ以外は X + jY の形にする
    if imag_part == 0:
        latex_output = latex(real_part)
    else:
        latex_real = latex(real_part)
        latex_imag = latex(imag_part)

        if "+" in latex_imag or "-" in latex_imag:
            latex_imag = f"\\left({latex_imag}\\right)"

        if real_part == 0:
            latex_output = f"j {latex_imag}"
        else:
            latex_output = f"{latex_real} + j {latex_imag}"

    # LaTeX式を書き込む (errors on stderr; LaTeX is written to a dedicated FD when provided)
    import os

    latex_fd = int(os.environ.get("SIMPLIFY_LATEX_FD", "2"))
    if latex_fd == 2:
        latex_out = sys.stderr.buffer
    elif latex_fd == 1:
        latex_out = sys.stdout.buffer
    else:
        latex_out = os.fdopen(latex_fd, "wb", closefd=False)

    latex_out.write((latex_output + "\n").encode("utf-8"))
    # PNGバイナリを書き込む
    png_bytes = generate_latex_png_bytes(latex_output)
    sys.stdout.buffer.write(png_bytes)


if __name__ == "__main__":
    inp = sys.stdin.read().strip()
    if not inp:
        sys.exit(1)
    process_latex_expression(inp)
