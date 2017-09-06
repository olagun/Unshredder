/**
 * <h1>ImageUnshredder</h1>
 * <p>Dynamically unshred an image in n^4 polynomial time.</p>
 * 
 * @author  Sam Olagun
 * @version 1.0
 */
class ImageUnshredder {
  private PImage img;
  private int width;
  private int height;
  
  /**
   * ImageUnshredder string constructor.
   * 
   * @param str PImage to unshred location (./data/str)
   */
  ImageUnshredder (String str) {
    this(loadImage(str));
  }
  
  /**
   * ImageUnshredder PImage constructor.
   * 
   * @param img PImage to unshred
   */
  ImageUnshredder (PImage img) {
    this.img = img;
    this.img.loadPixels();
    this.width = this.img.width;
    this.height = this.img.height;
  }
  
   /**
   * ImageUnshredder string constructor.
   * 
   * @param   str PImage to unshred location (./data/str)
   * @return      the unshredded Image
   * @see         PImage
   */
  PImage unshred() {
    for (int currCol = 0; currCol < this.width-1; currCol++) {
      PImage colImg;
      double smallestSum;
      int closestCol;
      
      colImg = this.img.get(currCol, 0, 1, this.height);
      colImg.loadPixels();

      smallestSum = 0;
      closestCol = 0;
      for (int compCol = currCol+1; compCol < this.width; compCol++) {
        PImage adjacentColImg;
        double distSum;
        
        adjacentColImg = img.get(compCol, 0, 1, this.height);
        adjacentColImg.loadPixels();
        
        distSum = this.colDist(colImg, adjacentColImg);
      
        if (compCol == currCol+1) {
          smallestSum = distSum;
          closestCol = compCol;
        } else if (distSum < smallestSum) {
          smallestSum = distSum;
          closestCol = compCol;
        }
      }
      
      this.colSwitch(currCol+1, closestCol);
    }

    this.img.updatePixels();
    return this.img;
  }

  /**
   * Calculates the euclidean distance between two images
   * by comparing each one of their pixels, calculating the
   * distance between them, and summing them.
   * 
   * @param   img1  first image to measure
   * @param   img2  second image to measure
   * @return        euclidean distance between the two images
   */
  private double colDist(PImage img1, PImage img2) {
    int w, h;
    double sum;
    
    w = img1.width;
    h = img1.height;
    sum = 0;
     
    for (int r = 0; r < h; r++) {
      for (int c = 0; c < w; c++) {
        color img1Pixel, img2Pixel;
        
        img1Pixel = img1.pixels[r*w+c];
        img2Pixel = img2.pixels[r*w+c];
        
        sum += abs(dist(
          red(img1Pixel), green(img1Pixel), blue(img1Pixel),
          red(img2Pixel), green(img2Pixel), blue(img2Pixel)
        ));
      }
    }
    
    return sum;
  }

  /**
   * Switches two columns in the image.
   * 
   * @param   col1  first column to switch with
   * @param   col2  second column to switch with
   */
  private void colSwitch (int col1, int col2) {
    PImage col1Img, col2Img;
    
    col1Img = this.img.get(col1, 0, 1, this.height);
    col2Img = this.img.get(col2, 0, 1, this.height);
    
    this.img.set(col1, 0, col2Img);
    this.img.set(col2, 0, col1Img);
  }
}

PImage img;
boolean frameSet = false;

void setup() {
  size(600, 600);
  frame.setResizable(true);
  img = (new ImageUnshredder("sample.png")).unshred();
}

void draw() {
  if (!frameSet) {
    frameSet = true;
    frame.setSize(img.width, img.height);
    frame.setResizable(false);
  }

  image(img, 0, 0);
}