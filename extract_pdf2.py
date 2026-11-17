import re, zlib

data=open('TP final.pdf','rb').read()
streams=re.findall(rb'stream\r?\n(.*?)endstream', data, re.S)

def unescape(s):
    s=s.replace('\\\\','\\').replace('\\(','(').replace('\\)',')').replace('\\n','\n').replace('\\r','\r').replace('\\t','\t')
    return s

pat=re.compile(r'\((?:[^()\\]|\\.)*\)')

out=[]
for i,s in enumerate(streams):
    try:
        d=zlib.decompress(s)
    except Exception:
        d=s
    txt=d.decode('latin-1', errors='replace')
    # only process if contains text operators
    if 'Tj' not in txt and 'TJ' not in txt:
        continue
    for m in pat.finditer(txt):
        out.append(unescape(m.group(0)[1:-1]))
    out.append(' ')  # separator between streams

result=' '.join(out)
result=re.sub(r'\s+',' ',result)
with open('tp_final_text.txt','w',encoding='utf-8') as f:
    f.write(result)
print('streams', len(streams), 'len', len(result))
print(result[:3000])
PY