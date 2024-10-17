# Density-Traffic-Control

The traffic light rules are universal and similar in every part of the world. The 
red-yellow-green traffic signal (3 lighted system) system means the same for people across the 
globe. A traffic signal comprises major parts like the lights, controller and sensor. Even though 
the traffic light rules in India or in other parts of the world are the same, the technologies used 
for the traffic signal setting might be widely different. The traffic lights used in India are 
basically pre-timed in the sense the time of each lane/street  to have a green signal is fixed. In a 
four lane traffic signal one lane is given a green signal at a time. Thus, the traffic light allows the vehicles of all lanes to pass in a sequence. So, the traffic can advance in either straight direction or turn by 90 degrees.  


PROBLEMS WITH THE EXISTING METHOD: 
●  Even if the traffic density in a particular lane is the least, one  has to wait unnecessarily 
for a long  time .  
● When a traffic light shows a green signal it unnecessarily makes other lanes wait for even 
longer durations.  
● Therefore in India, with the growing number of vehicles, traffic congestion at junctions 
has become a serious issue especially during peak hours. 


PROPOSED SOLUTION:

Vehicle detection plays an important role in designing intelligent traffic light systems. With a 
view to do improvements , it is proposed to develop an Automatic Vehicle recognition system 
using various image processing techniques.   The system basically counts the number of vehicles 
in each lane /street and declares the densest road to get highest priority in order to reduce traffic congestion. This simulated version of this  system uses the image(s) acquired from the camera installed near the traffic signal in order to realize the densest road. The foreground of the 
acquired image is detected using background subtraction technique . Later on morphological 
opening is applied to reduce the noise in the image. In the final step, the vehicles are detected 
using blob analysis. Same method is applied to all the four lanes . Priority is given to the lane 
with more number of vehicles. But, Using the images to realize the densest might not be a 
practical solution since it gives the result for that particular instant. So, to practically realize the scenario , video data is acquired from the stationary camera installed. This video is seen as a 
sequence of image frames . In order to detect the foreground of the video frame , Gaussian 
Mixture Model (GMM) is used . After detecting the foreground, objects(vehicles)  are 
recognized  using blob analysis. The results are encouraging  as we got  95% of accuracy using 
these techniques.