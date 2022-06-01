class BestFit extends MemoryManager {

  BestFit(String c, String nm) {
    super(c, nm);
  }

  void initialise(String fn) {
    filename = fn;
    initialise();
  }

  void initialise() {
    message = "BestFit >> Starting search of partition for program ("+filename+")";
    os.interruptsEnabled = false;
    os.switchTo(this);
  }

  void execute() {
    result = null;
    int requestedSize = myPC.HDD.get(filename).length()+os.processAppendix.length();
    for (PartitionInfo partition : os.partitionTable) {
      if (partition.isFree && partition.size>=requestedSize) {
        //insert a new partition after this one 
        //int secondPartBA = partition.baseAddress + requestedSize;
        //int secondPartSize = partition.size - requestedSize;
        //int fistPartSize = requestedSize;
        //int partIndex = os.partitionTable.indexOf(partition);
        //one that checks if the partition in i is larger than or equal to the requestedSize
        //and the other one checking if that partition is smaller than the original partition
        for (int i = 1; i < os.partitionTable.size(); i++){
          int secondPartBA = partition.baseAddress + requestedSize;
          int secondPartSize = partition.size - requestedSize;
          int fistPartSize = requestedSize;
          int partIndex = os.partitionTable.indexOf(partition);
          if(partition.isFree && os.partitionTable.get(i).size>=requestedSize){
            
            if(os.partitionTable.get(i).size<partition.size){
              
              os.partitionTable.add(partIndex+1, new PartitionInfo(secondPartSize, secondPartBA));
            }
            partition.size = fistPartSize;
            result = partition;
            break;
          }
        }
        
        
        //if (partition.size>requestedSize) {
        //  os.partitionTable.add(partIndex+1, new PartitionInfo(secondPartSize, secondPartBA));
        //}
        //partition.size = fistPartSize;
        //result = partition;
        //break;
      }
    }
    if (result==null) {
      message = "BestFit >> No partition for "+filename+" was found. Will try again in 100 ticks";
      os.loadProgram(myPC.clock+100, filename);
    }else message = "BestFit >> Partition created at base address "+result.baseAddress+" ("+filename+")";
    os.interruptsEnabled = false;
  }
}
