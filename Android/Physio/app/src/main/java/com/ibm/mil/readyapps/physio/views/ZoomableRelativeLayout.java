/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.views;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewParent;
import android.widget.RelativeLayout;


/**
 * @class ZoomableRelativeLayout
 *
 * An extension of the standard RelativeLayout that allows a developer to zoom in on a specific
 * region of their view. Currently only allows for a pseudo-"ZoomToRect" function, but could
 * be extended to handle touch gesture or other types of scaling.
 *
 * @see com.ibm.mil.readyapps.zoomableRL
 *
 */
public class ZoomableRelativeLayout extends RelativeLayout {

    static float mScaleFactor = 1.0f;

    static Rect mClipBound;
    private float mPosX;
    private float mPosY;
    float c_height, c_width;

    public ZoomableRelativeLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
        if (!isInEditMode()) {
            setWillNotDraw(false);
            mClipBound = new Rect();
        }

    }

    public ZoomableRelativeLayout(Context context) {
        super(context);
        if (!isInEditMode()) {
            setWillNotDraw(false);
            mClipBound = new Rect();
        }

    }

    @Override
    public ViewParent invalidateChildInParent(int[] location, Rect dirty) {
        return super.invalidateChildInParent(location, dirty);
    }

    @Override
    protected void onLayout(boolean changed, int l, int t, int r, int b) {
        int count = getChildCount();
        for (int i = 0; i < count; i++) {
            View child = getChildAt(i);
            if (child.getVisibility() != GONE) {
                RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) child
                        .getLayoutParams();
                child.layout((int) (params.leftMargin),
                        (int) (params.topMargin),
                        (int) (params.leftMargin + child.getMeasuredWidth()),
                        (int) (params.topMargin + child.getMeasuredHeight()));
            }
        }
    }

    @Override
    protected void dispatchDraw(Canvas canvas) {
        canvas.save();

        if (mScaleFactor == 1.0f) {

            float [] pos = new float [2];
            canvas.getMatrix().mapPoints(pos);

            mPosX = pos[0];
            mPosY = pos[1];
            c_height = canvas.getHeight();
            c_width = canvas.getWidth();
        }

        canvas.scale(mScaleFactor, mScaleFactor);
        canvas.translate(mPosX, mPosY);


        super.dispatchDraw(canvas);

        mClipBound = canvas.getClipBounds();
        canvas.restore();
    }

    /**
     * Calculates a point for the canvas to zoom to and center in the layout.
     *
     * @param rect  the Rect to be zoomed and centered on.
     * @param xOffset   the x offset of the layout.
     * @param yOffset   the y offset of the layout.
     *
     */
    public void zoomToRect(Rect rect, int xOffset, int yOffset) {

        mScaleFactor = 2.8f;
        mPosX = -(rect.centerX() - xOffset) + (c_width/2)/mScaleFactor;
        mPosY = -(rect.centerY() - yOffset) + (c_height/2)/mScaleFactor;

        invalidate();
        requestLayout();

    }

    /**
     * Resets the layout to default. (Zooms out the view usually.)
     *
     */
    public void resetZoom() {

        mScaleFactor = 1.0f;

        invalidate();
        requestLayout();

    }

    /**
     * Allows outside classes to check the canvas scale to properly calculate a touch offset.
     *
     * @return      scale of the canvas.
     */
    public float getScale() {

        return mScaleFactor;

    }

    /**
     * Allows outside classes to check the canvas top bounds to properly calculate a touch offset.
     *
     * @return      top value of the canvas bounds.
     */
    public int getCanvasTop() {

        return mClipBound.top;
    }

    /**
     * Allows outside classes to check the canvas left bounds to properly calculate a touch offset.
     *
     * @return      left value of the canvas bounds.
     */
    public int getCanvasLeft() {

        return mClipBound.left;
    }
}