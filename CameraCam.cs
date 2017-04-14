using UnityEngine;
using System.Collections;

public class CameraCam : MonoBehaviour
{
    // //public ParticleSystem rainParticles;
    // int emissionNumber = 1000;
    
    //int lightningTimer = 0; 
    // public float speedH = 2.0f;
    // public float speedV = 2.0f;
    //public Light mainLight;
    // private float yaw = 0.0f;
    // private float pitch = 0.0f;
    private float windGain = 0.0f;
    private float windAmp1 = 0.0f;
    private float windAmp2 = 0.0f;
    private float windAmp3 = 0.0f;
    private float windAmp4 = 0.0f;

    private float windNewGain = 0.5f;
    private float windNewAmp1 = 0.25f;
    private float windNewAmp2 = 0.13f;
    private float windNewAmp3 = 0.0f;
    private float windNewAmp4 = 0.0f;
    private float stepsGainOffset = 1f;
    // private float windNewX = 0.0f;
    // private float windNewY = 0.0f;
    // private float windNewZ = 0.0f;

    //--------------------------------
    public float velocidadMax = 0.1f;
     
     public float xMax = 10.0f;
     public float yMax = 15.0f;
     public float zMax = 10.0f;
     public float xMin = -10.0f;
     public float yMin = 2.0f;
     public float zMin = -10.0f;
         
    private float windX = 0.0f;
    private float windY = 0.0f;
    private float windZ = 0.0f;
     private float tiempo;
     private float angulo;

     GameObject RoamingWind;
     //--------------------------------
    public CsoundUnity csound;
    AudioSource audio;
    void Start()
    {
        csound = GetComponent<CsoundUnity>();

        audio = gameObject.GetComponent<AudioSource>();

        csound.setChannel("RainDens", 0f);
        csound.setChannel("gain", windGain);
        csound.setChannel("amp1", windAmp1);
        csound.setChannel("amp2", windAmp2);
        csound.setChannel("amp3", windAmp3);
        csound.setChannel("amp4", windAmp4);
        csound.setChannel("band1", 0.1f);
        csound.setChannel("band2", 0.1f);
        csound.setChannel("band3", 0.1f);
        csound.setChannel("band4", 0.1f);
        csound.setChannel("StepsGain", 0.2f + stepsGainOffset);

        audio.spatialBlend = 1f;
		//   audio.spread = 360;
		audio.volume = 1;
        StartCoroutine("WindEvent");
        //InvokeRepeating("WindSpeed", 1, .2f);
        //---------------------------------------
        RoamingWind = new GameObject();
        windX = Random.Range(-velocidadMax, velocidadMax);
        windY = Random.Range(-velocidadMax, velocidadMax);
         windZ = Random.Range(-velocidadMax, velocidadMax);
         angulo = Mathf.Atan2(windX, windZ) * (180 / 3.141592f) + 90;
         RoamingWind.transform.rotation = Quaternion.Euler( 0, angulo, 0);
         //---------------------------------------
    }

