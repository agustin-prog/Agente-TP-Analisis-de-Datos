import re, zlib

data=open('TP final.pdf','rb').read()
streams=re.findall(rb'stream\s*\n(.*?)endstream', data, re.S)
print('num streams', len(streams))
for i,s in enumerate(streams):
    print(i, len(s))
    # try decompress
    try:
        d=zlib.decompress(s)
        print('  decompressed', len(d))
        print('  preview', d[:200])
    except Exception as e:
        print('  not zlib', e)
PY