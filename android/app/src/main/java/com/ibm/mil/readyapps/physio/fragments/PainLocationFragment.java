/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */
package com.ibm.mil.readyapps.physio.fragments;

import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.ibm.mil.readyapps.physio.R;
import com.ibm.mil.readyapps.physio.activities.LandingActivity;
import com.ibm.mil.readyapps.physio.interfaces.BackPressHandler;
import com.ibm.mil.readyapps.physio.utils.AndroidUtils;
import com.ibm.mil.readyapps.physio.views.PhysioAlertDialog;
import com.ibm.mil.readyapps.physio.views.PhysioDialog;
import com.ibm.mil.readyapps.physio.views.ZoomableRelativeLayout;

import java.util.Vector;

/**
 * @class PainLocationFragment
 * <p/>
 * The fragment for the view that allows the user to place a marker on a graphic representation of
 * a body to track any pain experienced.
 * @see com.ibm.mil.readyapps.physio.fragments.PainLocationFragment
 */
public class PainLocationFragment extends Fragment implements BackPressHandler {

    RelativeLayout head, torso, shorts, r_top, r_bot, r_foot, l_top, l_bot, l_foot, r_arm, r_hand, l_arm, l_hand;
    RelativeLayout[] body;
    Vector<ImageView> pointers;
    RelativeLayout current;
    Button frontBtn, backBtn;
    ZoomableRelativeLayout zoomLayout;
    RelativeLayout bodyLayout;
    View root;
    Integer pageColor;

    boolean zoomed = false;
    boolean front = true;
    boolean blue = false;

    public PainLocationFragment() {
        // Required empty public constructor
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        root = inflater.inflate(R.layout.fragment_pain_location, container, false);
        bodyLayout = (RelativeLayout) root.findViewById(R.id.bodyContainer);
        zoomLayout = (ZoomableRelativeLayout) root.findViewById(R.id.zoomContainer);
        body = new RelativeLayout[13];
        pointers = new Vector<ImageView>();

        if (blue) {
            pageColor = getResources().getColor(R.color.ready_blue);
        } else {
            pageColor = getResources().getColor(R.color.ready_red);
        }

        bodyLayout.setOnTouchListener(bodyTouched);

        head = (RelativeLayout) root.findViewById(R.id.head);
        body[0] = head;
        torso = (RelativeLayout) root.findViewById(R.id.torso);
        body[1] = torso;
        shorts = (RelativeLayout) root.findViewById(R.id.shorts);
        body[2] = shorts;
        r_top = (RelativeLayout) root.findViewById(R.id.right_top);
        body[3] = r_top;
        r_bot = (RelativeLayout) root.findViewById(R.id.right_bot);
        body[4] = r_bot;
        r_foot = (RelativeLayout) root.findViewById(R.id.right_foot);
        body[5] = r_foot;
        l_top = (RelativeLayout) root.findViewById(R.id.left_top);
        body[6] = l_top;
        l_bot = (RelativeLayout) root.findViewById(R.id.left_bot);
        body[7] = l_bot;
        l_foot = (RelativeLayout) root.findViewById(R.id.left_foot);
        body[8] = l_foot;
        r_arm = (RelativeLayout) root.findViewById(R.id.right_arm);
        body[9] = r_arm;
        r_hand = (RelativeLayout) root.findViewById(R.id.right_hand);
        body[10] = r_hand;
        l_arm = (RelativeLayout) root.findViewById(R.id.left_arm);
        body[11] = l_arm;
        l_hand = (RelativeLayout) root.findViewById(R.id.left_hand);
        body[12] = l_hand;

        Button next = (Button) root.findViewById(R.id.nextButton);
        frontBtn = (Button) root.findViewById(R.id.frontButton);
        backBtn = (Button) root.findViewById(R.id.backButton);

        next.setOnClickListener(nextClick);
        frontBtn.setOnClickListener(frontClick);
        backBtn.setOnClickListener(backClick);
        next.setText(getResources().getText(R.string.next));
        frontBtn.setText(getResources().getText(R.string.front));
        backBtn.setText(getResources().getText(R.string.back));

        RelativeLayout top = (RelativeLayout) root.findViewById(R.id.topContainer);
        top.setBackgroundColor(pageColor);
        frontBtn.setTextColor(pageColor);
        TextView question = (TextView) root.findViewById(R.id.textView);
        if (blue) {
            question.setText(getResources().getText(R.string.what_injured));
        } else {
            question.setText(getResources().getText(R.string.what_hurts));
        }
        TextView select = (TextView) root.findViewById(R.id.textView2);
        select.setText(getResources().getText(R.string.select));

        return root;
    }

