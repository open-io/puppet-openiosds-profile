# Start all services
$GRIDINITCMD -S $GRIDINIT_SOCKET start

echo "Waiting for the meta1 to register ..."
etime_start=$(date +"%s")
etime_end=$(($etime_start + $TIMEOUT))
nbmeta1=0
while [ $(date +"%s") -le $etime_end -a $nbmeta1 -lt 1 ]
do
  sleep $WAIT
  # Count registered meta1
  nbmeta1=$($OIOCLUSTER -r $NS | grep -c meta1)
done
if [ $nbmeta1 -ne 1 ]; then
  echo "Error: Install script did not found 1 meta1 service registered after $TIMEOUT. $nbmeta1 meta1 found."
  exit 1
fi

# Initialize meta0
echo "Loading meta0 ..."
sleep $WAIT
$OIOMETA0INIT $NS || \
  (echo "Error: $OIOMETA0INIT failed. Aborting." ; exit 1)

# Restarting meta0 and meta1
echo "Restarting directory services ..."
$GRIDINITCMD -S $GRIDINIT_SOCKET restart @meta0
$GRIDINITCMD -S $GRIDINIT_SOCKET restart @meta1
$GRIDINITCMD -S $GRIDINIT_SOCKET restart @meta2

# Waiting for service to restart ...
sleep 5

