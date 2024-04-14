using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "NewUpgrade", menuName = "Upgrades/Movement/Dash")]
public class DashUpgrade : Upgrade
{
    // public float dashCoolDown = 0;
    // public bool recoil;
    // public int recoilDamage = 0;
    // public float dashForce = 0;
    // public float nextDashTime = 0;
    // public float dashDuration = 2;
    // public float dashEnd = 0;

    // public GameObject player;
    // // Start is called before the first frame update
    // void Start()
    // {
        
    // }

    // // Update is called once per frame
    // public override void PickUp()
    // {
    //     player = GameObject.FindWithTag("Player");
    //     nextDashTime = 0;
    //     dashEnd = 0;
    // }

    // public override void Drop()
    // {
        
    // }

    // public override void Passive()
    // {
    //     if(Time.time>)
    //     {

    //     }
    //     if(Input.GetKeyDown(KeyCode.E) && Time.time >= nextDashTime)
    //     {
    //         Dash();
    //     }
    // }

    // public override void Active()
    // {
        
    // }

    // void Dash()
    // {
    //     nextDashTime = Time.time + dashCoolDown;

    //     if(recoil)
    //     {
    //         player.GetComponent<SuperPupSystems.Helper.Health>().Damage(recoilDamage);
    //     }

    //     player.GetComponent<Rigidbody>().AddForce(GameObject.FindWithTag("Player").GetComponentInChildren<Camera>().gameObject.transform.forward * dashForce,ForceMode.Impulse);

    // }
}
