using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "NewUpgrade", menuName = "Upgrades/Movement/Dash")]
public class DashUpgrade : Upgrade
{
    public float dashCoolDown = 0;
    public bool recoil;
    public int recoilDamage = 0;
    public float dashForce = 0;
    public float nextDashTime = 0;

    public GameObject player;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    public override void PickUp()
    {
        
    }

    public override void Drop()
    {
        
    }

    public override void Passive()
    {
        if(Input.GetKeyDown(KeyCode.Mouse1) && Time.time >= nextDashTime)
        {
            Dash();
        }
    }

    public override void Active()
    {
        
    }

    void Dash()
    {
        nextDashTime = Time.time + dashCoolDown;

        if(recoil)
        {
            GameObject.FindWithTag("Player").GetComponentInChildren<SuperPupSystems.Helper.Health>().Damage(recoilDamage);
        }

        GameObject.FindWithTag("Player").GetComponentInChildren<Rigidbody>().AddForce(transform.forward * dashForce);

    }
}
