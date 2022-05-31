class PartitionInfo{
  int size;
  boolean isFree;
  int baseAddress;
  
  PartitionInfo(int s, int ba){
    size = s;
    isFree = true;
    baseAddress = ba;
  }
  
  String toString(){
    return "BA "+baseAddress+" Size: "+size+" free: "+isFree;
  }
  
}
