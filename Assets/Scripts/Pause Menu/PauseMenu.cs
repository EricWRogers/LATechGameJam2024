using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEngine.SceneManagement;

public class PauseMenu : MonoBehaviour
{
    public bool isGamePaused = false;

    public GameObject pauseMenuUI;

    public GameObject healthBar;
    public GameObject PowerUpSection;
    public GameObject TMSection;
    public GameObject GunSection;

    void Start()
    {
        //pauseMenuUI.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.Escape))
        {
            if(isGamePaused)
            {
                Resume();
            }else
            {
                Pause();
            }
        }   
    }

    public void Resume()
    {
        Debug.Log("Resume Button Was Hit");
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
        pauseMenuUI.SetActive(false);
        healthBar.SetActive(true);
        GunSection.SetActive(true);
        PowerUpSection.SetActive(true);
        TMSection.SetActive(true);
        Time.timeScale = 1.0f;
        isGamePaused = false;
    }

    public void Pause()
    {
        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
        pauseMenuUI.SetActive(true);
        healthBar.SetActive(false);
        GunSection.SetActive(false);
        PowerUpSection.SetActive(false);
        TMSection.SetActive(false);
        Time.timeScale = 0.0f;
        isGamePaused = true;
    }

    public void LoadMenu()
    {
        Debug.Log("Loading Main Menu");
        Time.timeScale = 1.0f;
        SceneManager.LoadSceneAsync("MainMenu");
    }

    public void QuitGame()
    {
        #if(UNITY_EDITOR)
        Debug.Log("Quiting Play Mode");
        EditorApplication.ExitPlaymode();
        #else
        Debug.Log("Quitting Build");
        Application.Quit();
        #endif
    }
}
