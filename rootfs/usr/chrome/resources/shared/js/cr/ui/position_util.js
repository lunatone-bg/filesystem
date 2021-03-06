// Copyright (c) 2010 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/**
 * @fileoverview This file provides utility functions for position popups.
 */

cr.define('cr.ui', function() {

  /**
   * Type def for rects as returned by getBoundingClientRect.
   * @typedef { {left: number, top: number, width: number, height: number,
   *             right: number, bottom: number}}
   */
  var Rect;

  /**
   * Enum for defining how to anchor a popup to an anchor element.
   * @enum {number}
   */
  const AnchorType = {
    /**
     * The popop's right edge is aligned with the left edge of the anchor.
     * The popup's top edge is aligned with the top edge of the anchor's top
     * edge.
     */
    BEFORE: 1,  // p: right, a: left, p: top, a: top

    /**
     * The popop's left edge is aligned with the right edge of the anchor.
     * The popup's top edge is aligned with the top edge of the anchor's top
     * edge.
     */
    AFTER: 2,  // p: left a: right, p: top, a: top

    /**
     * The popop's bottom edge is aligned with the top edge of the anchor.
     * The popup's left edge is aligned with the left edge of the anchor's top
     * edge.
     */
    ABOVE: 3,  // p: bottom, a: top, p: left, a: left

    /**
     * The popop's top edge is aligned with the bottom edge of the anchor.
     * The popup's left edge is aligned with the left edge of the anchor's top
     * edge.
     */
    BELOW: 4  // p: top, a: bottom, p: left, a: left
  };

  /**
   * Helper function for positionPopupAroundElement and positionPopupAroundRect.
   * @param {!Rect} anchorRect The rect for the anchor.
   * @param {!HTMLElement} popupElement The element used for the popup.
   * @param {AnchorType} type The type of anchoring to do.
   */
  function positionPopupAroundRect(anchorRect, popupElement, type) {
    var popupRect = popupElement.getBoundingClientRect();
    var popupContainer = popupElement.offsetParent;
    var availRect = popupContainer.getBoundingClientRect();
    var rtl = popupElement.ownerDocument.defaultView.
        getComputedStyle(popupElement).direction == 'rtl';

    // Flip BEFORE, AFTER based on RTL.
    if (rtl) {
      if (type == AnchorType.BEFORE)
        type = AnchorType.AFTER;
      else if (type == AnchorType.AFTER)
        type = AnchorType.BEFORE;
    }

    // Flip type based on available size
    switch (type) {
      case AnchorType.BELOW:
        if (anchorRect.bottom + popupRect.height > availRect.height)
          type = AnchorType.ABOVE;
        break;
      case AnchorType.ABOVE:
        if (popupRect.height > anchorRect.top)
          type = AnchorType.BELOW;
        break;
      case AnchorType.AFTER:
        if (anchorRect.right + popupRect.width > availRect.width)
          type = AnchorType.BEFORE;
        break;
      case AnchorType.BEFORE:
        if (popupRect.width > anchorRect.left)
          type = AnchorType.AFTER;
        break;
    }
    // flipping done

    var style = popupElement.style;
    // Reset all directions.
    style.left = style.right = style.top = style.bottom = 'auto'

    // Primary direction
    switch (type) {
      case AnchorType.BELOW:
        style.top = anchorRect.bottom + 'px';
        break;
      case AnchorType.ABOVE:
        style.bottom = availRect.height - anchorRect.top + 'px';
        break;
      case AnchorType.AFTER:
        style.left = anchorRect.right + 'px';
        break;
      case AnchorType.BEFORE:
        style.right = availRect.width - anchorRect.left + 'px';
        break;
    }

    // Secondary direction
    switch (type) {
      case AnchorType.BELOW:
      case AnchorType.ABOVE:
        if (rtl) {
          // align right edges
          if (anchorRect.right - popupRect.width >= 0) {
            style.right = availRect.width - anchorRect.right + 'px';

          // align left edges
          } else if (anchorRect.left + popupRect.width <= availRect.width) {
            style.left = anchorRect.left + 'px';

          // not enough room on either side
          } else {
            style.right = '0';
          }
        } else {
          // align left edges
          if (anchorRect.left + popupRect.width <= availRect.width) {
            style.left = anchorRect.left + 'px';

          // align right edges
          } else if (anchorRect.right - popupRect.width >= 0) {
            style.right = availRect.width - anchorRect.right + 'px';

          // not enough room on either side
          } else {
            style.left = '0';
          }
        }
        break;

      case AnchorType.AFTER:
      case AnchorType.BEFORE:
        // align top edges
        if (anchorRect.top + popupRect.height <= availRect.height) {
          style.top = anchorRect.top + 'px';

        // align bottom edges
        } else if (anchorRect.bottom - popupRect.height >= 0) {
          style.bottom = availRect.height - anchorRect.bottom + 'px';

          // not enough room on either side
        } else {
          style.top = '0';
        }
        break;
    }
  }

  /**
   * Positions a popup element relative to an anchor element. The popup element
   * should have position set to absolute and it should be a child of the body
   * element.
   * @param {!HTMLElement} anchorElement The element that the popup is anchored
   *     to.
   * @param {!HTMLElement} popupElement The popup element we are positioning.
   * @param {AnchorType} type The type of anchoring we want.
   */
  function positionPopupAroundElement(anchorElement, popupElement, type) {
    var anchorRect = anchorElement.getBoundingClientRect();
    positionPopupAroundRect(anchorRect, popupElement, type);
  }

  /**
   * Positions a popup around a point.
   * @param {number} x The client x position.
   * @param {number} y The client y position.
   * @param {!HTMLElement} popupElement The popup element we are positioning.
   */
  function positionPopupAtPoint(x, y, popupElement) {
    var rect = {
      left: x,
      top: y,
      width: 0,
      height: 0,
      right: x,
      bottom: y
    };
    positionPopupAroundRect(rect, popupElement, AnchorType.BELOW);
  }

  // Export
  return {
    AnchorType: AnchorType,
    positionPopupAroundElement: positionPopupAroundElement,
    positionPopupAtPoint: positionPopupAtPoint
  };
});
