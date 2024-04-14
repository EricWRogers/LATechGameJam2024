using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class HotBar : MonoBehaviour
{
    public List<Image> imageIcons;
    public UpgradeSystem playerUpgradeSystem;
    
    // Start is called before the first frame update
    void Start()
    {
        playerUpgradeSystem = GameObject.FindWithTag("Player").GetComponent<UpgradeSystem>();
    }

    // Update is called once per frame
    void Update()
    {
        if(playerUpgradeSystem.upgrades.Count > 0)
        {
            UpdateHotBar();
        }
    }

    void UpdateHotBar()
    {
        for (int i = 0; i < imageIcons.Count; i++)
        {
            if (i < playerUpgradeSystem.upgrades.Count)
            {
                Debug.Log("Switch Icon Image with Upgrade Sprite");
                imageIcons[i].sprite = playerUpgradeSystem.upgrades[i].upgradeSprite;
            }
        }
    }
}
