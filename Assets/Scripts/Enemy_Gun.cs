using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy_Gun : MonoBehaviour
{
    public float timer = 5.0f;
    public GameObject Bullet_Enemy;
    public float bulletTime;
    public Transform spawnPoint;

    public GameObject flash1;
    public GameObject flash2;
    public GameObject flash3;


    void Start()
    {
       
    }

    void Update()
    {
        
        ShootAtPlayer();


    }
    void ShootAtPlayer()
    {
        bulletTime -= Time.deltaTime;

        if (bulletTime > 0) return;

        bulletTime = timer;

        GameObject bulletObj = Instantiate(Bullet_Enemy, spawnPoint.transform.position, spawnPoint.transform.rotation) as GameObject;
        MuzzleFlash();
        Invoke("Delay", .08f);
    }


    public void MuzzleFlash()
    {
        flash1.SetActive(false);
        flash2.SetActive(false);
        flash3.SetActive(false);
        int rand = Random.Range(0, 2);

        switch (rand)
        {
            case 0:
                flash1.SetActive(true);
                break;
            case 1:
                flash2.SetActive(true);
                break;
            case 2:
                flash3.SetActive(true);
                break;

        }

    }

    void Delay()
    {
        flash1.SetActive(false);
        flash2.SetActive(false);
        flash3.SetActive(false);
    }
}



