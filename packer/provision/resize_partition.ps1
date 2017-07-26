# Print disk size
echo "Disk usage:"
Get-WmiObject win32_logicaldisk

# Resize first partition of first disk to maximum size
Get-Partition -DiskNumber 0 -PartitionNumber 1
$size = (Get-PartitionSupportedSize -DiskNumber 0 -PartitionNumber 1)
Resize-Partition -DiskNumber 0 -PartitionNumber 1 -Size $size.SizeMax

# Print disk size
echo "Disk usage:"
Get-WmiObject win32_logicaldisk