    @Override
    public void onStart() {
        super.onStart();

        if (!blue) {
            ((LandingActivity) getActivity()).hidePainButton(true);
        }
    }

    @Override
    public void onStop() {
        super.onStop();

        if (!blue) {
            ((LandingActivity) getActivity()).hidePainButton(false);
        }
    }

    /**
     * OnTouch listener for the body layout. Detects touches inside the body then translates that
     * touch to a body part in the bodies array. If the view is already zoomed in this will either
     * move the current marker.
     *
     * @param v    the view the touch occured in. This will always be the body layout.
     * @param e    the touch event
     * @return true if touch was a success
     * @see android.view.View.OnTouchListener
     */
    public View.OnTouchListener bodyTouched = new View.OnTouchListener() {

        public boolean onTouch(View v, MotionEvent e) {

            int x = (int) e.getX();
            int y = (int) e.getY();

            if (zoomed) {
                x = (int) ((float) x / zoomLayout.getScale() + zoomLayout.getCanvasLeft());
                y = (int) ((float) y / zoomLayout.getScale() + zoomLayout.getCanvasTop());
            }

            y += getYOffset();

            switch (e.getAction() & MotionEvent.ACTION_MASK) {
                case MotionEvent.ACTION_DOWN:

                    //Log.d("BODY_TOUCHDOWN", "TOUCH AT POINT: " + x + ", " + y);
                    RelativeLayout image = null;

                    for (int i = 0; i < body.length; i++) {

                        RelativeLayout temp = body[i];
                        Rect bounds = new Rect();
                        temp.getGlobalVisibleRect(bounds);

                        if (bounds.contains(x, y)) {
                            image = temp;
                            //Log.d("CHECK_VIEW", image + " was tapped.");
                        }

                    }

                    if (image != null) {
                        if (!zoomed)
                            zoomOnImage(image);
                        else {
                            if (image == current) {
                                if (pointers.size() != 0) {
                                    movePointer(x, y);
                                }
                            }
                        }
                    }
                    break;
                case MotionEvent.ACTION_MOVE:
                    //Log.d("BODY_MOVE", "MOVE_TO_POINT: " + x + ", " + y);

                    if (current == null) {
                        break;
                    }

                    Rect bounds = new Rect();
                    current.getGlobalVisibleRect(bounds);

                    if (bounds.contains(x, y) && zoomed && (pointers.size() != 0)) {
                        movePointer(x, y);
                    }

                    break;
                default:
                    break;
            }
            return true;
        }
    };

    /**
     * Pulls the bitmap image of the body part out of its RelativeLayout, colors it appropriatly,
     * and then tells the zoomLayout where it needs to zoom to. Also swaps the FRONT/BACK buttons
     * for the ADD/DELETE buttons.
     *
     * @param image the body part the touch occured in.
     */
    private void zoomOnImage(RelativeLayout image) {

        Bitmap bitm = ((BitmapDrawable) image.getBackground()).getBitmap();

        Bitmap temp = bitm.copy(bitm.getConfig(), true);
        int[] pixels = new int[temp.getHeight() * temp.getWidth()];

        temp.getPixels(pixels, 0, temp.getWidth(), 0, 0, temp.getWidth(), temp.getHeight());

        for (int i = 0; i < temp.getHeight() * temp.getWidth(); i++) {

            if (pixels[i] != 0) {

                int r, g, b;

                if (!blue) {
                    r = Color.red(pixels[i]) + 100;
                    if (r > 255) {
                        r = 255;
                    }
                    g = Color.green(pixels[i]) - 50;
                    b = Color.blue(pixels[i]) - 50;
                } else {
                    r = Color.red(pixels[i]) - 30;
                    g = Color.green(pixels[i]) + 15;
                    b = Color.blue(pixels[i]) + 100;
                    if (b > 255) {
                        b = 255;
                    }

                }
                pixels[i] = Color.argb(Color.alpha(pixels[i]), r, g, b);
            }
        }

        temp.setPixels(pixels, 0, temp.getWidth(), 0, 0, temp.getWidth(), temp.getHeight());
        image.setBackground(new BitmapDrawable(getResources(), temp));

        Rect rect = new Rect();
        image.getGlobalVisibleRect(rect);

        zoomLayout.zoomToRect(rect, 0, getYOffset());
        current = image;
        zoomed = true;
        swapButtons();

        placePointer(rect.centerX(), rect.centerY());

    }

