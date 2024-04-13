using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Movement : MonoBehaviour
{
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



    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
        jump = new Vector3(0.0f, 2.0f, 0.0f);
    }

    // Update is called once per frame
    void Update()
    {
        input = new Vector2(Input.GetAxisRaw("Horizontal"), Input.GetAxisRaw("Vertical"));
        input.Normalize();
        if (Input.GetKey(KeyCode.LeftShift))
        {
            moveSpeed = baseSpeed * sprintSpeedMultiplier;
        }
        else if (!(Input.GetKey(KeyCode.LeftShift)))
        {
            moveSpeed = baseSpeed;
        }
        else
        {
            moveSpeed = baseSpeed;   
        }

        if ((Input.GetKeyDown(KeyCode.Space) || Input.GetKeyDown(KeyCode.Mouse1)) && isGrounded)
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
            if (Physics.Linecast(transform.position, groundCheck.transform.position, out m_info, mask))
            {
                isGrounded = true;
            }
            else
            {
                isGrounded = false;
            }
        }

    Vector3 CalculateMovement(float _speed)
    {
        Vector3 targetVelocity = new Vector3(input.x, 0.0f, input.y);
        targetVelocity = transform.TransformDirection(targetVelocity);

        targetVelocity *= _speed;

        Vector3 velocity = rb.velocity;

        if (mag > 0.5f)
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
