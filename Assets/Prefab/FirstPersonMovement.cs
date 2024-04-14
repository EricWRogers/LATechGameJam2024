using UnityEngine;

public class FirstPersonMovement : MonoBehaviour
{
    public PauseMenu menu;
    public float jumpForce = 5f;

    public float movementSpeed = 5.0f;
    public float mouseSensitivity = 2.0f;
    public float upDownRange = 60.0f;
    public UpgradeSystem upgradeSystem;

    float verticalRotation = 0;

    private Rigidbody rigi;

    // Awake is called before Start right as the game initalizes.
    void Awake()
    {
        rigi = GetComponent<Rigidbody>();

    }
    // Start is called before the first frame update
    void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;
    }

    // Update is called once per frame
    void Update()
    {



        if (!menu.isGamePaused)
        {
            if (Cursor.lockState != CursorLockMode.Locked)
            {
                Cursor.lockState = CursorLockMode.Locked;
            }
            Move();
        }
        else
        {

            Cursor.lockState = CursorLockMode.None;

        }
    }

    void Move()
    {


        // Getting movement input
        float dirX = Input.GetAxis("Horizontal") * movementSpeed * Time.deltaTime;
        float dirZ = Input.GetAxis("Vertical") * movementSpeed * Time.deltaTime;

        // Move the player
        transform.Translate(new Vector3(dirX, 0, dirZ));

        // Get mouse input for cam rotation
        float rotX = Input.GetAxis("Mouse X") * mouseSensitivity;
        float rotY = Input.GetAxis("Mouse Y") * mouseSensitivity;

        // Rotate Player horizontally
        transform.Rotate(0, rotX, 0);

        // Rotate cam vertically

        verticalRotation -= rotY;
        verticalRotation = Mathf.Clamp(verticalRotation, -upDownRange, upDownRange);
        Camera.main.transform.localRotation = Quaternion.Euler(verticalRotation, 0, 0);

        if (Input.GetKeyDown(KeyCode.Space) && Mathf.Abs(rigi.velocity.y) < 0.01f)
        {
            rigi.AddForce(Vector3.up * jumpForce, ForceMode.Impulse);
        }
        upgradeSystem.ActivateEffects();

    }
}