    public void CSoundPosition(string eventType, Vector3 pos, int childIndex)
    {
        csound.setChannel(eventType + "X" + childIndex, ((Camera.main.transform.position.x - pos.x) > 0) ? (Camera.main.transform.position.x - pos.x) : (pos.x - Camera.main.transform.position.x) );
		csound.setChannel(eventType + "Y" + childIndex, ((Camera.main.transform.position.y - pos.y) > 0) ? (Camera.main.transform.position.y - pos.y) : (pos.y - Camera.main.transform.position.y) );
		csound.setChannel(eventType + "Z" + childIndex, ((Camera.main.transform.position.z - pos.z) > 0) ? (Camera.main.transform.position.z - pos.z) : (pos.z - Camera.main.transform.position.z) );

    }
    public void CSoundEvent(string eventType, float dur, float matherial, Vector3 pos, int childIndex)
    { 		
        // Vector3 fwd = transform.TransformDirection(Vector3.forward);
        // Vector3 bwd = transform.TransformDirection(Vector3.back);
        // Vector3 lft = transform.TransformDirection(Vector3.left);
        // Vector3 rgt = transform.TransformDirection(Vector3.right);
        // Vector3 up = transform.TransformDirection(Vector3.up);
        // Vector3 dwn = transform.TransformDirection(Vector3.down);

         RaycastHit fwd;
         RaycastHit bwd;
         RaycastHit lft;
         RaycastHit rgt;
         RaycastHit up;
         RaycastHit dwn;

        Vector3 offsetUp = new Vector3(0, 0.2f,0);

                if (Physics.Raycast(pos += offsetUp, Vector3.forward, out fwd, 50.0f)) {
                // csound.setChannel("FwdDist", fwd.distance);
                    if (fwd.transform.tag == "Concrete") {
                        csound.setChannel("FwdFreq", 5000.0f);
                        csound.setChannel("FwdLevel", 0.87f);
                    } else if (fwd.transform.tag == "Ground") {
                        csound.setChannel("FwdFreq", 1000.0f);
                        csound.setChannel("FwdLevel", 0.1f);
                    } else if (fwd.transform.tag == "Rock") {
                        csound.setChannel("FwdFreq", 3500.0f);
                        csound.setChannel("FwdLevel", 0.5f);
                    } else if (fwd.transform.tag == "Wood") {
                        csound.setChannel("FwdFreq", 2500.0f);
                        csound.setChannel("FwdLevel", 0.5f);
                    }
                    //print("Forward " + fwd.transform.tag);
                }// else 
                csound.setChannel("FwdDist", fwd.distance);

                if (Physics.Raycast(pos += offsetUp, Vector3.back, out bwd, 50.0f)) {
                // csound.setChannel("BwdDist", bwd.distance);
                    if (bwd.transform.tag == "Concrete") {
                        csound.setChannel("BwdFreq", 5000.0f);
                        csound.setChannel("BwdLevel", 0.87f);
                    } else if (bwd.transform.tag == "Ground") {
                        csound.setChannel("BwdFreq", 1000.0f);
                        csound.setChannel("BwdLevel", 0.1f);
                    } else if (bwd.transform.tag == "Rock") {
                        csound.setChannel("BwdFreq", 3500.0f);
                        csound.setChannel("BwdLevel", 0.5f);
                    } else if (bwd.transform.tag == "Wood") {
                        csound.setChannel("BwdFreq", 2500.0f);
                        csound.setChannel("BwdLevel", 0.5f);
                    }
                    //print("Backward " + bwd.transform.tag);
                }// else 
                csound.setChannel("BwdDist", bwd.distance);

                if (Physics.Raycast(pos += offsetUp, Vector3.left, out lft, 50.0f)) {
                    // csound.setChannel("LftDist", lft.distance);
                    if (lft.transform.tag == "Concrete") {
                       csound.setChannel("LftFreq", 5000.0f);
                        csound.setChannel("LftLevel", 0.87f); 
                    } else if (lft.transform.tag == "Ground") {
                      csound.setChannel("LftFreq", 1000.0f);
                        csound.setChannel("LftLevel", 0.1f);
                    } else if (lft.transform.tag == "Rock") {
                      csound.setChannel("LftFreq", 3500.0f);
                        csound.setChannel("LftLevel", 0.5f);
                    } else if (lft.transform.tag == "Wood") {
                      csound.setChannel("LftFreq", 2500.0f);
                        csound.setChannel("LftLevel", 0.5f);
                    }
                    //print("Left " + lft.transform.tag);
                }// else 
                csound.setChannel("LftDist", lft.distance);

                if (Physics.Raycast(pos += offsetUp, Vector3.right, out rgt, 50.0f)) {
                    // csound.setChannel("RgtDist", rgt.distance);
                    if (rgt.transform.tag == "Concrete") {
                       csound.setChannel("RgtFreq", 5000.0f);
                        csound.setChannel("RgtLevel", 0.87f);
                    } else if (rgt.transform.tag == "Ground") {
                        csound.setChannel("RgtFreq", 1000.0f);
                        csound.setChannel("RgtLevel", 0.1f);
                    } else if (rgt.transform.tag == "Rock") {
                        csound.setChannel("RgtFreq", 3500.0f);
                        csound.setChannel("RgtLevel", 0.5f);
                    } else if (rgt.transform.tag == "Wood") {
                        csound.setChannel("RgtFreq", 2500.0f);
                        csound.setChannel("RgtLevel", 0.5f);
                    }
                    //print("Right " + rgt.transform.tag);
                }// else 
                csound.setChannel("RgtDist", rgt.distance);

                if (Physics.Raycast(pos += offsetUp, Vector3.up, out up, 50.0f)) {
                    // csound.setChannel("UpDist", up.distance);
                    if (up.transform.tag == "Concrete") {
                      csound.setChannel("UpFreq", 4000.0f);
                        csound.setChannel("UpLevel", 0.87f);
                    } else if (up.transform.tag == "Ground") {
                        csound.setChannel("UpFreq", 500.0f);
                        csound.setChannel("UpLevel", 0.1f);
                    } else if (up.transform.tag == "Rock") {
                        csound.setChannel("UpFreq", 1500.0f);
                        csound.setChannel("UpLevel", 0.5f);
                    } else if (up.transform.tag == "Wood") {
                        csound.setChannel("UpFreq", 1000.0f);
                        csound.setChannel("UpLevel", 0.5f);
                    }
                    //print("Up " + up.transform.tag);
                }// else 
                csound.setChannel("UpDist", up.distance);

                if (Physics.Raycast(pos += offsetUp, Vector3.down, out dwn, 50.0f)) {
                    // csound.setChannel("DwnDist", dwn.distance);
                    if (dwn.transform.tag == "Concrete") {
                        csound.setChannel("DwnFreq", 1500.0f);
                        csound.setChannel("DwnLevel", 0.5f);
                                csound.setChannel(eventType + "Dur", dur);
			                    csound.setChannel(eventType + "Math", 0.9f);
                                csound.setChannel(eventType + "Weight", 0.8f);
                                csound.setChannel(eventType + "LowPass", 500.0f);
			                    csound.setChannel(eventType + "HighPass", 4000.0f);
                                csound.setChannel("StepsGain", 0.0f + stepsGainOffset/2);
                                csound.setChannel("GrainMix", Random.Range(0.01f, 0.1f + stepsGainOffset/10));
			                    csound.setChannel("GrainDens", Random.Range(0.01f, 0.05f));
                    } else if (dwn.transform.tag == "Ground") {
                       csound.setChannel("DwnFreq", 500.0f);
                        csound.setChannel("DwnLevel", 0.2f);
                                csound.setChannel(eventType + "Dur", dur);
			                    csound.setChannel(eventType + "Math", 1.0f);
                                csound.setChannel(eventType + "Weight", 0.8f);
                                csound.setChannel(eventType + "LowPass", 600.0f);
			                    csound.setChannel(eventType + "HighPass", 3000.0f);
                                csound.setChannel("StepsGain", 0.1f + stepsGainOffset);
                                csound.setChannel("GrainMix", Random.Range(0.01f, 0.1f + stepsGainOffset));
			                    csound.setChannel("GrainDens", Random.Range(0.05f, 0.4f));
                    } else if (dwn.transform.tag == "Rock") {
                       csound.setChannel("DwnFreq", 1000.0f);
                        csound.setChannel("DwnLevel", 0.5f);
                                csound.setChannel(eventType + "Dur", dur);
			                    csound.setChannel(eventType + "Math", 0.9f);
                                csound.setChannel(eventType + "Weight", 1.0f);
                                csound.setChannel(eventType + "LowPass", 500.0f);
			                    csound.setChannel(eventType + "HighPass", 2000.0f);
                                csound.setChannel("StepsGain", 0.0f + stepsGainOffset/2);
                                csound.setChannel("GrainMix", Random.Range(0.01f, 0.1f + stepsGainOffset/6));
			                    csound.setChannel("GrainDens", Random.Range(0.05f, 0.3f));
                    } else if (dwn.transform.tag == "Wood") {
                        csound.setChannel("DwnFreq", 4000.0f);
                        csound.setChannel("DwnLevel", 0.5f);
                        		csound.setChannel(eventType + "Dur", dur);
			                    csound.setChannel(eventType + "Math", 0.7f);
                                csound.setChannel(eventType + "Weight", 1.0f);
                                csound.setChannel(eventType + "LowPass", 500.0f);
			                    csound.setChannel(eventType + "HighPass", 2500.0f);
                                csound.setChannel("StepsGain", 0.0f + stepsGainOffset/2);
                                csound.setChannel("GrainMix", Random.Range(0.01f, 0.1f + stepsGainOffset/3));
			                    csound.setChannel("GrainDens", Random.Range(0.05f, 0.2f));
                    } else if (dwn.transform.tag == "Carpet") {
                        csound.setChannel("DwnFreq", 1000.0f);
                        csound.setChannel("DwnLevel", 0.1f);
                        		csound.setChannel(eventType + "Dur", dur);
			                    csound.setChannel(eventType + "Math", 1.0f);
                                csound.setChannel(eventType + "Weight", 0.5f);
                                csound.setChannel(eventType + "LowPass", 500.0f);
			                    csound.setChannel(eventType + "HighPass", 3000.0f);
                                csound.setChannel("StepsGain", stepsGainOffset);
                                csound.setChannel("GrainMix", 0.0f);
			                    csound.setChannel("GrainDens", 0.0f);
                    }
                    //print("Down " + dwn.transform.tag);
                } //else 
                csound.setChannel("DwnDist", dwn.distance);

                if ((fwd.distance + bwd.distance + lft.distance + rgt.distance) < 20) {
                        windNewGain = 0.3f;
                        windNewAmp1 = 0.1f;
                        windNewAmp2 = 0.02f;
                        windNewAmp3 = 0.0f;
                        windNewAmp4 = 0.09f;
                } else {

                        windNewGain = 0.3f;
                        windNewAmp1 = 0.01f;//0.25f;
                        windNewAmp2 = 0.01f;//0.09f;
                        windNewAmp3 = 0.05f;//Mathf.Abs(pos.y - 3) / 100;
                        windNewAmp4 = 0.05f;//Mathf.Abs(pos.y - 3) / 100;;
                }
                
                // if ((fwd.distance + bwd.distance + lft.distance + rgt.distance) < 20) {
                //         windNewAmp3 = 0.05f;
                //         windNewAmp4 = 0.05f;
                // } else {
                //         windNewAmp3 = Mathf.Abs(pos.y - 6) / 100;
                //         windNewAmp4 = 0.05f;
                // }

              csound.setStringChannel(eventType + "Index", eventType + "Chan" + $"{childIndex}" );

			  csound.setChannel(eventType + "X" + childIndex, ((Camera.main.transform.position.x - pos.x) > 0) ? (Camera.main.transform.position.x - pos.x) : (pos.x - Camera.main.transform.position.x) );
			  csound.setChannel(eventType + "Y" + childIndex, ((Camera.main.transform.position.y - pos.y) > 0) ? (Camera.main.transform.position.y - pos.y) : (pos.y - Camera.main.transform.position.y) );
			  csound.setChannel(eventType + "Z" + childIndex, ((Camera.main.transform.position.z - pos.z) > 0) ? (Camera.main.transform.position.z - pos.z) : (pos.z - Camera.main.transform.position.z) );

			  csound.setChannel(eventType, Random.Range(1, 100));     



        // print("DebugX " + pos.x);
        // print("DebugY " + pos.y);
        // print("DebugZ " + pos.z);
            //   print("LP " + csound.getChannel("Answer1"));
            //   print("HP " + csound.getChannel("Answer2"));
            //   print("Forward " + csound.getChannel("Answer1"));
            //   print("Backward " + csound.getChannel("Answer2"));
            //   print("Left " + csound.getChannel("Answer3"));
            //   print("Right " + csound.getChannel("Answer4"));
            //   print("Up " + csound.getChannel("Answer5"));
            //   print("Down " + csound.getChannel("Answer6"));
    }
    private IEnumerator WindEvent()
    {   
        while(true)
        {
            yield return new WaitForSeconds(0.01f); 

                if (windGain != windNewGain) {
                    if ((windNewGain - windGain) > 0.001) windGain += 0.001f;
                    else if ((windGain - windNewGain) > 0.001) windGain -= 0.001f;
                    csound.setChannel("gain", windGain);
                }
                if (windAmp1 != windNewAmp1) {
                    if ((windNewAmp1 - windAmp1) > 0.001) windAmp1 += 0.001f;
                    else if ((windAmp1 - windNewAmp1) > 0.001) windAmp1 -= 0.001f;
                    csound.setChannel("amp1", windAmp1);
                }
                if (windAmp2 != windNewAmp2) {
                    if ((windNewAmp2 - windAmp2) > 0.001) windAmp2 += 0.001f;
                    else if ((windAmp2 - windNewAmp2) > 0.001) windAmp2 -= 0.001f;
                    csound.setChannel("amp2", windAmp2);
                }
                if (windAmp3 != windNewAmp3) {
                    if ((windNewAmp3 - windAmp3) > 0.001) windAmp3 += 0.001f;
                    else if ((windAmp3 - windNewAmp3) > 0.001) windAmp3 -= 0.001f;
                    csound.setChannel("amp3", windAmp3);
                }
                if (windAmp4 != windNewAmp4) {
                    if ((windNewAmp4 - windAmp4) > 0.001) windAmp4 += 0.001f;
                    else if ((windAmp4 - windNewAmp4) > 0.001) windAmp4 -= 0.001f;
                    csound.setChannel("amp4", windAmp4);
                }

                // if (windX != windNewX) {
                //     if ((windNewX - windX) > 0.001) windX += 0.001f;
                //     else if ((windX - windNewX) > 0.001) windX -= 0.001f;
                //     csound.setChannel("WindX0", windX);
                // }
                // if (windY != windNewX) {
                //     if ((windNewY - windY) > 0.001) windY += 0.001f;
                //     else if ((windY - windNewY) > 0.001) windY -= 0.001f;
                //     csound.setChannel("WindY0", windY);
                // }
                // if (windZ != windNewX) {
                //     if ((windNewZ - windZ) > 0.001) windZ += 0.001f;
                //     else if ((windZ - windNewZ) > 0.001) windZ -= 0.001f;
                //     csound.setChannel("WindZ0", windZ);
                // }
        //         tiempo += Time.deltaTime;
 
        //  if (RoamingWind.transform.position.x > xMax) {
        //      windX = Random.Range(-velocidadMax, 0.0f);
        //      angulo = Mathf.Atan2(windX, windZ) * (180 / 3.141592f) + Random.Range(10, 45);
        //      RoamingWind.transform.rotation = Quaternion.Euler(0, angulo, 0);
        //      tiempo = 0.0f; 
        //  }
        //  if (RoamingWind.transform.position.x < xMin) {
        //      windX = Random.Range(0.0f, velocidadMax);
        //      angulo = Mathf.Atan2(windX, windZ) * (180 / 3.141592f) + Random.Range(10, 45);
        //      RoamingWind.transform.rotation = Quaternion.Euler(0, angulo, 0); 
        //      tiempo = 0.0f; 
        //  }

        //  if (RoamingWind.transform.position.y > yMax) {
        //      windY = Random.Range(-velocidadMax, 0.0f);
        //      angulo = Mathf.Atan2(windX, windY) * (180 / 3.141592f) + Random.Range(10, 45);
        //      RoamingWind.transform.rotation = Quaternion.Euler(angulo, 0, 0);
        //      tiempo = 0.0f; 
        //  }
        //  if (RoamingWind.transform.position.y < yMin) {
        //      windY = Random.Range(0.0f, velocidadMax);
        //      angulo = Mathf.Atan2(windX, windY) * (180 / 3.141592f) + Random.Range(10, 45);
        //      RoamingWind.transform.rotation = Quaternion.Euler(angulo, 0, 0); 
        //      tiempo = 0.0f; 
        //  }

        //  if (RoamingWind.transform.position.z > zMax) {
        //      windZ = Random.Range(-velocidadMax, 0.0f);
        //      angulo = Mathf.Atan2(windX, windZ) * (180 / 3.141592f) + Random.Range(10, 45);
        //      RoamingWind.transform.rotation = Quaternion.Euler(0, angulo, 0); 
        //      tiempo = 0.0f; 
        //  }
        //  if (RoamingWind.transform.position.z < zMin) {
        //      windZ = Random.Range(0.0f, velocidadMax);
        //      angulo = Mathf.Atan2(windX, windZ) * (180 / 3.141592f) + Random.Range(10, 45);
        //      RoamingWind.transform.rotation = Quaternion.Euler(0, angulo, 0);
        //      tiempo = 0.0f; 
        //  }


        //  if (tiempo > 1.0f) {
        //      windX = Random.Range(-velocidadMax, velocidadMax);
        //      windY = Random.Range(-velocidadMax, velocidadMax);
        //      windZ = Random.Range(-velocidadMax, velocidadMax);
        //      angulo = Mathf.Atan2(windX, windZ) * (180 / 3.141592f) + Random.Range(10, 45);
        //      RoamingWind.transform.rotation = Quaternion.Euler(0, angulo, 0);
        //      angulo = Mathf.Atan2(windX, windY) * (180 / 3.141592f) + Random.Range(10, 45);
        //      RoamingWind.transform.rotation = Quaternion.Euler(angulo, 0, 0);
        //      tiempo = 0.0f;
        //  }
 
        //  RoamingWind.transform.position = new Vector3(RoamingWind.transform.position.x + windX, RoamingWind.transform.position.y + windY, RoamingWind.transform.position.z + windZ);
        //  csound.setChannel("WindX0", Camera.main.transform.position.x - RoamingWind.transform.position.x);
        //  csound.setChannel("WindY0", Camera.main.transform.position.y - RoamingWind.transform.position.y);
        //  csound.setChannel("WindZ0", Camera.main.transform.position.z - RoamingWind.transform.position.z);
        //     // print("WindX " + RoamingWind.transform.position.x);
        //     // print("WindY " + RoamingWind.transform.position.y);
        //     // print("WindZ " + RoamingWind.transform.position.z);
        //       print("WindX0 " + csound.getChannel("Answer1"));
        //       print("WindY0 " + csound.getChannel("Answer2"));
        //       print("WindZ0 " + csound.getChannel("Answer3"));
        }
    }
    void Update()
    {
                tiempo += Time.deltaTime;
 
         if (RoamingWind.transform.position.x > xMax) {
             windX = Random.Range(-velocidadMax, 0.0f);
             angulo = Mathf.Atan2(windX, windZ) * (180 / 3.141592f) + Random.Range(10, 45);
             RoamingWind.transform.rotation = Quaternion.Euler(0, angulo, 0);
             tiempo = 0.0f; 
         }
         if (RoamingWind.transform.position.x < xMin) {
             windX = Random.Range(0.0f, velocidadMax);
             angulo = Mathf.Atan2(windX, windZ) * (180 / 3.141592f) + Random.Range(10, 45);
             RoamingWind.transform.rotation = Quaternion.Euler(0, angulo, 0); 
             tiempo = 0.0f; 
         }

         if (RoamingWind.transform.position.y > yMax) {
             windY = Random.Range(-velocidadMax, 0.0f);
             angulo = Mathf.Atan2(windX, windY) * (180 / 3.141592f) + Random.Range(10, 45);
             RoamingWind.transform.rotation = Quaternion.Euler(angulo, 0, 0);
             tiempo = 0.0f; 
         }
         if (RoamingWind.transform.position.y < yMin) {
             windY = Random.Range(0.0f, velocidadMax);
             angulo = Mathf.Atan2(windX, windY) * (180 / 3.141592f) + Random.Range(10, 45);
             RoamingWind.transform.rotation = Quaternion.Euler(angulo, 0, 0); 
             tiempo = 0.0f; 
         }

         if (RoamingWind.transform.position.z > zMax) {
             windZ = Random.Range(-velocidadMax, 0.0f);
             angulo = Mathf.Atan2(windX, windZ) * (180 / 3.141592f) + Random.Range(10, 45);
             RoamingWind.transform.rotation = Quaternion.Euler(0, angulo, 0); 
             tiempo = 0.0f; 
         }
         if (RoamingWind.transform.position.z < zMin) {
             windZ = Random.Range(0.0f, velocidadMax);
             angulo = Mathf.Atan2(windX, windZ) * (180 / 3.141592f) + Random.Range(10, 45);
             RoamingWind.transform.rotation = Quaternion.Euler(0, angulo, 0);
             tiempo = 0.0f; 
         }


         if (tiempo > 1.0f) {
             windX = Random.Range(-velocidadMax, velocidadMax);
             windY = Random.Range(-velocidadMax, velocidadMax);
             windZ = Random.Range(-velocidadMax, velocidadMax);
             angulo = Mathf.Atan2(windX, windZ) * (180 / 3.141592f) + Random.Range(10, 45);
             RoamingWind.transform.rotation = Quaternion.Euler(0, angulo, 0);
             angulo = Mathf.Atan2(windX, windY) * (180 / 3.141592f) + Random.Range(10, 45);
             RoamingWind.transform.rotation = Quaternion.Euler(angulo, 0, 0);
             tiempo = 0.0f;
         }
 
         RoamingWind.transform.position = new Vector3(RoamingWind.transform.position.x + windX, RoamingWind.transform.position.y + windY, RoamingWind.transform.position.z + windZ);
         csound.setChannel("WindX0", Camera.main.transform.position.x - RoamingWind.transform.position.x);
         csound.setChannel("WindY0", Camera.main.transform.position.y - RoamingWind.transform.position.y);
         csound.setChannel("WindZ0", Camera.main.transform.position.z - RoamingWind.transform.position.z);
            // print("WindX " + RoamingWind.transform.position.x);
            // print("WindY " + RoamingWind.transform.position.y);
            // print("WindZ " + RoamingWind.transform.position.z);
              print("WindX0 " + csound.getChannel("Answer1"));
              print("WindY0 " + csound.getChannel("Answer2"));
              print("WindZ0 " + csound.getChannel("Answer3"));
              
        if (((Camera.main.transform.position.x - RoamingWind.transform.position.x) < 5) && ((Camera.main.transform.position.y - RoamingWind.transform.position.y) < 5) && ((Camera.main.transform.position.z - RoamingWind.transform.position.z) < 5) ){
            csound.setChannel("SandGain", 0.3f);//Mathf.Abs(Camera.main.transform.position.x - RoamingWind.transform.position.x));
        } else csound.setChannel("SandGain", 0.0f);
    }
}

    // void Update()
    // {
    //     //yaw += speedH * Input.GetAxis("Mouse X");
    //     //pitch -= speedV * Input.GetAxis("Mouse Y");
    //     //transform.eulerAngles = new Vector3(-30f, yaw, 0.0f);

    //     // if(Input.GetKeyDown(KeyCode.Space))
    //     // {
    //     //     Invoke("Thunder", Random.Range(1, 3));
    //     //     Lightning();
    //     // }

    //     // if (Input.GetKeyDown(KeyCode.UpArrow))
    //     // {
    //     //     var particleEmission = GetComponentInChildren<ParticleSystem>().emission;
    //     //     particleEmission.rateOverTime = emissionNumber;
    //     //     emissionNumber = emissionNumber < 3000 ? emissionNumber + 100 : 3000;
    //     //     csound.setChannel("RainDens", emissionNumber / 2000f);
    //     // }
    //     // else if (Input.GetKeyDown(KeyCode.DownArrow))
    //     // {
    //     //     var particleEmission = rainParticles.emission;
    //     //     particleEmission.rateOverTime = emissionNumber;
    //     //     emissionNumber = emissionNumber>100 ? emissionNumber - 100 : 0;
    //     //     csound.setChannel("RainDens", emissionNumber / 2000f);
    //     // }
    // }

    // void WindSpeed()
    // {
    //     float windSpeed = (float)csound.getChannel("lowFreqWindSpeed");
    //     var particleVelocity = GetComponentInChildren<ParticleSystem>().velocityOverLifetime;
    //     particleVelocity.x = -windSpeed;
    // }

    // void OnGUI()
    // {
    //    GUI.TextArea(new Rect(Screen.width/2f-200, Screen.height - 50f, 400, 20), "Press Spacebar for Lightning. Up and Down arrows control rain fall");
    // }

    // void Lightning()
    // {
    //     if (lightningTimer < 4)
    //     {
    //         mainLight.intensity = Random.Range(0f, 20f);
    //         Invoke("Lightning", .1f);
    //         lightningTimer++;
    //     }
    //     else
    //     {
    //         mainLight.intensity = 0f;
    //         lightningTimer = 0;
    //     }
    // }

    // void Thunder()
    // {
    //     csound.setChannel("Thunder", Random.Range(1, 100));
    // }
 //}
