mx = 0
sm = 0
cnt = 0
txsum=0
maxtxn = 0
with open("tmp.txt", "r") as infile:
  for line in infile:
  	l = line.split(" ");
  	tx = float(l[1])
  	if(tx>maxtxn):
  		maxtxn=tx
  	txsum +=tx
  	time = float(l[4][:-3])*0.000000001
  	thru = tx/time
  	print(cnt+1, round(thru,2))
  	sm = sm + thru
  	cnt += 1
  	if(thru>=mx):
  		mx = thru

print("Max throughput: ", round(mx,2))
print("Avg throughput: ", round(sm/cnt,2))
print("Num tx: ", txsum)
print("Max tx packed: ", maxtxn)