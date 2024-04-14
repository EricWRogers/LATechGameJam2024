using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PickUpUpgrade : MonoBehaviour
{
    public UpgradeSystem upgradeSystem;
    public UpgradeHolder upgradeHolder;
    public PopUpChecker popUpChecker;

    void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            upgradeSystem = other.gameObject.GetComponent<UpgradeSystem>();
            popUpChecker = FindObjectOfType<PopUpChecker>();
            popUpChecker.isOpen = true;
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
