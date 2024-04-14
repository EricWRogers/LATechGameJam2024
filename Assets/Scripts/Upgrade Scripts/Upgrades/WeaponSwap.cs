using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "NewUpgrade", menuName = "Upgrades/Weapons")]
public class WeaponSwap : Upgrade
{
   
    public GameObject newBullet;
    public GameObject oldBullet;
    public float bulletSpeed = 10f;

    public float fireRate = 0.2f;
    public int ammo = 10000;
    public int damagePerShot = 20;
    public float weaponRange = 50f;

    public int fireMode = 0;

    public bool destroyOnImpact = true;
    public bool recoil = false;
    public int recoilDamage = 0;
    public bool lifeSteal = false;
    public float lifeStealRatio = 0.5f;

    public Gun gun;
    private Gun m_gun;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    public override void PickUp()
    {
        if(GameObject.FindWithTag("Player").GetComponentInChildren<Gun>()!=null)
        {
            gun = GameObject.FindWithTag("Player").GetComponentInChildren<Gun>();
            
            oldBullet = gun.bulletPrefab;
            gun.bulletPrefab = newBullet;
            gun.bulletPrefab.GetComponent<SuperPupSystems.Helper.Bullet>().speed = bulletSpeed;
            gun.bulletPrefab.GetComponent<SuperPupSystems.Helper.Bullet>().damage = damagePerShot;
            gun.bulletPrefab.GetComponent<SuperPupSystems.Helper.Bullet>().lifeTime = weaponRange;
            gun.bulletPrefab.GetComponent<SuperPupSystems.Helper.Bullet>().destroyOnImpact = destroyOnImpact;
            gun.bulletPrefab.GetComponent<LifeSteal>().recoil = recoil;
            gun.bulletPrefab.GetComponent<LifeSteal>().recoilDamage = recoilDamage;
            gun.bulletPrefab.GetComponent<LifeSteal>().drain = lifeSteal;
            gun.bulletPrefab.GetComponent<LifeSteal>().lifeStealRatio = lifeStealRatio;
            gun.fireRate = fireRate;
            gun.ammo = ammo;
            gun.fireMode = fireMode;
        }
    }

    public override void Drop()
    {
        if(GameObject.FindWithTag("Player").GetComponentInChildren<Gun>()!=null)
        {
            gun.bulletPrefab = oldBullet;
        }
    }

    public override void Passive()
    {
        gun.bulletPrefab.GetComponent<LifeSteal>().recoil = false;
    }

    public override void Active()
    {
        gun.bulletPrefab.GetComponent<LifeSteal>().recoil = recoil;
    }
}