    /**
     * Places a marker on the bodyLayout in the given location.
     *
     * @param x x location to place the marker.
     * @param y y location to place the marker.
     */
    private void placePointer(int x, int y) {

        y -= getYOffset();

        //Log.d("PLACE_POINTER", "Placing pointer at: " + x + ", " + y);

        Drawable pointer_im = getResources().getDrawable(R.drawable.pointer_3x);
        pointer_im.setBounds(0, 0, 44, 65);
        ImageView new_pointer = new ImageView(getActivity());
        new_pointer.setImageDrawable(pointer_im);
        new_pointer.setLayoutParams(setLayoutParams(x, y));
        bodyLayout.addView(new_pointer);

        pointers.add(new_pointer);
    }

    /**
     * Moves the current marker on the bodyLayout to the given location.
     *
     * @param x x location to move the marker.
     * @param y y location to move the marker.
     */
    private void movePointer(int x, int y) {

        y -= getYOffset();

        //Log.d("MOVE_POINTER", "Moving pointer to: " + x + ", " + y);

        ImageView pointer = pointers.elementAt(pointers.size() - 1);
        pointer.setLayoutParams(setLayoutParams(x, y));

        bodyLayout.invalidate();

    }

    /**
     * Creates layout parameters for the markers in the bodyLayout.
     *
     * @param x x location of the marker.
     * @param y y location of the marker.
     * @return layout paramameters for a marker in the bodyLayout.
     */
    private RelativeLayout.LayoutParams setLayoutParams(int x, int y) {

        int dip = dipToPixels(14);
        RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(dip, dip);
        lp.addRule(RelativeLayout.ALIGN_TOP);
        lp.addRule(RelativeLayout.ALIGN_LEFT);
        lp.leftMargin = x - dip / 2;
        lp.topMargin = y - dip;

        return lp;
    }

