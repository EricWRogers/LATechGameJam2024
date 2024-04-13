using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy_Gun : MonoBehaviour
{
    public float timer = 5.0f;
    public GameObject Bullet_Enemy;
    public float bulletTime;
    public Transform spawnPoint;



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
    }


    
}



