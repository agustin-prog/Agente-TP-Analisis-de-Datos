import re, zlib

data=open('TP final.pdf','rb').read()
# find all streams
streams=re.findall(rb'stream\r?\n(.*?)endstream', data, re.S)
texts=[]
for s in streams:
    try:
        d=zlib.decompress(s)
    except Exception:
        d=s
    # decode as latin1 to keep bytes
    txt=d.decode('latin-1', errors='replace')
    texts.append(txt)

full='\n'.join(texts)
# extract strings in parentheses from Tj/TJ
# Simple: find all ( ... ) not escaped
def unescape(s):
    # handle basic escapes
    s=s.replace('\\\\','\\').replace('\\(','(').replace('\\)',')').replace('\\n','\n').replace('\\r','\r').replace('\\t','\t')
    return s

# Find TJ arrays and Tj
out_lines=[]
# We'll collect all parenthesized strings in order, but need newlines at Td/Tf? 
# Simpler: regex all \((?:\\.|[^()])*\)
for m in re.finditer(r'\((?:\\.|[^()])*\)', full):
    s=m.group(0)[1:-1]
    out_lines.append(unescape(s))

result=' '.join(out_lines)
# collapse multiple spaces
import re as r2
result=r2.sub(r'\s+',' ',result)
with open('tp_final_text.txt','w',encoding='utf-8') as f:
    f.write(result)
print(len(result))
print(result[:2000])
PY