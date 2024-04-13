using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy_Gun : MonoBehaviour
{
    public GameObject Bullet_Enemy;
    public bool stopSpawing = false;
    public float spawnTime;
    public float spawnDelay;

    void Start()
    {
        InvokeRepeating("SpawnObject", spawnTime, spawnDelay);
    }


    public void SpawnObject()
    {
        Instantiate(Bullet_Enemy, transform.position, Quaternion.identity);
        if (stopSpawing)
        {
            CancelInvoke("SpawnObject");
        }
    }

}
