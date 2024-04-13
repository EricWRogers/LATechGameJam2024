using UnityEngine;

public class Gun : MonoBehaviour
{
    public PauseMenu pausedGame;
    public AudioSource audio;

    public Transform firePoint;
    public GameObject bulletPrefab;
    public float bulletSpeed = 10f;

    public float fireRate = 0.2f;
    public float weaponRange = 50f;
    public int damagePerShot = 20;

    public int ammo = 10;

    private float nextFireTime;

    public int fireMode = 0;


    // Update is called once per frame

    private void Start()
    {
        UnityEngine.Rendering.DebugManager.instance.enableRuntimeUI = false;

        if (pausedGame == null)
        {
            pausedGame = new PauseMenu();
        }
    }
    void Update()
    {
        if (Input.GetButtonDown("Fire1") && Time.time >= nextFireTime && ammo != 0 && fireMode == 0 && pausedGame != null && pausedGame.isGamePaused == false)
        {
            ShootPrefab();
            //ShootRaycast();
            audio.Play();
            ammo--;

        }

        if (Input.GetButton("Fire1") && Time.time >= nextFireTime && ammo != 0 && fireMode == 1 && pausedGame != null && pausedGame.isGamePaused == false)
        {
            audio.Play();
            ShootPrefab();
            ammo--;
        }

        if (Input.GetKeyDown(KeyCode.R) && pausedGame != null && pausedGame.isGamePaused == false)
        {
            ammo = 10;
        }
    }

    void ShootPrefab()
    {
        nextFireTime = Time.time + fireRate;

        GameObject bullet = Instantiate(bulletPrefab, firePoint.position, transform.rotation);
        //Rigidbody rigi = bullet.GetComponentInChildren<Rigidbody>();
        //rigi.AddForce(firePoint.forward * bulletSpeed, ForceMode.Impulse);
        Destroy(bullet, 3f);
    }

    void ShootRaycast()
    {
        nextFireTime = Time.time + fireRate;

        RaycastHit hit;

        if (Physics.Raycast(firePoint.position, firePoint.forward, out hit, weaponRange))
        {
            if (hit.transform.CompareTag("Enemy"))
            {
                Debug.Log("Hit!");
            }
        }
    }
}
