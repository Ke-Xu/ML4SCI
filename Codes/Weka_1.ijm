run("Close All");

//path = getDirectory("current");
path = "/Users/kexu/Desktop/Fiji Practice/Pompeil_1/Test data/"  //The path of resource director
//print(path);
list = getFileList(path); 
j = 1  // correspoding to the number of weka pre trained model

for(i=0;i<list.length;i++){ 
    open(path+list[i]); 

    //run("8-bit");
    //supervise learning segmentation
    run("Trainable Weka Segmentation");
    wait(3000);
    
    //run("Advanced Weka Segmentation");
    selectWindow("Trainable Weka Segmentation v3.2.28");  // change to v3.2.27 if not work
    call("trainableSegmentation.Weka_Segmentation.loadClassifier", "/Users/kexu/Desktop/Fiji Practice/Pompeil_1/Pompeil_model1.model"); // path to the pre trained model  
    call("trainableSegmentation.Weka_Segmentation.getResult");
    wait(1500);

    //threshold on different channels
    run("RGB Color"); 
    run("Duplicate...", "duplicate");
    saveAs("Tiff", "/Users/kexu/Desktop/Fiji Practice/Pompeil_1/Test result/RGB/" + j + "_RGB_" + i + ".tif");  // save the classified RGB image
    close();
    selectWindow("Classified image");
    run("Make Composite");
    Stack.setDisplayMode("grayscale");
    run("Split Channels");

    //split circular backgroud 1
    selectWindow("C1-Classified image");
    run("Duplicate...", "duplicate");

    setThreshold(0, 80);
    run("Convert to Mask");
    run("Invert");

    run("Fill Holes");
    run("Invert");

    // crack void and matrix
    selectWindow("C1-Classified image");
    setThreshold(80,90);
    run("Convert to Mask");
    saveAs("Tiff", "/Users/kexu/Desktop/Fiji Practice/Pompeil_1/Test result/Raw C_V/" + j + "_CV_ini_" + i + ".tif");

    //Matrix
    selectWindow("C2-Classified image");
    run("Duplicate...", "duplicate");
    setThreshold(110, 118);
    run("Convert to Mask");

    //split backgroud 2
    selectWindow("C2-Classified image");
    setThreshold(0, 1);
    run("Convert to Mask");

    //aggregrate
    selectWindow("C3-Classified image");
    setThreshold(9, 11);
    run("Convert to Mask");

    //image calculate the real void and crack area
    imageCalculator("Add", "C1-Classified image-1","C2-Classified image-1");
    imageCalculator("Add", "C2-Classified image","C3-Classified image");
    imageCalculator("Add", "C1-Classified image-1","C2-Classified image");
    run("Invert");
    
    //save the result 
    saveAs("Tiff", "/Users/kexu/Desktop/Fiji Practice/Pompeil_1/Test result/Crack&Void/" + j + "_CV_pro_" + i + ".tif");
    selectWindow("C2-Classified image-1");
    saveAs("Tiff", "/Users/kexu/Desktop/Fiji Practice/Pompeil_1/Test result/Matrix/" + j + "_M_" + i + ".tif");
    selectWindow("C3-Classified image");
    saveAs("Tiff", "/Users/kexu/Desktop/Fiji Practice/Pompeil_1/Test result/Aggregate/" + j + "_A_" + i + ".tif");

    run("Close All");
    run("Collect Garbage");
    //close("*");
    wait(1000);
   
} 

