using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PickUpUpgrade : MonoBehaviour
{
    public UpgradeSystem upgradeSystem;
    public UpgradeHolder upgradeHolder;
    public GameObject popup;
    //public UpgradeDatabase dataBase;
    
    // Start is called before the first frame update

    void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            upgradeSystem = other.gameObject.GetComponent<UpgradeSystem>();
            //Cursor.lockState = CursorLockMode.None;
            //Cursor.visible = true;
            //popup.SetActive(true);
            //dataBase.OpenPopUp();
            //Time.timeScale = 0f;
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
