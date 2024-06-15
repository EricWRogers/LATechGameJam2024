using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Movement : MonoBehaviour
{
    public PauseMenu menu;
    public float moveSpeed = 5.0f;

    public float baseSpeed = 5.0f;

    public float maxVec = 10.0f;

    public float sprintSpeedMultiplier = 5.0f;

    public Vector3 jump;
    public float jumpForce = 2.0f;
    public bool isGrounded;

    private Vector2 input;

    private Rigidbody rb;
    private Vector3 m_lastPosition;
    private RaycastHit m_info;
    public LayerMask mask;
    public GameObject groundCheck;
    public UpgradeSystem upgradeSystem;
    public float mag;
    public bool antiSlip = true;
    public float mouseSensitivity = 2.0f;
    public float upDownRange = 60.0f;
    float verticalRotation = 0;

    public bool isSprinting;


    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
        jump = new Vector3(0.0f, 2.0f, 0.0f);
        Cursor.lockState = CursorLockMode.Locked;
    }

    // Update is called once per frame
    void Update()
    {
        input = new Vector2(Input.GetAxisRaw("Horizontal"), Input.GetAxisRaw("Vertical"));
        input.Normalize();
        if (Input.GetKey(KeyCode.LeftShift))
        {
            isSprinting = true;
            moveSpeed = baseSpeed * sprintSpeedMultiplier;
        }
        else if (!(Input.GetKey(KeyCode.LeftShift)))
        {
            isSprinting = false;
            moveSpeed = baseSpeed;
        }
        else
        {
            isSprinting = false;
            moveSpeed = baseSpeed;   
        }

        if ((Input.GetKeyDown(KeyCode.Space) || Input.GetKeyDown(KeyCode.Backspace)) && isGrounded)
        {

            rb.AddForce(jump * jumpForce, ForceMode.Impulse);
            isGrounded = false;
        }
       

        mag = Vector3.Magnitude(transform.position);
        upgradeSystem.ActivateEffects();
    }

    void FixedUpdate()
    {
        CollisionCheck();

        rb.AddForce(CalculateMovement(moveSpeed), ForceMode.Impulse);

        m_lastPosition = transform.position;
    }

     private void CollisionCheck()
        {
            isGrounded = false;
            Vector3 left = -transform.right * 0.5f;
            Vector3 right = transform.right * 0.5f;
            Vector3 back = -transform.forward * 0.5f;
            Vector3 forward = transform.forward * 0.5f;

            if (Physics.Linecast(transform.position+left, groundCheck.transform.position+left, out m_info, mask))
            {
                isGrounded = true;
            }
            
            if (Physics.Linecast(transform.position+right, groundCheck.transform.position+right, out m_info, mask))
            {
                isGrounded = true;
            }

            if (Physics.Linecast(transform.position+back, groundCheck.transform.position+back, out m_info, mask))
            {
                isGrounded = true;
            }

            if (Physics.Linecast(transform.position+forward, groundCheck.transform.position+forward, out m_info, mask))
            {
                isGrounded = true;
            }

            if (Physics.Linecast(transform.position, groundCheck.transform.position, out m_info, mask))
            {
                isGrounded = true;
            }
        }

    Vector3 CalculateMovement(float _speed)
    {
        Vector3 targetVelocity = new Vector3(input.x, 0.0f, input.y);
        targetVelocity = transform.TransformDirection(targetVelocity);

        targetVelocity *= _speed;

        Vector3 velocity = rb.velocity;

        // Get mouse input for cam rotation
        float rotX = Input.GetAxis("Mouse X") * mouseSensitivity;
        float rotY = Input.GetAxis("Mouse Y") * mouseSensitivity;

        // Rotate Player horizontally
        transform.Rotate(0, rotX, 0);

        // Rotate cam vertically

        verticalRotation -= rotY;
        verticalRotation = Mathf.Clamp(verticalRotation, -upDownRange, upDownRange);
        Camera.main.transform.localRotation = Quaternion.Euler(verticalRotation, 0, 0);

        if (mag > 0.5f&& antiSlip)
        {
            Vector3 velocityChange = targetVelocity - velocity;

            velocityChange.x = Mathf.Clamp(velocityChange.x, -maxVec, maxVec);
            velocityChange.z = Mathf.Clamp(velocityChange.z, -maxVec, maxVec);

            velocityChange.y = 0.0f;

            return (velocityChange);
        }
        else
        {
            return new Vector3();
        }
        

    }

    public void DestroyMovingAround()
    {
        Destroy(this);
    }
}
