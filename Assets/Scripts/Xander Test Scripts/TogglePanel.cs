using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TogglePanel : MonoBehaviour
{
    public GameObject panel;
    public GameObject upgrade;
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
            upgrade.GetComponent<UpgradeHolder>().upgrade.PickUp();
        }
        if (Input.GetKeyDown(KeyCode.D))
        {
            upgrade.GetComponent<UpgradeHolder>().upgrade.Drop();
        }
    }
}