    @Override
    public boolean backPressed() {
        if (zoomed) {
            final PhysioAlertDialog alertDialog = new PhysioAlertDialog(getActivity());
            alertDialog.setPrimaryText(getResources().getText(R.string.exit));
            alertDialog.setSecondaryText(getResources().getString(R.string.information));
            if (!blue) {
                ColorDrawable color = new ColorDrawable(getResources().getColor(R.color.ready_red));
                alertDialog.setButtonDrawable(color);
            }
            alertDialog.setPositiveClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    resetView(front);
                    alertDialog.dismiss();
                }
            });
            alertDialog.setNegativeClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    alertDialog.dismiss();
                }
            });
            alertDialog.show();

            return true;
        }

        return false;
    }

    /**
     * OnClickListener for the "Next" button. Either continues to pain management screen, or
     * throws an alert of the pain location screen isn't complete yet.
     *
     * @param v    the button that is clicked.
     * @see android.view.View.OnClickListener
     */
    private View.OnClickListener nextClick = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            Log.d("NEXT_PRESSED", "You pressed next!");
            if (zoomed && !pointers.isEmpty()) {
                PainManagementFragment fragment = new PainManagementFragment();
                if (blue) {
                    fragment.enableFormLayout();
                }

                getFragmentManager()
                        .beginTransaction()
                        .replace(R.id.fragment_container, fragment)
                        .addToBackStack(null)
                        .commit();

                resetView(true);
            } else {
                final PhysioDialog dialog = new PhysioDialog(getActivity());
                Drawable icon;
                if (blue) {
                    icon = getResources().getDrawable(R.drawable.x_blue);
                } else {
                    icon = getResources().getDrawable(R.drawable.x_red);
                }
                dialog.getIcon().setImageDrawable(icon);
                dialog.getPrimaryMessage().setText(getResources().getString(R.string.warning));
                dialog.getSecondaryMessage().setVisibility(View.GONE);
                dialog.getButton().setVisibility(View.GONE);
                dialog.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        dialog.dismiss();
                    }
                });
                dialog.show();
            }
        }
    };

    /**
     * OnClickListener for the "FRONT/ADD" button. Either switches the view back to the front body
     * view, or adds a marker if already zoomed in.
     *
     * @param v    the button that is clicked.
     * @see android.view.View.OnClickListener
     */
    private View.OnClickListener frontClick = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            Log.d("FRONT_PRESSED", "You pressed front/add!");
            if (!zoomed) {
                if (!front) {
                    frontBtn.setTextColor(pageColor);
                    backBtn.setTextColor(getResources().getColor(R.color.ready_dark_gray));
                    front = true;

                    setMaleFront();
                }
            } else {
                Rect c_rect = new Rect();
                current.getGlobalVisibleRect(c_rect);
                placePointer(c_rect.centerX(), c_rect.centerY());

            }
        }
    };

    /**
     * OnClickListener for the "BACK/DELETE" button. Either switches the view to the back body
     * view, or removes the current marker if already zoomed in.
     *
     * @param v    the button that is clicked.
     * @see android.view.View.OnClickListener
     */
    private View.OnClickListener backClick = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            Log.d("BACK_PRESSED", "You pressed back/delete!");
            if (!zoomed) {
                if (front) {
                    frontBtn.setTextColor(getResources().getColor(R.color.ready_dark_gray));
                    backBtn.setTextColor(pageColor);
                    front = false;

                    setMaleBack();
                }
            } else {
                if (!pointers.isEmpty()) {
                    bodyLayout.removeView(pointers.elementAt(pointers.size() - 1));
                    pointers.remove(pointers.size() - 1);
                }
            }
        }
    };

    // Image Switch Functions

    /**
     * Switches the look of the FRONT and BACK buttons to make them the ADD and DELETE buttons
     * and visa-versa.
     */
    private void swapButtons() {

        if (zoomed) {

            Drawable l_pointer = getResources().getDrawable(R.drawable.pointerlight_3x);
            l_pointer.setBounds(0, 0, 44, 65);
            frontBtn.setCompoundDrawables(l_pointer, null, null, null);
            frontBtn.setLayoutParams(new LinearLayout.LayoutParams(dipToPixels(37), dipToPixels(34)));
            frontBtn.setTextColor(getResources().getColor(R.color.ready_dark_gray));
            frontBtn.setText("+");

            backBtn.setTextColor(getResources().getColor(R.color.ready_dark_gray));
            backBtn.setText(getResources().getText(R.string.delete));

        } else {

            frontBtn.setCompoundDrawables(null, null, null, null);
            frontBtn.setBackgroundColor(Color.WHITE);
            frontBtn.setLayoutParams(new LinearLayout.LayoutParams(dipToPixels(80), dipToPixels(34)));
            frontBtn.setText(getResources().getText(R.string.front));
            backBtn.setText(getResources().getText(R.string.back));
            if (front) {
                frontBtn.setTextColor(pageColor);
            } else {
                backBtn.setTextColor(pageColor);
            }

        }

    }

    /**
     * Lays out the body using the front images.
     */
    private void setMaleFront() {

        front = true;

        RelativeLayout.LayoutParams lp;

        lp = new RelativeLayout.LayoutParams(dipToPixels(42), dipToPixels(65));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.CENTER_IN_PARENT);
        lp.bottomMargin = dipToPixels(304);
        head.setLayoutParams(lp);
        head.setBackground(getResources().getDrawable(R.drawable.male_head_front_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(58), dipToPixels(101));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.CENTER_IN_PARENT);
        lp.bottomMargin = dipToPixels(206);
        torso.setLayoutParams(lp);
        torso.setBackground(getResources().getDrawable(R.drawable.male_torso_front_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(67), dipToPixels(41));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.CENTER_IN_PARENT);
        lp.bottomMargin = dipToPixels(168);
        shorts.setLayoutParams(lp);
        shorts.setBackground(getResources().getDrawable(R.drawable.male_groin_front_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(37), dipToPixels(67));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        lp.bottomMargin = dipToPixels(108);
        lp.leftMargin = dipToPixels(141);
        r_top.setLayoutParams(lp);
        r_top.setBackground(getResources().getDrawable(R.drawable.male_leftthigh_front_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(24), dipToPixels(76));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        lp.bottomMargin = dipToPixels(40);
        lp.leftMargin = dipToPixels(137);
        r_bot.setLayoutParams(lp);
        r_bot.setBackground(getResources().getDrawable(R.drawable.male_leftcalf_front_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(24), dipToPixels(42));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        lp.bottomMargin = dipToPixels(0);
        lp.leftMargin = dipToPixels(129);
        r_foot.setLayoutParams(lp);
        r_foot.setBackground(getResources().getDrawable(R.drawable.male_leftfoot_front_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(37), dipToPixels(67));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        lp.bottomMargin = dipToPixels(109);
        lp.leftMargin = dipToPixels(182);
        l_top.setLayoutParams(lp);
        l_top.setBackground(getResources().getDrawable(R.drawable.male_rightthigh_front_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(24), dipToPixels(76));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        lp.bottomMargin = dipToPixels(41);
        lp.leftMargin = dipToPixels(199);
        l_bot.setLayoutParams(lp);
        l_bot.setBackground(getResources().getDrawable(R.drawable.male_rightcalf_front_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(24), dipToPixels(42));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        lp.bottomMargin = dipToPixels(1);
        lp.leftMargin = dipToPixels(207);
        l_foot.setLayoutParams(lp);
        l_foot.setBackground(getResources().getDrawable(R.drawable.male_rightfoot_foot_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(73), dipToPixels(92));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        lp.bottomMargin = dipToPixels(215);
        lp.leftMargin = dipToPixels(87);
        r_arm.setLayoutParams(lp);
        r_arm.setBackground(getResources().getDrawable(R.drawable.male_leftarm_front_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(35), dipToPixels(35));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        lp.bottomMargin = dipToPixels(186);
        lp.leftMargin = dipToPixels(61);
        r_hand.setLayoutParams(lp);
        r_hand.setBackground(getResources().getDrawable(R.drawable.male_lefthand_front_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(73), dipToPixels(92));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        lp.bottomMargin = dipToPixels(215);
        lp.leftMargin = dipToPixels(200);
        l_arm.setLayoutParams(lp);
        l_arm.setBackground(getResources().getDrawable(R.drawable.male_rightarm_front_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(35), dipToPixels(35));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        lp.bottomMargin = dipToPixels(186);
        lp.leftMargin = dipToPixels(265);
        l_hand.setLayoutParams(lp);
        l_hand.setBackground(getResources().getDrawable(R.drawable.male_righthand_front_3x));

        bodyLayout.invalidate();

    }

    /**
     * Lays out the body using the back images.
     */
    private void setMaleBack() {

        front = false;

        RelativeLayout.LayoutParams lp;

        lp = new RelativeLayout.LayoutParams(dipToPixels(42), dipToPixels(65));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.CENTER_IN_PARENT);
        lp.bottomMargin = dipToPixels(303);
        head.setLayoutParams(lp);
        head.setBackground(getResources().getDrawable(R.drawable.male_head_back_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(58), dipToPixels(102));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.CENTER_IN_PARENT);
        lp.bottomMargin = dipToPixels(205);
        torso.setLayoutParams(lp);
        torso.setBackground(getResources().getDrawable(R.drawable.male_torso_back_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(66), dipToPixels(34));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.CENTER_IN_PARENT);
        lp.bottomMargin = dipToPixels(174);
        shorts.setLayoutParams(lp);
        shorts.setBackground(getResources().getDrawable(R.drawable.male_butt_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(39), dipToPixels(73));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        lp.bottomMargin = dipToPixels(108);
        lp.leftMargin = dipToPixels(141);
        r_top.setLayoutParams(lp);
        r_top.setBackground(getResources().getDrawable(R.drawable.male_leftthigh_back_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(22), dipToPixels(72));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        lp.bottomMargin = dipToPixels(42);
        lp.leftMargin = dipToPixels(137);
        r_bot.setLayoutParams(lp);
        r_bot.setBackground(getResources().getDrawable(R.drawable.male_leftcalf_back_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(20), dipToPixels(41));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        lp.bottomMargin = dipToPixels(3);
        lp.leftMargin = dipToPixels(129);
        r_foot.setLayoutParams(lp);
        r_foot.setBackground(getResources().getDrawable(R.drawable.male_leftfoot_back_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(39), dipToPixels(71));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        lp.bottomMargin = dipToPixels(107);
        lp.leftMargin = dipToPixels(180);
        l_top.setLayoutParams(lp);
        l_top.setBackground(getResources().getDrawable(R.drawable.male_rightthigh_back_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(22), dipToPixels(72));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        lp.bottomMargin = dipToPixels(41);
        lp.leftMargin = dipToPixels(201);
        l_bot.setLayoutParams(lp);
        l_bot.setBackground(getResources().getDrawable(R.drawable.male_rightcalf_back_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(20), dipToPixels(41));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        lp.bottomMargin = dipToPixels(2);
        lp.leftMargin = dipToPixels(211);
        l_foot.setLayoutParams(lp);
        l_foot.setBackground(getResources().getDrawable(R.drawable.male_rightfoot_back_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(71), dipToPixels(91));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        lp.bottomMargin = dipToPixels(215);
        lp.leftMargin = dipToPixels(87);
        r_arm.setLayoutParams(lp);
        r_arm.setBackground(getResources().getDrawable(R.drawable.male_leftarm_back_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(35), dipToPixels(35));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        lp.bottomMargin = dipToPixels(186);
        lp.leftMargin = dipToPixels(61);
        r_hand.setLayoutParams(lp);
        r_hand.setBackground(getResources().getDrawable(R.drawable.male_lefthand_back_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(71), dipToPixels(91));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        lp.bottomMargin = dipToPixels(215);
        lp.leftMargin = dipToPixels(200);
        l_arm.setLayoutParams(lp);
        l_arm.setBackground(getResources().getDrawable(R.drawable.male_rightarm_back_3x));

        lp = new RelativeLayout.LayoutParams(dipToPixels(35), dipToPixels(35));
        lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        lp.bottomMargin = dipToPixels(185);
        lp.leftMargin = dipToPixels(263);
        l_hand.setLayoutParams(lp);
        l_hand.setBackground(getResources().getDrawable(R.drawable.male_righthand_back_3x));

        bodyLayout.invalidate();

    }

    /**
     * Unused function for future implementation of female front asset layouts.
     */
    private void setFemaleFront() {

    }

    /**
     * Unused function for future implementation of female back asset layouts.
     */
    private void setFemaleBack() {

    }

    // Utility Functions

    /**
     * Allows the previous fragment to set if the view should be blue or red before
     * transition.
     *
     * @param isBlue Boolean to set if the view is blue.
     */
    public void setBlue(Boolean isBlue) {
        blue = isBlue;
    }

    /**
     * Calculates the y-offset for the bodyLayout to properly translate touch locations.
     *
     * @return the current y-offset from the top of the screen to bodyLayout.
     */
    private int getYOffset() {

        LandingActivity activity = (LandingActivity) getActivity();

        return (int) (zoomLayout.getY() + activity.getToolbarHeight() + AndroidUtils.getStatusBarHeight(getActivity()));
    }

    /**
     * Resets the view to it's initial zoomed-out state. Also removes all pointers and coloring.
     *
     * @param setFront Boolean to set if the view is front or back.
     */
    private void resetView(Boolean setFront) {

        zoomLayout.resetZoom();
        zoomed = false;
        current = null;

        swapButtons();
        front = setFront;
        if (front) {
            setMaleFront();
        } else {
            setMaleBack();
        }

        if (!pointers.isEmpty()) {
            for (int i = 0; i < pointers.size(); i++) {
                bodyLayout.removeView(pointers.elementAt(i));
            }
        }
        pointers.clear();
    }

    private int dipToPixels(int dp) {
        int px = Math.round(dp * (DisplayMetrics.DENSITY_XXHIGH / DisplayMetrics.DENSITY_DEFAULT));
        return px;
    }

}
