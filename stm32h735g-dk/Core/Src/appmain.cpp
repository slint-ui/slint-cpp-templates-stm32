
#include <main.h>
#include <slint-stm32.h>
#include <stdio.h>
#include <stm32h735g_discovery.h>
#include <stm32h735g_discovery_lcd.h>
#include <stm32h735g_discovery_ts.h>

#include "app-window.h"

extern "C" int appmain(void) {
  COM_InitTypeDef comlog;

  comlog.BaudRate = 115200;
  comlog.WordLength = COM_WORDLENGTH_8B;
  comlog.StopBits = COM_STOPBITS_1;
  comlog.Parity = COM_PARITY_NONE;
  comlog.HwFlowCtl = COM_HWCONTROL_NONE;

  BSP_COM_Init(COM1, &comlog);

  printf("Hello World\n");

  if (BSP_LCD_InitEx(0, LCD_ORIENTATION_LANDSCAPE, LCD_PIXEL_FORMAT_RGB565,
                     LCD_DEFAULT_WIDTH, LCD_DEFAULT_HEIGHT) != 0) {
    Error_Handler();
  }

  BSP_LCD_DisplayOn(0);
  BSP_LCD_SetActiveLayer(0, 0);

  TS_Init_t hTS;
  hTS.Width = LCD_DEFAULT_WIDTH;
  hTS.Height = LCD_DEFAULT_HEIGHT;
  hTS.Orientation = TS_SWAP_XY;
  hTS.Accuracy = 0;
  /* Touchscreen initialization */
  if (BSP_TS_Init(0, &hTS) != 0) {
    Error_Handler();
  }

  slint_stm32_init(SlintPlatformConfiguration());

  auto app_window = AppWindow::create();

  app_window->on_request_increase_value(
      [&] { app_window->set_counter(app_window->get_counter() + 1); });

  app_window->run();

  return 0;
}