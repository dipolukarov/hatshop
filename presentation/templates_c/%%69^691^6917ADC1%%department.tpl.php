<?php /* Smarty version 2.6.27, created on 2013-08-29 17:04:27
         compiled from department.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'load_department', 'department.tpl', 2, false),)), $this); ?>
<?php echo smarty_function_load_department(array('assign' => 'department'), $this);?>

<p class="title"><?php echo $this->_tpl_vars['department']->mNameLabel; ?>
</p>
<br />
<p class="description"><?php echo $this->_tpl_vars['department']->mDescriptionLabel; ?>
</p>
<br />
Place list of products here