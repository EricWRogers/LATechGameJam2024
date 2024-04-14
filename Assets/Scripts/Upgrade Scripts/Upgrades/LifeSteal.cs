using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LifeSteal : MonoBehaviour
{
    public bool recoil = false;
    public bool drain = false;
    public int recoilDamage = 1;
    public float lifeStealRatio = 0.5f;
    // Start is called before the first frame update
    void Awake()
    {
        if(recoil)
        {
            GameObject.FindWithTag("Player").GetComponentInChildren<SuperPupSystems.Helper.Health>().Damage(recoilDamage);
        }
    }

    public void Drain()
    {
        if(drain)
        {
            GameObject.FindWithTag("Player").GetComponent<SuperPupSystems.Helper.Health>().Heal((int)(GetComponent<SuperPupSystems.Helper.Bullet>().damage*lifeStealRatio));
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
