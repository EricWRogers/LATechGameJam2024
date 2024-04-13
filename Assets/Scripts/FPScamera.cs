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
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }

    // Update is called once per frame
    void Update()
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
        float mouseX = Input.GetAxis("Mouse X") * sensitivity;
        float mouseY = Input.GetAxis("Mouse Y") * sensitivity;

        player.Rotate(Vector3.up * mouseX);
       


        rotationX -= mouseY;
        rotationX = Mathf.Clamp(rotationX, -90f, 30f);
        


        playerCamera.transform.localRotation = Quaternion.Euler(rotationX, 0f, 0f);
    }
    private void StopMouseMovement(bool stop)
    {
        if (stop)
        {
            Cursor.lockState = CursorLockMode.Locked; 
            Cursor.visible = false; 
        }
        else
        {
            Cursor.lockState = CursorLockMode.None; 
            Cursor.visible = true; 
        }
    }
}




