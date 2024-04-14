using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FPScamera : MonoBehaviour
{
    public float sensitivity = 2.0f;

    public Transform player;
    public Camera playerCamera;

    public PauseMenu pausedGame;

    private float rotationX = 0f;
 

    // Start is called before the first frame update
    void Start()
    {
        StopMouseMovement(false);
    }

    // Update is called once per frame
    void LateUpdate()
    {
        if(pausedGame.isGamePaused == false)
        {
            MouseMovement();
        }else{
            StopMouseMovement(true);
        }
    }

    private void MouseMovement()
    {
        float mouseX = Input.GetAxis("Mouse X") * sensitivity * Time.deltaTime;
        float mouseY = Input.GetAxis("Mouse Y") * sensitivity * Time.deltaTime;

        player.Rotate(Vector3.up * mouseX);
       


        rotationX -= mouseY;
        rotationX = Mathf.Clamp(rotationX, -90f, 60f);
        


        playerCamera.transform.localRotation = Quaternion.Euler(rotationX, 0f, 0f);
    }

    public void DestroyPlayerLooking()
    {
        Destroy(this);
    }

    private void StopMouseMovement(bool stop)
    {
        if (stop)
        {
            Cursor.lockState = CursorLockMode.None; 
            Cursor.visible = true; 
        }
        else
        {
            Cursor.lockState = CursorLockMode.Locked; 
            Cursor.visible = false; 
        }
    }
}




