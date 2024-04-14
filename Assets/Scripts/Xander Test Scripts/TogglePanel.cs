using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TogglePanel : MonoBehaviour
{
    public GameObject panel;
    public GameObject upgrade;
    public GameObject upgradeSystem;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
     void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            panel.SetActive(!panel.active);
        }

        if (Input.GetKeyDown(KeyCode.P))
        {
            upgradeSystem.GetComponent<UpgradeSystem>().AddUpgrade(upgrade.GetComponent<UpgradeHolder>().upgrade);
        }
        /*if (Input.GetKeyDown(KeyCode.O))
        {
            upgradeSystem.GetComponent<UpgradeSystem>().PopUpgrade(/*upgradeSystem.GetComponent<UpgradeSystem>().upgradeCount-1);
        }*/
    }
}
