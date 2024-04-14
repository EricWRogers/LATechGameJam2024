using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using TMPro;

public class UpgradeSystem : MonoBehaviour
{
     [Header("Component")]
    //public TextMeshProUGUI upgradeCountText;
    //public TextMeshProUGUI upgradeNameText;
    
    public List<Upgrade> upgrades;
    //public Upgrade core;
    public bool activate;
    public int upgradeCount;

    //public string endScreen;

    public void AddUpgrade(Upgrade upgrade)
    {
        upgrades.Add(upgrade);
        upgrade.PickUp();
        //SetUpgradeText();
        upgradeCount++;

        for (int i = 0; i<upgrades.Count-1;i++)
        {
            upgrades[i].active = false;
        }

        upgrades[upgrades.Count-1].active = true;
       
    }

    public void PopUpgrade()
    {
        if(upgrades.Count!=0)
        {
            upgrades[upgrades.Count-1].Drop();
            upgrades.RemoveAt(upgrades.Count-1);
        }
        
        upgradeCount--;
        // if(!upgrades.Contains(core))
        // {
        //     Debug.Log("DIE" + gameObject.name +core.upgradeName + "NotFound");
        //     //DIE();
        // }
//        SetUpgradeText();

    }

    public void PrintList()
    {
        for(int i = 0; i < upgrades.Count; i++)
        {
            Debug.Log(upgrades[i].upgradeName);
        }
    }

    public void ActivateEffects()
    {
        Upgrade current;
        if (GameObject.FindWithTag("Player") != null) 
        {
            GameObject player = GameObject.FindWithTag("Player");
            if (player.GetComponent<Movement>() != null)
            {
                //player.GetComponent<Movement>().moveSpeed = 8;
            }
            // if (player.GetComponent<WeaponParent>() != null)
            // {
            //     //player.GetComponent<WeaponParent>().attackDamage = 1;
            //     //player.GetComponent<BaseAttack>().attackRange = 2.0f;
            // }
            for (int i = 0; i < upgrades.Count; i++)
            {
                //Debug.Log(i);
                current = upgrades[i];
                current.Passive();

                if (i==upgrades.Count-1)
                {
                    current.Active();
                }
            }
        }
    }
    // Start is called before the first frame update

    // public void DIE()
    // {
    //     Cursor.visible = false;
    //     Cursor.lockState = CursorLockMode.Locked;
    //     SceneManager.LoadScene(endScreen);
    // }

    // private void SetUpgradeText()
    // {
    //     upgradeCount = upgrades.Count;
    //     upgradeCountText.text = upgrades.Count.ToString();
    //     if (upgradeCount-1 >= 0)
    //     {
    //     upgradeNameText.text = ("Top Upgrade: " + upgrades[upgradeCount-1].upgradeName);
    //     }
    //     else
    //     {
    //         upgradeNameText.text = ("Top Upgrade: " + "None");
    //     }
    // }

    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        //SetUpgradeText();
        //ActivateEffects();
    }

}
