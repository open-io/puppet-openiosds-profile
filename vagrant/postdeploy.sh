# Start all services
$GRIDINITCMD -S $GRIDINIT_SOCKET start

echo "Waiting for the $NBREPLICAS meta1 to register ..."
etime_start=$(date +"%s")
etime_end=$(($etime_start + $TIMEOUT))
nbmeta1=0
while [ $(date +"%s") -le $etime_end -a $nbmeta1 -lt $NBREPLICAS ]
do
  sleep $WAIT
  # Count registered meta1
  nbmeta1=$($OPENIOCMD --oio-ns=$NS cluster list meta1 -f value -c Id|wc -l)
done
if [ $nbmeta1 -ne $NBREPLICAS ]; then
  echo "Error: Install script did not found $NBREPLICAS meta1 services \
registered required to boostrap the namespace. Return: $nbmeta1"
  exit 1
fi

# Initialize meta1 with 3 replicas on the same server
echo "Boostrapping directory ..."
$OPENIOCMD --oio-ns=$NS directory bootstrap --replicas $NBREPLICAS || \
  (echo "Error: Directory bootstrap failed. Aborting." ; exit 1)

# Restarting meta0 and meta1
echo "Restarting directory services ..."
$GRIDINITCMD -S $GRIDINIT_SOCKET restart @meta0 @meta1 @meta2

# Waiting for service to restart ...
sleep 10

# Unlocking scores
$OPENIOCMD --oio-ns=$NS cluster unlockall
