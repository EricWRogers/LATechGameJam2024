using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PickUpUpgrade : MonoBehaviour
{
    public UpgradeSystem upgradeSystem;
    public UpgradeHolder upgradeHolder;
    // Start is called before the first frame update

    void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            upgradeSystem.AddUpgrade(upgradeHolder.upgrade);
            Destroy(gameObject);
        }
    }
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
